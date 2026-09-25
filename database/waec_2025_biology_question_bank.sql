-- WAEC 2025 Biology objective questions for the global question bank.
-- Generated from: myschool.ng classroom (api/web/v1/classroom/biology?exam_type=waec&exam_year=2025)
-- Collected: 2026-09-25 01:32 UTC; provenance manifest: docs/question-bank-imports/waec_2025_biology_manifest.json
-- Expected payload: 50 questions and 200 options.
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
SET @biology_subject_id := (SELECT id FROM subjects WHERE subject IN ('Biology') ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_waec_2025_biology_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_waec_2025_biology_refs()
BEGIN
    IF @waec_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WAEC exam body could not be resolved.';
    END IF;
    IF @biology_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Biology subject could not be resolved. Create the subject before running this migration.';
    END IF;

END$$
DELIMITER ;
CALL ss360_require_waec_2025_biology_refs();
DROP PROCEDURE ss360_require_waec_2025_biology_refs;

START TRANSACTION;

-- WAEC 2025 Biology - Item 1 - Question 1
SET @source_marker := 'WAEC 2025 Biology - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 1 - Question 1</small></p><p><strong>WAEC 2025 Biology - Question 1</strong></p><p>The Genus into which man is classified is</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Chordata', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Chordata' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mammalia', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mammalia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'homo', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'homo' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sapiens', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sapiens' AND deleted = 0);

-- WAEC 2025 Biology - Item 2 - Question 2
SET @source_marker := 'WAEC 2025 Biology - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 2 - Question 2</small></p><p><strong>WAEC 2025 Biology - Question 2</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q2_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 2" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of the nymph of an insect. Study it and answer the question below:</p><p>The organism illustrated is a stage in the </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'grasshopper', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'grasshopper' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mosquito', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mosquito' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'termite', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'termite' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cockroach', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cockroach' AND deleted = 0);

-- WAEC 2025 Biology - Item 3 - Question 3
SET @source_marker := 'WAEC 2025 Biology - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 3 - Question 3</small></p><p><strong>WAEC 2025 Biology - Question 3</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q3_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 3" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of the nymph of an insect. Study it and answer the question below:</p><p>The growth process that would occur in the organism before it becomes an adult is </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'respiration', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'respiration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'locomotion', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'locomotion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'moulting', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'moulting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sensitivity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sensitivity' AND deleted = 0);

-- WAEC 2025 Biology - Item 4 - Question 4
SET @source_marker := 'WAEC 2025 Biology - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 4 - Question 4</small></p><p><strong>WAEC 2025 Biology - Question 4</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q4_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 4" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of a dicot leaf. Study it and answer the question below.</p><p>The parts labelled I,II,III and IV respectively are </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'vein, apex, midrib, stalk', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'vein, apex, midrib, stalk' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'midrib, petiole, margin, stalk', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'midrib, petiole, margin, stalk' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'apex, lamina, blade, axil', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'apex, lamina, blade, axil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'apex, midrib, lamina, axil', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'apex, midrib, lamina, axil' AND deleted = 0);

-- WAEC 2025 Biology - Item 5 - Question 5
SET @source_marker := 'WAEC 2025 Biology - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 5 - Question 5</small></p><p><strong>WAEC 2025 Biology - Question 5</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q5_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 5" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of a dicot leaf. Study it and answer the question below.</p><p>The part that contains the phloem and xylem is labelled </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'II' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'III', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'IV', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'IV' AND deleted = 0);

-- WAEC 2025 Biology - Item 6 - Question 6
SET @source_marker := 'WAEC 2025 Biology - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 6 - Question 6</small></p><p><strong>WAEC 2025 Biology - Question 6</strong></p><p>The functions of vacuoles in plants are storage and </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protection', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'protection' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'strength', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'strength' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'support', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'support' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sensitivity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sensitivity' AND deleted = 0);

