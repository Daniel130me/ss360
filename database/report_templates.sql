CREATE TABLE IF NOT EXISTS `report_templates` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL DEFAULT 0,
  `session_id` INT DEFAULT NULL,
  `term_id` VARCHAR(20) NOT NULL DEFAULT 'default',
  `template_name` VARCHAR(120) NOT NULL,
  `template_json` LONGTEXT NOT NULL,
  `is_default` TINYINT(1) NOT NULL DEFAULT 0,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `createdby` INT DEFAULT NULL,
  `updatedby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  `dateupdated` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_report_templates_lookup` (`school_id`, `session_id`, `term_id`, `is_default`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
