<?php

function ss360_ai_gateway_ensure_schema($conn)
{
    static $schema_checked = false;
    if ($schema_checked) {
        return;
    }

    $create_sql = "CREATE TABLE IF NOT EXISTS ai_model_providers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        provider VARCHAR(50) NOT NULL,
        model VARCHAR(150) NOT NULL,
        api_key TEXT NOT NULL,
        endpoint_url VARCHAR(255) NOT NULL,
        api_format VARCHAR(30) NOT NULL DEFAULT 'openai_compatible',
        priority INT NOT NULL DEFAULT 100,
        is_active TINYINT(1) NOT NULL DEFAULT 1,
        daily_limit INT NULL DEFAULT NULL,
        daily_usage_count INT NOT NULL DEFAULT 0,
        usage_date DATE NULL DEFAULT NULL,
        cooldown_until DATETIME NULL DEFAULT NULL,
        last_error TEXT NULL DEFAULT NULL,
        last_error_at DATETIME NULL DEFAULT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NULL DEFAULT NULL,
        UNIQUE KEY uniq_ai_provider_name (name),
        KEY idx_ai_provider_active (is_active, priority),
        KEY idx_ai_provider_cooldown (cooldown_until)
    )";
    mysqli_query($conn, $create_sql);

    $schema_checked = true;
}

function ss360_extract_json_object($content)
{
    $content = trim((string)$content);

    if (preg_match('/```(?:json)?\s*(.*?)\s*```/s', $content, $matches)) {
        $content = trim($matches[1]);
    }

    $start = strpos($content, '{');
    $end = strrpos($content, '}');
    if ($start !== false && $end !== false && $end > $start) {
        $content = substr($content, $start, $end - $start + 1);
    }

    return json_decode($content, true);
}

function ss360_ai_gateway_get_providers($conn)
{
    ss360_ai_gateway_ensure_schema($conn);

    $today = date('Y-m-d');
    mysqli_query($conn, "UPDATE ai_model_providers SET daily_usage_count = 0, usage_date = '$today' WHERE usage_date IS NULL OR usage_date <> '$today'");

    $sql = "SELECT *
        FROM ai_model_providers
        WHERE is_active = 1
          AND (cooldown_until IS NULL OR cooldown_until <= NOW())
          AND (daily_limit IS NULL OR daily_usage_count < daily_limit)
        ORDER BY daily_usage_count ASC, priority ASC, id ASC";

    $result = mysqli_query($conn, $sql);
    $providers = [];
    while ($result && $row = mysqli_fetch_assoc($result)) {
        $providers[] = $row;
    }

    return $providers;
}

