-- WAEC 2025 Data Processing objective questions for the global question bank.
-- Generated from: myschool.ng classroom (api/web/v1/classroom/data-processing?exam_type=waec&exam_year=2025)
-- Collected: 2026-09-25 07:22 UTC; provenance manifest: docs/question-bank-imports/waec_2025_data_processing_manifest.json
-- Expected payload: 40 questions and 160 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.
-- Additive only: never updates or deletes existing rows.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS question_bank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question TEXT NOT NULL,
    subject_id INT NOT NULL DEFAULT 0,
    class_id INT NOT NULL DEFAULT 0,
    source_type VARCHAR(30) NOT NULL DEFAULT 'topic',
    exam_body_id INT NOT NULL DEFAULT 0,
    exam_year INT NOT NULL DEFAULT 0,
    topic_id INT NOT NULL DEFAULT 0,
    difficulty VARCHAR(20) NOT NULL DEFAULT 'Medium',
    recommended_class VARCHAR(100) NULL,
    term_tag VARCHAR(50) NULL,
    question_category VARCHAR(100) NULL,
    explanation TEXT NULL,
    review_status VARCHAR(20) NOT NULL DEFAULT 'approved',
    quality_score INT NOT NULL DEFAULT 0,
    times_used INT NOT NULL DEFAULT 0,
    school_id INT NOT NULL DEFAULT 0,
    createdby INT NOT NULL DEFAULT 0,
    datecreated DATETIME NULL,
    dateupdated DATETIME NULL,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    KEY idx_qb_subject_source (subject_id, source_type),
    KEY idx_qb_exam_body (exam_body_id, exam_year),
    KEY idx_qb_school_deleted (school_id, deleted)
);

CREATE TABLE IF NOT EXISTS question_bank_options (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    options TEXT NOT NULL,
    answer TINYINT(1) NOT NULL DEFAULT 0,
    deleted TINYINT(1) NOT NULL DEFAULT 0,
    KEY idx_qbo_question (question_id)
);

CREATE TABLE IF NOT EXISTS topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    class_id INT NOT NULL,
    topic_name VARCHAR(255) NOT NULL
);

ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS class_id INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS source_type VARCHAR(30) NOT NULL DEFAULT 'topic';
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS exam_body_id INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS exam_year INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS topic_id INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS difficulty VARCHAR(20) NOT NULL DEFAULT 'Medium';
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS recommended_class VARCHAR(100) NULL;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS term_tag VARCHAR(50) NULL;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS question_category VARCHAR(100) NULL;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS explanation TEXT NULL;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS review_status VARCHAR(20) NOT NULL DEFAULT 'approved';
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS quality_score INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS times_used INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS school_id INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS createdby INT NOT NULL DEFAULT 0;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS datecreated DATETIME NULL;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS dateupdated DATETIME NULL;
ALTER TABLE question_bank ADD COLUMN IF NOT EXISTS deleted TINYINT(1) NOT NULL DEFAULT 0;
ALTER TABLE question_bank_options ADD COLUMN IF NOT EXISTS deleted TINYINT(1) NOT NULL DEFAULT 0;

INSERT INTO exam_bodies (name, description)
SELECT 'WAEC', 'West African Examinations Council'
WHERE NOT EXISTS (SELECT 1 FROM exam_bodies WHERE name = 'WAEC');

