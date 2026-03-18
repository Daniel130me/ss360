-- Bluehost Database Schema for Assesshub Cloud Control Panel

CREATE TABLE IF NOT EXISTS `schools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `school_name` varchar(255) NOT NULL,
  `license_key` varchar(50) NOT NULL UNIQUE,
  `contact_email` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  `ai_enabled` tinyint(1) DEFAULT '1',
  `ai_provider` varchar(50) DEFAULT 'openrouter',
  `ai_model` varchar(100) DEFAULT 'mistralai/mistral-7b-instruct',
  `ai_key` varchar(255) DEFAULT NULL,
  `sync_enabled` tinyint(1) DEFAULT '1',
  `max_devices` int(11) DEFAULT '1',
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `school_id` int(11) NOT NULL,
  `hardware_id` varchar(100) NOT NULL,
  `device_name` varchar(100) DEFAULT NULL,
  `last_check_in` datetime DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `school_hwid` (`school_id`,`hardware_id`),
  CONSTRAINT `fk_school_device` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `app_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version_code` varchar(20) NOT NULL UNIQUE,
  `release_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_critical` tinyint(1) DEFAULT '0',
  `changelog` text,
  `download_url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `global_announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text NOT NULL,
  `message_type` varchar(20) DEFAULT 'info', /* info, warning, danger */
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sync Mirror Tables
-- These tables hold data pushed up from the local SQLite databases.
-- The Primary Key is a composite of the local 'id' and the 'school_id' to prevent collisions.

CREATE TABLE IF NOT EXISTS `sync_assessments` (
  `local_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT '0',
  `instruction` text,
  `number_of_questions` int(11) DEFAULT '0',
  `subject_id` int(11) DEFAULT NULL,
  `class_ids` varchar(255) DEFAULT NULL,
  `last_synced_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`local_id`, `school_id`),
  CONSTRAINT `fk_sync_ass_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `sync_questions` (
  `local_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `ass_id` varchar(255) DEFAULT NULL, -- usually derived from title/subject mapping locally
  `question` text,
  `last_synced_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`local_id`, `school_id`),
  CONSTRAINT `fk_sync_q_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `sync_options` (
  `local_id` int(11) NOT NULL,
  `school_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `options` text,
  `answer` varchar(255) DEFAULT NULL,
  `last_synced_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`local_id`, `school_id`),
  CONSTRAINT `fk_sync_opt_school` FOREIGN KEY (`school_id`) REFERENCES `schools` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed Data (For Testing)
INSERT INTO `schools` (`school_name`, `license_key`, `ai_key`) VALUES ('Demo School', 'DEMO-KEY-123', 'test-api-key');
INSERT INTO `app_versions` (`version_code`, `changelog`, `download_url`) VALUES ('1.0.0', 'Initial Cloud-Connected Release', 'https://yourdomain.com/updates/v1.0.0.zip');
