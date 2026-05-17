CREATE TABLE IF NOT EXISTS `ai_model_providers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `provider` varchar(50) NOT NULL,
  `model` varchar(150) NOT NULL,
  `api_key` text NOT NULL,
  `endpoint_url` varchar(255) NOT NULL,
  `api_format` varchar(30) NOT NULL DEFAULT 'openai_compatible',
  `priority` int NOT NULL DEFAULT 100,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `daily_limit` int DEFAULT NULL,
  `daily_usage_count` int NOT NULL DEFAULT 0,
  `usage_date` date DEFAULT NULL,
  `cooldown_until` datetime DEFAULT NULL,
  `last_error` text,
  `last_error_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_ai_provider_name` (`name`),
  KEY `idx_ai_provider_active` (`is_active`, `priority`),
  KEY `idx_ai_provider_cooldown` (`cooldown_until`)
);

INSERT INTO `ai_model_providers`
(`name`, `provider`, `model`, `api_key`, `endpoint_url`, `api_format`, `priority`, `is_active`)
VALUES
('GLM-4.7-Flash', 'zAI', 'glm-4.7-flash', 'PASTE_ZAI_API_KEY_HERE', 'https://api.z.ai/api/paas/v4/chat/completions', 'openai_compatible', 10, 1),
('gpt-oss-120b', 'groq', 'openai/gpt-oss-120b', 'PASTE_GROQ_API_KEY_HERE', 'https://api.groq.com/openai/v1/chat/completions', 'openai_compatible', 20, 1),
('Qwen2-2B', 'groq', 'qwen/qwen3-32b', 'PASTE_GROQ_API_KEY_HERE', 'https://api.groq.com/openai/v1/chat/completions', 'openai_compatible', 30, 1),
('Gemini', 'Google', 'gemini-2.5-flash-lite', 'PASTE_GOOGLE_API_KEY_HERE', 'https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent', 'google_gemini', 40, 1),
('Openrouter', 'Openrouter', 'minimax/minimax-m2.5:free', 'PASTE_OPENROUTER_API_KEY_HERE', 'https://openrouter.ai/api/v1/chat/completions', 'openai_compatible', 50, 1),
('MiniMax: MiniMax M2.5', 'openrouter', 'minimax/minimax-m2.5', 'PASTE_OPENROUTER_API_KEY_HERE', 'https://openrouter.ai/api/v1/chat/completions', 'openai_compatible', 60, 1)
ON DUPLICATE KEY UPDATE
  `provider` = VALUES(`provider`),
  `model` = VALUES(`model`),
  `api_key` = VALUES(`api_key`),
  `endpoint_url` = VALUES(`endpoint_url`),
  `api_format` = VALUES(`api_format`),
  `priority` = VALUES(`priority`),
  `is_active` = VALUES(`is_active`),
  `updated_at` = NOW();