function ss360_ai_gateway_mark_success($conn, $provider_id)
{
    $provider_id = (int)$provider_id;
    $today = date('Y-m-d');
    mysqli_query($conn, "UPDATE ai_model_providers
        SET daily_usage_count = daily_usage_count + 1,
            usage_date = '$today',
            cooldown_until = NULL,
            last_error = NULL,
            updated_at = NOW()
        WHERE id = $provider_id");
}

function ss360_ai_gateway_mark_failure($conn, $provider_id, $message, $http_status = null)
{
    $provider_id = (int)$provider_id;
    $message = mysqli_real_escape_string($conn, substr((string)$message, 0, 1000));
    $cooldown_minutes = ((int)$http_status === 429) ? 10 : 2;

    mysqli_query($conn, "UPDATE ai_model_providers
        SET cooldown_until = DATE_ADD(NOW(), INTERVAL $cooldown_minutes MINUTE),
            last_error = '$message',
            last_error_at = NOW(),
            updated_at = NOW()
        WHERE id = $provider_id");
}

function ss360_ai_gateway_json_error($message, $debug = [])
{
    return [
        'status' => 'error',
        'message' => $message,
        'debug' => $debug,
    ];
}

function ss360_ai_gateway_post_json($url, $headers, $payload, $timeout = 45)
{
    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
    curl_setopt($ch, CURLOPT_TIMEOUT, $timeout);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);

    $response = curl_exec($ch);
    if (curl_errno($ch)) {
        $message = curl_error($ch);
        curl_close($ch);
        return ss360_ai_gateway_json_error('AI provider connection failed: ' . $message, [
            'type' => 'curl_error',
            'detail' => $message,
        ]);
    }

    $http_status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    return [
        'status' => 'success',
        'http_status' => $http_status,
        'raw_response' => (string)$response,
        'decoded' => json_decode((string)$response, true),
    ];
}

function ss360_ai_gateway_openai_payload($provider, $messages, $temperature, $options)
{
    $payload = [
        'model' => $provider['model'],
        'messages' => $messages,
        'temperature' => $temperature,
        'stream' => false,
    ];

    if (!empty($options['response_format_json'])) {
        $payload['response_format'] = ['type' => 'json_object'];
    }

    return $payload;
}

function ss360_ai_gateway_google_payload($messages, $temperature, $options)
{
    $system_parts = [];
    $contents = [];

    foreach ($messages as $message) {
        $role = ($message['role'] ?? '') === 'assistant' ? 'model' : 'user';
        $content = (string)($message['content'] ?? '');

        if (($message['role'] ?? '') === 'system') {
            $system_parts[] = ['text' => $content];
            continue;
        }

        $contents[] = [
            'role' => $role,
            'parts' => [['text' => $content]],
        ];
    }

    $payload = [
        'contents' => $contents,
        'generationConfig' => [
            'temperature' => $temperature,
        ],
    ];

    if ($system_parts) {
        $payload['systemInstruction'] = ['parts' => $system_parts];
    }

    if (!empty($options['response_format_json'])) {
        $payload['generationConfig']['responseMimeType'] = 'application/json';
    }

    return $payload;
}

function ss360_ai_gateway_call_provider($provider, $messages, $temperature, $options)
{
    $format = strtolower((string)$provider['api_format']);
    $endpoint = (string)$provider['endpoint_url'];
    $api_key = (string)$provider['api_key'];

    if ($format === 'google_gemini') {
        $url = str_replace('{model}', rawurlencode($provider['model']), $endpoint);
        $separator = strpos($url, '?') === false ? '?' : '&';
        $url .= $separator . 'key=' . rawurlencode($api_key);
        $headers = ['Content-Type: application/json'];
        $payload = ss360_ai_gateway_google_payload($messages, $temperature, $options);
    } else {
        $url = $endpoint;
        $headers = [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $api_key,
        ];
        $payload = ss360_ai_gateway_openai_payload($provider, $messages, $temperature, $options);
    }

    $result = ss360_ai_gateway_post_json($url, $headers, $payload);
    if ($result['status'] !== 'success') {
        return $result;
    }

    $decoded = is_array($result['decoded']) ? $result['decoded'] : [];
    $http_status = (int)$result['http_status'];

    if ($http_status >= 400) {
        $error = $decoded['error'] ?? [];
        $message = is_array($error) ? ($error['message'] ?? 'AI provider returned an error.') : 'AI provider returned an error.';
        $failed_generation = trim((string)(is_array($error) ? ($error['failed_generation'] ?? '') : ''));

        if (!empty($options['recover_failed_generation']) && $failed_generation !== '') {
            return [
                'status' => 'success',
                'content' => $failed_generation,
                'recovered' => true,
                'debug' => [
                    'type' => 'recovered_failed_generation',
                    'http_status' => $http_status,
                    'message' => $message,
                ],
            ];
        }

        return ss360_ai_gateway_json_error($message, [
            'type' => 'provider_error',
            'http_status' => $http_status,
            'raw_response' => substr($result['raw_response'], 0, 1000),
        ]) + ['http_status' => $http_status];
    }

    if ($format === 'google_gemini') {
        $content = $decoded['candidates'][0]['content']['parts'][0]['text'] ?? '';
    } else {
        $content = $decoded['choices'][0]['message']['content'] ?? '';
    }

    if (trim((string)$content) === '') {
        return ss360_ai_gateway_json_error('AI provider returned an empty response.', [
            'type' => 'empty_response',
            'raw_response' => substr($result['raw_response'], 0, 1000),
        ]);
    }

    return [
        'status' => 'success',
        'content' => $content,
    ];
}

function ss360_ai_chat_json($conn, $messages, $temperature = 0.35, $options = [])
{
    $options = array_merge([
        'response_format_json' => true,
        'recover_failed_generation' => false,
    ], $options);

    $providers = ss360_ai_gateway_get_providers($conn);
    if (!$providers) {
        return ss360_ai_gateway_json_error('No active AI providers are configured.');
    }

    $attempts = [];
    foreach ($providers as $provider) {
        $provider_label = $provider['name'] . ' (' . $provider['provider'] . ')';
        $result = ss360_ai_gateway_call_provider($provider, $messages, $temperature, $options);

        if ($result['status'] !== 'success') {
            ss360_ai_gateway_mark_failure($conn, $provider['id'], $result['message'], $result['http_status'] ?? null);
            $attempts[] = [
                'provider' => $provider_label,
                'message' => $result['message'],
                'debug' => $result['debug'] ?? null,
            ];
            continue;
        }

        if (!empty($result['recovered'])) {
            ss360_ai_gateway_mark_success($conn, $provider['id']);
            return [
                'status' => 'success',
                'data' => [
                    'reply' => $result['content'],
                    'suggested_prompts' => [],
                    'insights' => [
                        'strengths' => [],
                        'weaknesses' => [],
                        'trends' => [],
                        'recommendations' => [],
                    ],
                ],
                'provider' => $provider_label,
                'debug' => $result['debug'] ?? null,
            ];
        }

        $json = ss360_extract_json_object($result['content']);
        if (!is_array($json)) {
            ss360_ai_gateway_mark_failure($conn, $provider['id'], 'AI provider returned unreadable JSON.');
            $attempts[] = [
                'provider' => $provider_label,
                'message' => 'AI provider returned unreadable JSON.',
                'debug' => [
                    'type' => 'invalid_json',
                    'raw_content' => substr((string)$result['content'], 0, 1000),
                ],
            ];
            continue;
        }

        ss360_ai_gateway_mark_success($conn, $provider['id']);
        return [
            'status' => 'success',
            'data' => $json,
            'provider' => $provider_label,
        ];
    }

    return ss360_ai_gateway_json_error('All configured AI providers failed or are temporarily cooling down.', [
        'attempts' => $attempts,
    ]);
}
