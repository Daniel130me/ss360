<?php

function ss360_get_ai_config()
{
    // Temporary testing key. Move this back to GROQ_API_KEY/SS360_AI_API_KEY after testing.
    $api_key = "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";
    if (empty($api_key)) {
        $api_key = getenv('GROQ_API_KEY') ?: getenv('SS360_AI_API_KEY');
    }
    $endpoint = getenv('GROQ_API_ENDPOINT') ?: 'https://api.groq.com/openai/v1/chat/completions';
    $model = getenv('GROQ_MODEL') ?: 'qwen/qwen3-32b';

    return [
        'api_key' => $api_key,
        'endpoint' => $endpoint,
        'model' => $model,
    ];
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

function ss360_ai_chat_json($messages, $temperature = 0.35)
{
    $config = ss360_get_ai_config();
    if (empty($config['api_key'])) {
        return [
            'status' => 'error',
            'message' => 'AI assistant is not configured. Please set GROQ_API_KEY or SS360_AI_API_KEY on the server.',
        ];
    }

    $payload = [
        'model' => $config['model'],
        'messages' => $messages,
        'temperature' => $temperature,
        'response_format' => ['type' => 'json_object'],
    ];

    $ch = curl_init($config['endpoint']);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
    curl_setopt($ch, CURLOPT_TIMEOUT, 45);
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        'Content-Type: application/json',
        'Authorization: Bearer ' . $config['api_key'],
    ]);

    $response = curl_exec($ch);
    if (curl_errno($ch)) {
        $message = curl_error($ch);
        curl_close($ch);
        return ['status' => 'error', 'message' => 'AI provider connection failed: ' . $message];
    }

    $http_status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $decoded = json_decode($response, true);
    if ($http_status >= 400) {
        $message = $decoded['error']['message'] ?? 'AI provider returned an error.';
        return ['status' => 'error', 'message' => $message, 'http_status' => $http_status];
    }

    $content = $decoded['choices'][0]['message']['content'] ?? '';
    $json = ss360_extract_json_object($content);
    if (!is_array($json)) {
        return ['status' => 'error', 'message' => 'AI provider returned an unreadable response.'];
    }

    return ['status' => 'success', 'data' => $json];
}