-- WAEC 2025 Biology - Item 7 - Question 7
SET @source_marker := 'WAEC 2025 Biology - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 7 - Question 7</small></p><p><strong>WAEC 2025 Biology - Question 7</strong></p><p>Four cells each with osmotic potential of about 3% salt solution was immersed respectively into solutions of different concentrations as follows:</p><p>I - 1% salt solution; II - 3% salt solution; III - 6% salt solutuon; IV - 10% salt solution.</p><p>Which of the solutions will cause an increase in osmotic pressure within the cell?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'II' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'III', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'IV', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'IV' AND deleted = 0);

-- WAEC 2025 Biology - Item 8 - Question 8
SET @source_marker := 'WAEC 2025 Biology - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 8 - Question 8</small></p><p><strong>WAEC 2025 Biology - Question 8</strong></p><p>Four cells each with osmotic potential of about 3% salt solution was immersed respectively into solutions of different concentrations as follows:</p><p>I - 1% salt solution; II - 3% salt solution; III - 6% salt solutuon; IV - 10% salt solution.</p><p>If the cells are plant cells, what would happen to the cell in solution III? It would become </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'turgid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'turgid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'crenated', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'crenated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'haemolysed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'haemolysed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'plasmolyzed', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'plasmolyzed' AND deleted = 0);

-- WAEC 2025 Biology - Item 9 - Question 9
SET @source_marker := 'WAEC 2025 Biology - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 9 - Question 9</small></p><p><strong>WAEC 2025 Biology - Question 9</strong></p><p>How many molecules of oxygen are required for the aerobic respiration of three molecules of glucose?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '18' AND deleted = 0);

-- WAEC 2025 Biology - Item 10 - Question 10
SET @source_marker := 'WAEC 2025 Biology - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 10 - Question 10</small></p><p><strong>WAEC 2025 Biology - Question 10</strong></p><p>Sclerenchyma tissues in plants is for </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water conduction', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'water conduction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mechanical support', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mechanical support' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'food storage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'food storage' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'food transport', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'food transport' AND deleted = 0);

-- WAEC 2025 Biology - Item 11 - Question 11
SET @source_marker := 'WAEC 2025 Biology - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 11 - Question 11</small></p><p><strong>WAEC 2025 Biology - Question 11</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q11_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 11" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of a cell carrying out a biological process. Study it and answer the question below:</p><p>The biological system that contains cells that carry out the illustrated biological processes in humans is</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reproduction', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reproduction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'circulatory', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'circulatory' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'respiratory', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'respiratory' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nervous', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nervous' AND deleted = 0);

-- WAEC 2025 Biology - Item 12 - Question 12
SET @source_marker := 'WAEC 2025 Biology - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 12 - Question 12</small></p><p><strong>WAEC 2025 Biology - Question 12</strong></p><p>Which of the following statements is not correct about respiration in plants?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It occurs in all plant tissues', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It occurs in all plant tissues' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Light and chlorophyll must be present for it to occur', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Light and chlorophyll must be present for it to occur' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Energy is produced as the end product', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Energy is produced as the end product' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It occurs in the presence of oxygen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It occurs in the presence of oxygen' AND deleted = 0);

-- WAEC 2025 Biology - Item 13 - Question 13
SET @source_marker := 'WAEC 2025 Biology - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 13 - Question 13</small></p><p><strong>WAEC 2025 Biology - Question 13</strong></p><p>Urine when compared with blood in mammals is hypertonic because</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'urine contains high percentage of all cells', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'urine contains high percentage of all cells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'all traces of sugar have been removed from urine', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'all traces of sugar have been removed from urine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'urea is actively secreted into the renal tubules', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'urea is actively secreted into the renal tubules' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'much water has been removed from urine', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'much water has been removed from urine' AND deleted = 0);

