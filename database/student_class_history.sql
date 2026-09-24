-- Durable, term-level student class history.
--
-- Foreign keys are intentionally deferred. Existing installations contain legacy
-- orphaned and conflicting class references; adding constraints before the
-- recovery audit is resolved would make this migration fail. Application-level
-- school ownership checks remain mandatory for every write.

CREATE TABLE IF NOT EXISTS student_class_enrollments (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    school_id INT NOT NULL,
    student_id INT NOT NULL,
    session_id INT NOT NULL,
    term_id TINYINT NOT NULL,
    class_id INT NOT NULL,
    confidence ENUM('confirmed', 'inferred', 'manual') NOT NULL DEFAULT 'manual',
    source VARCHAR(50) NOT NULL DEFAULT 'manual',
    createdby INT DEFAULT NULL,
    updatedby INT DEFAULT NULL,
    datecreated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dateupdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_student_class_period (school_id, student_id, session_id, term_id),
    KEY idx_class_period_roster (school_id, session_id, term_id, class_id, student_id),
    KEY idx_student_history (school_id, student_id, session_id, term_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS student_class_movements (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    school_id INT NOT NULL,
    student_id INT NOT NULL,
    from_class_id INT DEFAULT NULL,
    to_class_id INT NOT NULL,
    effective_session_id INT NOT NULL,
    effective_term_id TINYINT NOT NULL,
    movement_type ENUM('transfer', 'promotion', 'graduation', 'correction') NOT NULL DEFAULT 'transfer',
    note VARCHAR(500) DEFAULT NULL,
    createdby INT DEFAULT NULL,
    datecreated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_student_movements (school_id, student_id, effective_session_id, effective_term_id),
    KEY idx_destination_movements (school_id, to_class_id, effective_session_id, effective_term_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS student_class_recovery_audit (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    school_id INT NOT NULL,
    student_id INT NOT NULL,
    session_id INT NOT NULL,
    term_id TINYINT NOT NULL,
    proposed_class_id INT DEFAULT NULL,
    confidence ENUM('confirmed', 'inferred', 'conflict') NOT NULL,
    evidence_json JSON NOT NULL,
    review_status ENUM('pending', 'accepted', 'rejected') NOT NULL DEFAULT 'pending',
    reviewedby INT DEFAULT NULL,
    reviewed_at DATETIME DEFAULT NULL,
    datecreated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    dateupdated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_recovery_period (school_id, student_id, session_id, term_id),
    KEY idx_recovery_queue (school_id, confidence, review_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- These non-unique indexes improve historical reads without asserting that the
-- legacy score data is already clean enough for a uniqueness constraint.
SET @history_index_sql = IF(
    EXISTS(
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'skulscores'
          AND index_name = 'idx_scores_history_lookup'
    ),
    'SELECT 1',
    'CREATE INDEX idx_scores_history_lookup ON skulscores (school_id, student_id, session_id, term_id, class_id)'
);
PREPARE history_index_statement FROM @history_index_sql;
EXECUTE history_index_statement;
DEALLOCATE PREPARE history_index_statement;

SET @class_period_index_sql = IF(
    EXISTS(
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE()
          AND table_name = 'skulscores'
          AND index_name = 'idx_scores_class_period'
    ),
    'SELECT 1',
    'CREATE INDEX idx_scores_class_period ON skulscores (school_id, class_id, session_id, term_id, student_id)'
);
PREPARE class_period_index_statement FROM @class_period_index_sql;
EXECUTE class_period_index_statement;
DEALLOCATE PREPARE class_period_index_statement;