SET @waec_exam_body_id := (SELECT id FROM exam_bodies WHERE name = 'WAEC' ORDER BY id ASC LIMIT 1);
SET @data_processing_subject_id := (SELECT id FROM subjects WHERE subject IN ('Data Processing') ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_waec_2025_data_processing_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_waec_2025_data_processing_refs()
BEGIN
    IF @waec_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WAEC exam body could not be resolved.';
    END IF;
    IF @data_processing_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Data Processing subject could not be resolved. Create the subject before running this migration.';
    END IF;

END$$
DELIMITER ;
CALL ss360_require_waec_2025_data_processing_refs();
DROP PROCEDURE ss360_require_waec_2025_data_processing_refs;

START TRANSACTION;

-- WAEC 2025 Data Processing - Item 1 - Question 1
SET @source_marker := 'WAEC 2025 Data Processing - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 1 - Question 1</small></p><p><strong>WAEC 2025 Data Processing - Question 1</strong></p><p>Who among the following scientists invented the punch card?</p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'charles babbage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'charles babbage' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'herman hollerith', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'herman hollerith' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gottfried wilhelm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gottfried wilhelm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'blaise pascal', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'blaise pascal' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 2 - Question 2
SET @source_marker := 'WAEC 2025 Data Processing - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 2 - Question 2</small></p><p><strong>WAEC 2025 Data Processing - Question 2</strong></p><p>Which of the following computers is designed to perform a variety of tasks?</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'General purpose', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'General purpose' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Analogue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Analogue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hybrid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hybrid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Digital', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Digital' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 3 - Question 3
SET @source_marker := 'WAEC 2025 Data Processing - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 3 - Question 3</small></p><p><strong>WAEC 2025 Data Processing - Question 3</strong></p><p>The special feature in word processing which allows the sending of multiple data copies of document to different people without having it retyped is</p><p><br /> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cut and paste', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cut and paste' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'insert', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'insert' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mail merge', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mail merge' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thesaurus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'thesaurus' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 4 - Question 4
SET @source_marker := 'WAEC 2025 Data Processing - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 4 - Question 4</small></p><p><strong>WAEC 2025 Data Processing - Question 4</strong></p><p>A motion path is a</p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'path to save powerpoint file', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'path to save powerpoint file' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methods of moving items on slide', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methods of moving items on slide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methods of advancing slide', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methods of advancing slide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'path to follow when starting powerpoint', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'path to follow when starting powerpoint' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 5 - Question 5
SET @source_marker := 'WAEC 2025 Data Processing - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 5 - Question 5</small></p><p><strong>WAEC 2025 Data Processing - Question 5</strong></p><p>Which of the following can be used to make a PowerPoint slide in a presentation to have the same look?</p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Change the view to slide show', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Change the view to slide show' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Add a little slide option', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Add a little slide option' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Format the slide layout option', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Format the slide layout option' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Add a presentation design template', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Add a presentation design template' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 6 - Question 6
SET @source_marker := 'WAEC 2025 Data Processing - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 6 - Question 6</small></p><p><strong>WAEC 2025 Data Processing - Question 6</strong></p><p>The correctness and completeness of the data in a database are its</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'constraint', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'constraint' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'independence', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'independence' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'integrity', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'integrity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'redundancy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'redundancy' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 7 - Question 7
SET @source_marker := 'WAEC 2025 Data Processing - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 7 - Question 7</small></p><p><strong>WAEC 2025 Data Processing - Question 7</strong></p><p>Which of the following conditions is used to transmit packets over a medium at the same time?</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Synchronous', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Synchronous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Collision', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Collision' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Asynchronous', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Asynchronous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Contention', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Contention' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 8 - Question 8
SET @source_marker := 'WAEC 2025 Data Processing - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 8 - Question 8</small></p><p><strong>WAEC 2025 Data Processing - Question 8</strong></p><p>Which of the following is not a normal form of relational database?</p><p> </p><p> </p><p> </p><p> </p><p> </p><p><br /> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4NF', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4NF' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2NF', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2NF' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1NF', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1NF' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3NF', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3NF' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 9 - Question 9
SET @source_marker := 'WAEC 2025 Data Processing - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 9 - Question 9</small></p><p><strong>WAEC 2025 Data Processing - Question 9</strong></p><p>The two major types of computer chips are</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'primary memory chip', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'primary memory chip' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'external memory chip', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'external memory chip' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'microprocessor chip', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'microprocessor chip' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'both b and c', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'both b and c' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 10 - Question 10
SET @source_marker := 'WAEC 2025 Data Processing - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 10 - Question 10</small></p><p><strong>WAEC 2025 Data Processing - Question 10</strong></p><p>Which of the following is an advantage of electronic data processing?</p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'automated backup', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'automated backup' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'automatic operation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'automatic operation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mass storage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mass storage' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'resource sharing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'resource sharing' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 11 - Question 11
SET @source_marker := 'WAEC 2025 Data Processing - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 11 - Question 11</small></p><p><strong>WAEC 2025 Data Processing - Question 11</strong></p><p>The following are examples of relational operators. Use the image in the explanation to answer these questions.</p><p> </p><p> </p><p> </p><p><img src="../uploads/question_bank/waec_2025_data_processing/Q11_answer_image.png" alt="Diagram for WAEC 2025 Data Processing Question 11" style="max-width:100%;height:auto;"></p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '=', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '=' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '*', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '*' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '&lt;', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '&lt;' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 12 - Question 12
SET @source_marker := 'WAEC 2025 Data Processing - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 12 - Question 12</small></p><p><strong>WAEC 2025 Data Processing - Question 12</strong></p><p>A ______ In a database represents a relationship among a set of values</p><p> </p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Column', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Column' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Entity', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Entity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Entry', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Entry' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'key', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'key' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 13 - Question 13
SET @source_marker := 'WAEC 2025 Data Processing - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 13 - Question 13</small></p><p><strong>WAEC 2025 Data Processing - Question 13</strong></p><p>Strategic data modeling is the</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'implementation of the blueprint in database', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'implementation of the blueprint in database' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'development of logical data models', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'development of logical data models' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'capturing and displaying of program data', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'capturing and displaying of program data' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'creation of an information system procedure', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'creation of an information system procedure' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 14 - Question 14
SET @source_marker := 'WAEC 2025 Data Processing - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 14 - Question 14</small></p><p><strong>WAEC 2025 Data Processing - Question 14</strong></p><p>A data model has how many components?</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 15 - Question 15
SET @source_marker := 'WAEC 2025 Data Processing - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 15 - Question 15</small></p><p><strong>WAEC 2025 Data Processing - Question 15</strong></p><p>How many types of index (es) is/are there in the structured query language server?</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 16 - Question 16
SET @source_marker := 'WAEC 2025 Data Processing - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 16 - Question 16</small></p><p><strong>WAEC 2025 Data Processing - Question 16</strong></p><p>Which of the following is an audiovisual medium of receiving information?</p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'television', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'television' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'flip chart', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'flip chart' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'film strip', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'film strip' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fax', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fax' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 17 - Question 17
SET @source_marker := 'WAEC 2025 Data Processing - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 17 - Question 17</small></p><p><strong>WAEC 2025 Data Processing - Question 17</strong></p><p>The following are examples of operating systems by Microsoft Corporation, except</p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'os/2', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'os/2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ms-dos', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ms-dos' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'vista', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'vista' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'xp', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'xp' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 18 - Question 18
SET @source_marker := 'WAEC 2025 Data Processing - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 18 - Question 18</small></p><p><strong>WAEC 2025 Data Processing - Question 18</strong></p><p>Software that defines a database, stores the data, supports a query language, produces reports, and creates data entry screens is a</p><p><br /> </p><p><br /> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'data dictionary', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'data dictionary' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decision support system', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decision support system' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'relational database', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'relational database' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'database management system (DBMS)', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'database management system (DBMS)' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 19 - Question 19
SET @source_marker := 'WAEC 2025 Data Processing - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 19 - Question 19</small></p><p><strong>WAEC 2025 Data Processing - Question 19</strong></p><p>The database design that consists of multiple tables that are linked together through matching data stored in each table is called a:</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'object oriented database', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'object oriented database' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'relational data base', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'relational data base' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'network database', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'network database' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hierarchical database', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hierarchical database' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 20 - Question 20
SET @source_marker := 'WAEC 2025 Data Processing - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 20 - Question 20</small></p><p><strong>WAEC 2025 Data Processing - Question 20</strong></p><p>Which of the following items is not an advantage of a DBMS?</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Improved data consistency', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Improved data consistency' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'improved ability to enforce standards', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'improved ability to enforce standards' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Local control over the data', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Local control over the data' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Minimal data redundancy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Minimal data redundancy' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 21 - Question 21
SET @source_marker := 'WAEC 2025 Data Processing - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 21 - Question 21</small></p><p><strong>WAEC 2025 Data Processing - Question 21</strong></p><p>The feature in word processing that compares every word with an electronic dictionary is</p><p><br /> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thesaurus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'thesaurus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'help', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'help' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spell check', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'spell check' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'page alignment', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'page alignment' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 22 - Question 22
SET @source_marker := 'WAEC 2025 Data Processing - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 22 - Question 22</small></p><p><strong>WAEC 2025 Data Processing - Question 22</strong></p><p>Which of the following is not a database security tip?</p><p><br /> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Updating of Anti-Malware software', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Updating of Anti-Malware software' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enforce restrictions on internet access', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'enforce restrictions on internet access' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'regular backup of data on removable media', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'regular backup of data on removable media' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fight off hacking attacks with intrusion detection technology', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fight off hacking attacks with intrusion detection technology' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 23 - Question 23
SET @source_marker := 'WAEC 2025 Data Processing - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 23 - Question 23</small></p><p><strong>WAEC 2025 Data Processing - Question 23</strong></p><p>The process of distributing information over a communication network or medium is referred to as</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'interpretation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'interpretation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'organisation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'organisation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transmission', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'transmission' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'acquisition', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'acquisition' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 24 - Question 24
SET @source_marker := 'WAEC 2025 Data Processing - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 24 - Question 24</small></p><p><strong>WAEC 2025 Data Processing - Question 24</strong></p><p>Computers store data in units called</p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bit', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bit' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'field', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'field' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'database', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'database' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'file', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'file' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 25 - Question 25
SET @source_marker := 'WAEC 2025 Data Processing - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 25 - Question 25</small></p><p><strong>WAEC 2025 Data Processing - Question 25</strong></p><p>How do you minimize and maximize windows?</p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hold down both the right and left buttons on the mouse', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hold down both the right and left buttons on the mouse' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Go to file and select minimize or minimize', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Go to file and select minimize or minimize' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It is an impossible task', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It is an impossible task' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'At the top right corner, click Dash or Square', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'At the top right corner, click Dash or Square' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 26 - Question 26
SET @source_marker := 'WAEC 2025 Data Processing - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 26 - Question 26</small></p><p><strong>WAEC 2025 Data Processing - Question 26</strong></p><p>Excel worksheet version 8 has how many columns?</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '65,535', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '65,535' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '65,534', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '65,534' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '65,536', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '65,536' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '65,533', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '65,533' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 27 - Question 27
SET @source_marker := 'WAEC 2025 Data Processing - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 27 - Question 27</small></p><p><strong>WAEC 2025 Data Processing - Question 27</strong></p><p>Which of the function keys opens the &quot;Save-As&quot; windows in MS word?</p><p><br /> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'F12', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'F12' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'F10', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'F10' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'F2', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'F2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'F1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'F1' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 28 - Question 28
SET @source_marker := 'WAEC 2025 Data Processing - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 28 - Question 28</small></p><p><strong>WAEC 2025 Data Processing - Question 28</strong></p><p>Multitasking allows the _____ to access several programs at the same time</p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cpu', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cpu' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'computer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'computer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ram', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ram' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'user', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'user' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 29 - Question 29
SET @source_marker := 'WAEC 2025 Data Processing - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 29 - Question 29</small></p><p><strong>WAEC 2025 Data Processing - Question 29</strong></p><p>Which of the following fields can uniquely identify a record of a student&#39;s performance in a school?</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Classroom number', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Classroom number' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Date of birth', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Date of birth' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Administration number', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Administration number' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'First name', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'First name' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 30 - Question 30
SET @source_marker := 'WAEC 2025 Data Processing - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 30 - Question 30</small></p><p><strong>WAEC 2025 Data Processing - Question 30</strong></p><p>The execution of an instruction by a processor is in three distinct phases. They are</p><p> </p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fetch, decode, execute', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fetch, decode, execute' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'input, output, process', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'input, output, process' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'start, stop, process', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'start, stop, process' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'call, respond, store', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'call, respond, store' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 31 - Question 31
SET @source_marker := 'WAEC 2025 Data Processing - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 31 - Question 31</small></p><p><strong>WAEC 2025 Data Processing - Question 31</strong></p><p>The function of the history link in the standard navigation bar of Internet Explorer is to</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'display a list of previously viewed websites', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'display a list of previously viewed websites' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'go to the homepage of the currently viewed website', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'go to the homepage of the currently viewed website' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'display a list of previously bookmarked website', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'display a list of previously bookmarked website' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'move forward to a webpage viewed before using the back button', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'move forward to a webpage viewed before using the back button' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 32 - Question 32
SET @source_marker := 'WAEC 2025 Data Processing - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 32 - Question 32</small></p><p><strong>WAEC 2025 Data Processing - Question 32</strong></p><p>The roles of a database administrator include the following except</p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aiding and abetting fraud', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aiding and abetting fraud' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'backup and receiving the database', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'backup and receiving the database' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ensuring database security is implemented to safeguard the data', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ensuring database security is implemented to safeguard the data' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'creating new databases', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'creating new databases' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 33 - Question 33
SET @source_marker := 'WAEC 2025 Data Processing - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 33 - Question 33</small></p><p><strong>WAEC 2025 Data Processing - Question 33</strong></p><p>Ctrl + B is?</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'paste the selected text

bold the selected text', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'paste the selected text

bold the selected text' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bold the selected text', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bold the selected text' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'open the specified file', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'open the specified file' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'search the selected text', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'search the selected text' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 34 - Question 34
SET @source_marker := 'WAEC 2025 Data Processing - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 34 - Question 34</small></p><p><strong>WAEC 2025 Data Processing - Question 34</strong></p><p>The following are the benefits of parallel databases, except</p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'high performance', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'high performance' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'availability', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'availability' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reliability', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reliability' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'complexity', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'complexity' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 35 - Question 35
SET @source_marker := 'WAEC 2025 Data Processing - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 35 - Question 35</small></p><p><strong>WAEC 2025 Data Processing - Question 35</strong></p><p>The slide that is used to introduce a topic during a presentation is called</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'title slide', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'title slide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'graph', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'graph' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'animation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'animation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bullet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bullet' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 36 - Question 36
SET @source_marker := 'WAEC 2025 Data Processing - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 36 - Question 36</small></p><p><strong>WAEC 2025 Data Processing - Question 36</strong></p><p>Word has a list of predefined typing, spelling, capitalization, and grammar errors that ______ detect and correct.</p><p> </p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'autocorrect', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'autocorrect' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'autoentry', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'autoentry' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'autoadd', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'autoadd' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'autoSpell', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'autoSpell' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 37 - Question 37
SET @source_marker := 'WAEC 2025 Data Processing - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 37 - Question 37</small></p><p><strong>WAEC 2025 Data Processing - Question 37</strong></p><p>The process of converting data or information into a form which is readily for processing is called</p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decoding', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decoding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manipulating', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manipulating' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'encoding', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'encoding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'analysing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'analysing' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 38 - Question 38
SET @source_marker := 'WAEC 2025 Data Processing - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 38 - Question 38</small></p><p><strong>WAEC 2025 Data Processing - Question 38</strong></p><p>The ring technology is a protocol at which layer of the OSI model?</p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'network', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'network' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'presentation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'presentation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'datalink', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'datalink' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'session', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'session' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 39 - Question 39
SET @source_marker := 'WAEC 2025 Data Processing - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 39 - Question 39</small></p><p><strong>WAEC 2025 Data Processing - Question 39</strong></p><p>Where was the abacus invented?</p><p> </p><p> </p><p><br /> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'egypt', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'egypt' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'china', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'china' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'argentina', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'argentina' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'australian', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'australian' AND deleted = 0);

-- WAEC 2025 Data Processing - Item 40 - Question 40
SET @source_marker := 'WAEC 2025 Data Processing - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @data_processing_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Data Processing - Item 40 - Question 40</small></p><p><strong>WAEC 2025 Data Processing - Question 40</strong></p><p>A program installed on a computer that secretly collects information about the user is called</p><p> </p><p> </p><p> </p>', @data_processing_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Data Processing', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spyware', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'spyware' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'malware', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'malware' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fire wall', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fire wall' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ad ware', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ad ware' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS waec_2025_data_processing_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @waec_exam_body_id
  AND subject_id = @data_processing_subject_id
  AND exam_year = 2025
  AND question LIKE '%WAEC 2025 Data Processing - Item%';