-- WAEC 2025 Biology - Item 14 - Question 14
SET @source_marker := 'WAEC 2025 Biology - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 14 - Question 14</small></p><p><strong>WAEC 2025 Biology - Question 14</strong></p><p>The naturally produced auxin in plants is </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Indole acetic acid', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Indole acetic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dichlorophenoxyacetic acid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dichlorophenoxyacetic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aldone', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aldone' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'florigen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'florigen' AND deleted = 0);

-- WAEC 2025 Biology - Item 15 - Question 15
SET @source_marker := 'WAEC 2025 Biology - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 15 - Question 15</small></p><p><strong>WAEC 2025 Biology - Question 15</strong></p><p>The sympathetic nervous system causes</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'constriction of the arteries', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'constriction of the arteries' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'heartbeat to slow down', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'heartbeat to slow down' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase in the secretion of saliva', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase in the secretion of saliva' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contraction of the bladder', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'contraction of the bladder' AND deleted = 0);

-- WAEC 2025 Biology - Item 16 - Question 16
SET @source_marker := 'WAEC 2025 Biology - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 16 - Question 16</small></p><p><strong>WAEC 2025 Biology - Question 16</strong></p><p>Long sightedness could be corrected using a </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'biconvex lens', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'biconvex lens' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'convex lens', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'convex lens' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'biconcave lens', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'biconcave lens' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'concave lens', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'concave lens' AND deleted = 0);

-- WAEC 2025 Biology - Item 17 - Question 17
SET @source_marker := 'WAEC 2025 Biology - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 17 - Question 17</small></p><p><strong>WAEC 2025 Biology - Question 17</strong></p><p>During the process of hearing in mammals, the structure in the middle ear which receives the first vibration is the </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oval window', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oval window' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'round window', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'round window' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'incus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'incus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'malleus', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'malleus' AND deleted = 0);

-- WAEC 2025 Biology - Item 18 - Question 18
SET @source_marker := 'WAEC 2025 Biology - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 18 - Question 18</small></p><p><strong>WAEC 2025 Biology - Question 18</strong></p><p>An important characteristics of fruits dispersed by water is the presence of </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fibrous covering', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fibrous covering' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smooth surface', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'smooth surface' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water content', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'water content' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pericarp', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pericarp' AND deleted = 0);

-- WAEC 2025 Biology - Item 19 - Question 19
SET @source_marker := 'WAEC 2025 Biology - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 19 - Question 19</small></p><p><strong>WAEC 2025 Biology - Question 19</strong></p><p>Plants which grow and produce fruits within a year are called</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'biennials', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'biennials' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'perennials', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'perennials' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'annuals', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'annuals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'herbs', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'herbs' AND deleted = 0);

-- WAEC 2025 Biology - Item 20 - Question 20
SET @source_marker := 'WAEC 2025 Biology - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 20 - Question 20</small></p><p><strong>WAEC 2025 Biology - Question 20</strong></p><p>Chemical digestion in organisms is the</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'breakdown of starch into carbohydrates', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'breakdown of starch into carbohydrates' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'breakdown of complex molecules into simple molecules', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'breakdown of complex molecules into simple molecules' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'build up of simple insoluble molecules', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'build up of simple insoluble molecules' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'build up of simple soluble molecules into complex insoluble molecules', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'build up of simple soluble molecules into complex insoluble molecules' AND deleted = 0);

-- WAEC 2025 Biology - Item 21 - Question 21
SET @source_marker := 'WAEC 2025 Biology - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 21 - Question 21</small></p><p><strong>WAEC 2025 Biology - Question 21</strong></p><p>Excessive bleeding from an injury could be due to the lack of vitamin</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'K', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'K' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'E', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'E' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'B', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'B' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A' AND deleted = 0);

-- WAEC 2025 Biology - Item 22 - Question 22
SET @source_marker := 'WAEC 2025 Biology - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 22 - Question 22</small></p><p><strong>WAEC 2025 Biology - Question 22</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q22_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 22" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of a cell carrying out a biological process. Study it and answer the question below:</p><p>The process is referred to as </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'phagocytosis', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'phagocytosis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pinocytosis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pinocytosis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'endocytosis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'endocytosis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exocytosis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exocytosis' AND deleted = 0);

