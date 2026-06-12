CREATE TABLE IF NOT EXISTS ss360_platform_admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    school_id INT NOT NULL,
    status TINYINT(1) NOT NULL DEFAULT 1,
    datecreated DATETIME NULL,
    UNIQUE KEY uniq_ss360_platform_admin (staff_id, school_id),
    KEY idx_ss360_platform_admin_status (status)
);
