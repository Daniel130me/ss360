CREATE TABLE IF NOT EXISTS `bus_tracking_settings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `update_interval_seconds` INT NOT NULL DEFAULT 20,
  `stale_after_seconds` INT NOT NULL DEFAULT 90,
  `min_movement_meters` INT NOT NULL DEFAULT 30,
  `max_accuracy_meters` INT NOT NULL DEFAULT 100,
  `history_retention_days` INT NOT NULL DEFAULT 30,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `createdby` INT DEFAULT NULL,
  `updatedby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  `dateupdated` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_bus_tracking_settings_school` (`school_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `school_buses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `bus_name` VARCHAR(120) NOT NULL,
  `bus_number` VARCHAR(60) DEFAULT NULL,
  `plate_number` VARCHAR(60) DEFAULT NULL,
  `driver_staff_id` INT DEFAULT NULL,
  `assistant_staff_id` INT DEFAULT NULL,
  `driver_phone` VARCHAR(30) DEFAULT NULL,
  `capacity` INT DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `createdby` INT DEFAULT NULL,
  `updatedby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  `dateupdated` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_school_buses_school_status` (`school_id`, `status`),
  KEY `idx_school_buses_driver` (`school_id`, `driver_staff_id`, `assistant_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bus_routes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `route_name` VARCHAR(150) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `to_school_label` VARCHAR(120) NOT NULL DEFAULT 'Going to school',
  `to_home_label` VARCHAR(120) NOT NULL DEFAULT 'Going home',
  `route_polyline` LONGTEXT DEFAULT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `createdby` INT DEFAULT NULL,
  `updatedby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  `dateupdated` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bus_routes_school_status` (`school_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bus_route_stops` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `route_id` INT NOT NULL,
  `stop_name` VARCHAR(150) NOT NULL,
  `latitude` DECIMAL(10,7) NOT NULL,
  `longitude` DECIMAL(10,7) NOT NULL,
  `stop_order` INT NOT NULL DEFAULT 0,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `createdby` INT DEFAULT NULL,
  `updatedby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  `dateupdated` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bus_route_stops_route_order` (`school_id`, `route_id`, `stop_order`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bus_student_assignments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `bus_id` INT NOT NULL,
  `route_id` INT DEFAULT NULL,
  `stop_id` INT DEFAULT NULL,
  `student_id` INT NOT NULL,
  `pickup_status` VARCHAR(30) NOT NULL DEFAULT 'pending',
  `dropoff_status` VARCHAR(30) NOT NULL DEFAULT 'pending',
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `createdby` INT DEFAULT NULL,
  `updatedby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  `dateupdated` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_bus_student_active` (`school_id`, `student_id`, `status`),
  KEY `idx_bus_assignments_bus` (`school_id`, `bus_id`, `status`),
  KEY `idx_bus_assignments_student` (`school_id`, `student_id`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bus_trips` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `bus_id` INT NOT NULL,
  `route_id` INT DEFAULT NULL,
  `direction` VARCHAR(20) NOT NULL,
  `trip_status` VARCHAR(20) NOT NULL DEFAULT 'active',
  `started_by` INT NOT NULL,
  `stopped_by` INT DEFAULT NULL,
  `started_at` DATETIME NOT NULL,
  `stopped_at` DATETIME DEFAULT NULL,
  `createdby` INT DEFAULT NULL,
  `updatedby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  `dateupdated` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bus_trips_active` (`school_id`, `bus_id`, `trip_status`),
  KEY `idx_bus_trips_route` (`school_id`, `route_id`, `trip_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bus_locations` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `bus_id` INT NOT NULL,
  `trip_id` INT NOT NULL,
  `latitude` DECIMAL(10,7) NOT NULL,
  `longitude` DECIMAL(10,7) NOT NULL,
  `accuracy_meters` DECIMAL(8,2) DEFAULT NULL,
  `speed_mps` DECIMAL(8,2) DEFAULT NULL,
  `heading_degrees` DECIMAL(6,2) DEFAULT NULL,
  `battery_percent` INT DEFAULT NULL,
  `recorded_at` DATETIME NOT NULL,
  `createdby` INT DEFAULT NULL,
  `datecreated` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_bus_locations_trip_latest` (`trip_id`, `id`),
  KEY `idx_bus_locations_school_bus_time` (`school_id`, `bus_id`, `recorded_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `bus_current_locations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `school_id` INT NOT NULL,
  `bus_id` INT NOT NULL,
  `trip_id` INT NOT NULL,
  `last_location_id` BIGINT DEFAULT NULL,
  `latitude` DECIMAL(10,7) NOT NULL,
  `longitude` DECIMAL(10,7) NOT NULL,
  `accuracy_meters` DECIMAL(8,2) DEFAULT NULL,
  `speed_mps` DECIMAL(8,2) DEFAULT NULL,
  `heading_degrees` DECIMAL(6,2) DEFAULT NULL,
  `battery_percent` INT DEFAULT NULL,
  `recorded_at` DATETIME NOT NULL,
  `dateupdated` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_bus_current_location` (`school_id`, `bus_id`),
  KEY `idx_bus_current_trip` (`school_id`, `trip_id`),
  KEY `idx_bus_current_updated` (`school_id`, `dateupdated`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