-- WAEC 2025 Biology - Item 23 - Question 23
SET @source_marker := 'WAEC 2025 Biology - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 23 - Question 23</small></p><p><strong>WAEC 2025 Biology - Question 23</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q23_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 23" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of a system in humans. Study it and answer the question below.</p><p>Enzymatic digestion of protein begins in the part labelled </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'II' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'III', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'IV', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'IV' AND deleted = 0);

-- WAEC 2025 Biology - Item 24 - Question 24
SET @source_marker := 'WAEC 2025 Biology - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 24 - Question 24</small></p><p><strong>WAEC 2025 Biology - Question 24</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q24_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 24" style="max-width:100%;height:auto;"></p><p>The diagram below is an illustration of a system in humans. Study it and answer the question below.</p><p>The parts that secret substances involved in the digestion of fats are labelled</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I, II and III', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I, II and III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and III', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I and III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II and III', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'II and III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I, III and IV', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I, III and IV' AND deleted = 0);

-- WAEC 2025 Biology - Item 25 - Question 25
SET @source_marker := 'WAEC 2025 Biology - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 25 - Question 25</small></p><p><strong>WAEC 2025 Biology - Question 25</strong></p><p>If the small intestine of an organism does not have villi, the organism will have a problem with</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'digestion of food only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'digestion of food only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'absorption of water', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'absorption of water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'absorption of nutrients only', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'absorption of nutrients only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'digestion of food and absorption of nutrients', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'digestion of food and absorption of nutrients' AND deleted = 0);

-- WAEC 2025 Biology - Item 26 - Question 26
SET @source_marker := 'WAEC 2025 Biology - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 26 - Question 26</small></p><p><strong>WAEC 2025 Biology - Question 26</strong></p><p>Which of the following statements is not correct about the dental formula of humans?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'One pair of canines is on the upper jaw and three pairs of premolars are on the lower jaw', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'One pair of canines is on the upper jaw and three pairs of premolars are on the lower jaw' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Two pairs of incisors are the upper jaw and three pairs of premolars are on the lower jaw', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Two pairs of incisors are the upper jaw and three pairs of premolars are on the lower jaw' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Two pairs of incisors are on the upper jaw and three pairs of molars are on the lower jaw', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Two pairs of incisors are on the upper jaw and three pairs of molars are on the lower jaw' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'One pair of canines is on the upper jaw and four pairs of molars are on the lower jaw', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'One pair of canines is on the upper jaw and four pairs of molars are on the lower jaw' AND deleted = 0);

-- WAEC 2025 Biology - Item 27 - Question 27
SET @source_marker := 'WAEC 2025 Biology - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 27 - Question 27</small></p><p><strong>WAEC 2025 Biology - Question 27</strong></p><p>The relationship between a bean plant and a Tridax plant on a farmland is</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'competition', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'competition' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'predation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'predation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'parasitism', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'parasitism' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'epiphytism', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'epiphytism' AND deleted = 0);

-- WAEC 2025 Biology - Item 28 - Question 28
SET @source_marker := 'WAEC 2025 Biology - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 28 - Question 28</small></p><p><strong>WAEC 2025 Biology - Question 28</strong></p><p>The following ecological factors affect all habitat except </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'temperature', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'humidity', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'humidity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'light', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'light' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pressure', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pressure' AND deleted = 0);

-- WAEC 2025 Biology - Item 29 - Question 29
SET @source_marker := 'WAEC 2025 Biology - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 29 - Question 29</small></p><p><strong>WAEC 2025 Biology - Question 29</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q29_diagram.png" alt="Diagram for WAEC 2025 Biology Question 29" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of an ecological instrument used in a habitat. Study it and answer question below.</p><p>The ecological instrument is </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wind vane', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'wind vane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'six&#039;s thermometer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'six&#039;s thermometer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'secchi disc', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'secchi disc' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hygrometer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hygrometer' AND deleted = 0);

-- WAEC 2025 Biology - Item 30 - Question 30
SET @source_marker := 'WAEC 2025 Biology - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 30 - Question 30</small></p><p><strong>WAEC 2025 Biology - Question 30</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q30_diagram.png" alt="Diagram for WAEC 2025 Biology Question 30" style="max-width:100%;height:auto;"></p><p>The diagram above is an illustration of an ecological instrument used in a habitat. Study it and answer question below.</p><p>The instrument is used to measure a factor </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'in the atmosphere', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'in the atmosphere' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'in water', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'in water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'on land', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'on land' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'on grass', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'on grass' AND deleted = 0);

-- WAEC 2025 Biology - Item 31 - Question 31
SET @source_marker := 'WAEC 2025 Biology - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 31 - Question 31</small></p><p><strong>WAEC 2025 Biology - Question 31</strong></p><p>When Tilapias&#39; population in a pond reaches the carrying capacity, the population</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alternatively increases and decreases', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alternatively increases and decreases' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'remains unchanged', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'remains unchanged' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increases only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increases only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decreases only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decreases only' AND deleted = 0);

-- WAEC 2025 Biology - Item 32 - Question 32
SET @source_marker := 'WAEC 2025 Biology - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 32 - Question 32</small></p><p><strong>WAEC 2025 Biology - Question 32</strong></p><p>Which of the following statements about the pyramid of energy is correct?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Energy remains constant across trophic levels', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Energy remains constant across trophic levels' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Energy decreases from the base to the apex of the pyramid', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Energy decreases from the base to the apex of the pyramid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Energy increases from the base to the apex of the pyramid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Energy increases from the base to the apex of the pyramid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'each trophic level is an independent energy source', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'each trophic level is an independent energy source' AND deleted = 0);

-- WAEC 2025 Biology - Item 33 - Question 33
SET @source_marker := 'WAEC 2025 Biology - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 33 - Question 33</small></p><p><strong>WAEC 2025 Biology - Question 33</strong></p><p>Which of the following sequences represents the trend in eutrophication?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Heavy mineralization→ lack of oxygen→ massive algal growth', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Heavy mineralization→ lack of oxygen→ massive algal growth' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Excessive nitrates→ massive algal growth →lack of oxygen→death of aquatic organisms', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Excessive nitrates→ massive algal growth →lack of oxygen→death of aquatic organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Excessive phosphates→lack of oxygen→massive algal growth→ death of aquatic organisms', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Excessive phosphates→lack of oxygen→massive algal growth→ death of aquatic organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'massive algal growth→excessive nitrates→lack of oxygen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'massive algal growth→excessive nitrates→lack of oxygen' AND deleted = 0);

-- WAEC 2025 Biology - Item 34 - Question 34
SET @source_marker := 'WAEC 2025 Biology - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 34 - Question 34</small></p><p><strong>WAEC 2025 Biology - Question 34</strong></p><p>Which of the following statements correctly describes the term population? The number of </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tilapia in a lake', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tilapia in a lake' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fungus and snail on leaf litter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fungus and snail on leaf litter' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bees and butterflies on a flower', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bees and butterflies on a flower' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'flatworms and roundworms in the gut of an animal.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'flatworms and roundworms in the gut of an animal.' AND deleted = 0);

-- WAEC 2025 Biology - Item 35 - Question 35
SET @source_marker := 'WAEC 2025 Biology - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 35 - Question 35</small></p><p><strong>WAEC 2025 Biology - Question 35</strong></p><p>What is the population density of Ageratum sp. of frequency 1,850 on a land area measuring <span contenteditable="false" class="math-editor-rendered" data-latex="100m^{2}"></span>?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18.50/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '18.50/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18.05/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '18.05/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.50/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.50/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.05/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.05/<span contenteditable="false" class="math-editor-rendered" data-latex="m^{2}"></span>' AND deleted = 0);

-- WAEC 2025 Biology - Item 36 - Question 36
SET @source_marker := 'WAEC 2025 Biology - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 36 - Question 36</small></p><p><strong>WAEC 2025 Biology - Question 36</strong></p><p>Which of the following activities does not control pathogens? </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exposure to ultraviolet radiation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exposure to ultraviolet radiation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'use of disinfectants', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'use of disinfectants' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'eating balanced diets', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'eating balanced diets' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'destroying the habitats of pathogens', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'destroying the habitats of pathogens' AND deleted = 0);

-- WAEC 2025 Biology - Item 37 - Question 37
SET @source_marker := 'WAEC 2025 Biology - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 37 - Question 37</small></p><p><strong>WAEC 2025 Biology - Question 37</strong></p><p>Which of the following diseases could be prevented by a BCG vaccination?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Malaria', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Malaria' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cholera', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cholera' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tuberculosis', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tuberculosis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Diphtheria', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Diphtheria' AND deleted = 0);

-- WAEC 2025 Biology - Item 38 - Question 38
SET @source_marker := 'WAEC 2025 Biology - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 38 - Question 38</small></p><p><strong>WAEC 2025 Biology - Question 38</strong></p><p>The main effect of a deforestation is </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'creation of new habitats', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'creation of new habitats' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'loss of soil particles', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'loss of soil particles' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'survival of more species', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'survival of more species' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reduction of carbon(IV) oxide in the atmosphere', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reduction of carbon(IV) oxide in the atmosphere' AND deleted = 0);

-- WAEC 2025 Biology - Item 39 - Question 39
SET @source_marker := 'WAEC 2025 Biology - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 39 - Question 39</small></p><p><strong>WAEC 2025 Biology - Question 39</strong></p><p>Which of the following resources cannot be conserved?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mineral resources', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mineral resources' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'soil and water', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'soil and water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'forest and wildlife', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'forest and wildlife' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'domestic wastes', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'domestic wastes' AND deleted = 0);

-- WAEC 2025 Biology - Item 40 - Question 40
SET @source_marker := 'WAEC 2025 Biology - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 40 - Question 40</small></p><p><strong>WAEC 2025 Biology - Question 40</strong></p><p>Which of the following activities is not suitable for forest conservation?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'felling of trees', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'felling of trees' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'planting seedlings', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'planting seedlings' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'preventing bush fires', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'preventing bush fires' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'preventing tree crops', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'preventing tree crops' AND deleted = 0);

-- WAEC 2025 Biology - Item 41 - Question 41
SET @source_marker := 'WAEC 2025 Biology - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 41 - Question 41</small></p><p><strong>WAEC 2025 Biology - Question 41</strong></p><p>Which of the following pairs of features is an example of discontinuous variation?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'height and blood group', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'height and blood group' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'height and sex', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'height and sex' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'colour and weight', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'colour and weight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fingerprint and blood group', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fingerprint and blood group' AND deleted = 0);

-- WAEC 2025 Biology - Item 42 - Question 42
SET @source_marker := 'WAEC 2025 Biology - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 42 - Question 42</small></p><p><strong>WAEC 2025 Biology - Question 42</strong></p><p>The ability of some individuals to taste phenylthiocarbamide is </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'morphological variation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'morphological variation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'physiological variation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'physiological variation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'morphological adaptation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'morphological adaptation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'physiological adaptation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'physiological adaptation' AND deleted = 0);

-- WAEC 2025 Biology - Item 43 - Question 43
SET @source_marker := 'WAEC 2025 Biology - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 43 - Question 43</small></p><p><strong>WAEC 2025 Biology - Question 43</strong></p><p>Alleles are found on </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nucleus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nucleus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nucleolus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nucleolus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chromosomes', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'chromosomes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tissues', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tissues' AND deleted = 0);

-- WAEC 2025 Biology - Item 44 - Question 44
SET @source_marker := 'WAEC 2025 Biology - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 44 - Question 44</small></p><p><strong>WAEC 2025 Biology - Question 44</strong></p><p>A couple heterozygous for albino genes have normal skin colour. What is the probability that their child would be an albino?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{3}"></span>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{3}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{4}"></span>', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{4}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);

-- WAEC 2025 Biology - Item 45 - Question 45
SET @source_marker := 'WAEC 2025 Biology - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 45 - Question 45</small></p><p><strong>WAEC 2025 Biology - Question 45</strong></p><p><img src="../uploads/question_bank/waec_2025_biology/Q45_diagram.jpg" alt="Diagram for WAEC 2025 Biology Question 45" style="max-width:100%;height:auto;"></p><p>The process occuring in the illustrated molecules above is</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protein synthesis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'protein synthesis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gene coding', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gene coding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'DNA replication', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'DNA replication' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gene mutation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gene mutation' AND deleted = 0);

-- WAEC 2025 Biology - Item 46 - Question 46
SET @source_marker := 'WAEC 2025 Biology - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 46 - Question 46</small></p><p><strong>WAEC 2025 Biology - Question 46</strong></p><p>If the percentage of adenine in the DNA of a human is 32%, what would be the percentage of thymine?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10%', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10%' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16%', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16%' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '32%', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '32%' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '27%', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '27%' AND deleted = 0);

-- WAEC 2025 Biology - Item 47 - Question 47
SET @source_marker := 'WAEC 2025 Biology - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 47 - Question 47</small></p><p><strong>WAEC 2025 Biology - Question 47</strong></p><p>Which of the following statements is not correct about colour blindness?</p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It is a sex-linked trait', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It is a sex-linked trait' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Males are often carriers', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Males are often carriers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'females are not carriers', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'females are not carriers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The trait is controlled by a recesive gene', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The trait is controlled by a recesive gene' AND deleted = 0);

-- WAEC 2025 Biology - Item 48 - Question 48
SET @source_marker := 'WAEC 2025 Biology - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 48 - Question 48</small></p><p><strong>WAEC 2025 Biology - Question 48</strong></p><p>Lamarck&#39;s theory of evolution states that </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'characteristics of organisms are not the sum of the characters of their parents', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'characteristics of organisms are not the sum of the characters of their parents' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'characteristics of organisms are determined by mutation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'characteristics of organisms are determined by mutation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'organisms transfer acquired characters to their offspring', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'organisms transfer acquired characters to their offspring' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'organism acquire genes from their parents', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'organism acquire genes from their parents' AND deleted = 0);

-- WAEC 2025 Biology - Item 49 - Question 49
SET @source_marker := 'WAEC 2025 Biology - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 49 - Question 49</small></p><p><strong>WAEC 2025 Biology - Question 49</strong></p><p>The castes of the organisms found in a beehive are </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'drones, queen and workers', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'drones, queen and workers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'workers, soldiers and reproductives', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'workers, soldiers and reproductives' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'soldiers, workers and king', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'soldiers, workers and king' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'king, queen and soldiers', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'king, queen and soldiers' AND deleted = 0);

-- WAEC 2025 Biology - Item 50 - Question 50
SET @source_marker := 'WAEC 2025 Biology - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @biology_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Biology - Item 50 - Question 50</small></p><p><strong>WAEC 2025 Biology - Question 50</strong></p><p>The theory of natural selection in evolution was formulated by </p>', @biology_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Biology', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mathias Schleiden', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mathias Schleiden' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Louis Pasteur', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Louis Pasteur' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Charles Darwin', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Charles Darwin' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Jean Lamarck', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Jean Lamarck' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS waec_2025_biology_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @waec_exam_body_id
  AND subject_id = @biology_subject_id
  AND exam_year = 2025
  AND question LIKE '%WAEC 2025 Biology - Item%';
