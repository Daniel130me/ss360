-- WAEC 2025 Literature in English objective questions for the global question bank.
-- Generated from: myschool.ng classroom (api/web/v1/classroom/literature-in-english?exam_type=waec&exam_year=2025)
-- Collected: 2026-09-25 07:25 UTC; provenance manifest: docs/question-bank-imports/waec_2025_literature_in_english_manifest.json
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
SET @literature_in_english_subject_id := (SELECT id FROM subjects WHERE subject IN ('Literature in English') ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_waec_2025_literature_in_english_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_waec_2025_literature_in_english_refs()
BEGIN
    IF @waec_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WAEC exam body could not be resolved.';
    END IF;
    IF @literature_in_english_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Literature in English subject could not be resolved. Create the subject before running this migration.';
    END IF;

END$$
DELIMITER ;
CALL ss360_require_waec_2025_literature_in_english_refs();
DROP PROCEDURE ss360_require_waec_2025_literature_in_english_refs;

START TRANSACTION;

-- WAEC 2025 Literature in English - Item 1 - Question 1
SET @source_marker := 'WAEC 2025 Literature in English - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 1 - Question 1</small></p><p><strong>WAEC 2025 Literature in English - Question 1</strong></p><p>Letters, journals and diaries are examples of</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'non-fiction', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'non-fiction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'meta-fiction', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'meta-fiction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'faction', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'faction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fiction', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fiction' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 2 - Question 2
SET @source_marker := 'WAEC 2025 Literature in English - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 2 - Question 2</small></p><p><strong>WAEC 2025 Literature in English - Question 2</strong></p><p>&quot;That girl is too young to be put in the family way&quot; illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'paradox', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'paradox' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hyperbole', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hyperbole' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxymoron', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxymoron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'euphemism', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'euphemism' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 3 - Question 3
SET @source_marker := 'WAEC 2025 Literature in English - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 3 - Question 3</small></p><p><strong>WAEC 2025 Literature in English - Question 3</strong></p><p>A character that is built around a single idea or quality is a ________ character.</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'choral', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'choral' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'heroic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'heroic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'flat', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'flat' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sound', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sound' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 4 - Question 4
SET @source_marker := 'WAEC 2025 Literature in English - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 4 - Question 4</small></p><p><strong>WAEC 2025 Literature in English - Question 4</strong></p><p>Seven metrical feet in a line of a stanza is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hexametre', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hexametre' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'septet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'septet' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'heptametre', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'heptametre' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'triolet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'triolet' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 5 - Question 5
SET @source_marker := 'WAEC 2025 Literature in English - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 5 - Question 5</small></p><p><strong>WAEC 2025 Literature in English - Question 5</strong></p><p>A dead metaphor is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'overused and funny', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'overused and funny' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'implied and not funny', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'implied and not funny' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'overused and ineffective', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'overused and ineffective' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'implied and underused', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'implied and underused' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 6 - Question 6
SET @source_marker := 'WAEC 2025 Literature in English - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 6 - Question 6</small></p><p><strong>WAEC 2025 Literature in English - Question 6</strong></p><p>Jonsey&#39;s opening speech illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mime', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mime' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aside', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aside' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'epilogue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'epilogue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'soliloquy', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'soliloquy' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 7 - Question 7
SET @source_marker := 'WAEC 2025 Literature in English - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 7 - Question 7</small></p><p><strong>WAEC 2025 Literature in English - Question 7</strong></p><p>In the Town hall is the</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'stage' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'setting', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'setting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'atmosphere', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'atmosphere' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'location', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'location' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 8 - Question 8
SET @source_marker := 'WAEC 2025 Literature in English - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 8 - Question 8</small></p><p><strong>WAEC 2025 Literature in English - Question 8</strong></p><p>Bassy is a ________ in the play.</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'director', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'director' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'producer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'producer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'narrator', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'narrator' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'character', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'character' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 9 - Question 9
SET @source_marker := 'WAEC 2025 Literature in English - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 9 - Question 9</small></p><p><strong>WAEC 2025 Literature in English - Question 9</strong></p><p>Jonsey&#39;s speech &quot;Your mayoral hopeful&quot; is addressed to</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'no one', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'no one' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the audience', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the audience' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bassy', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bassy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'himself', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'himself' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 10 - Question 10
SET @source_marker := 'WAEC 2025 Literature in English - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 10 - Question 10</small></p><p><strong>WAEC 2025 Literature in English - Question 10</strong></p><p>The speeches of Jonsey and Bassy illustrate</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'monologue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'monologue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dialogue', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dialogue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prologue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'prologue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'epilogue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'epilogue' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 11 - Question 11
SET @source_marker := 'WAEC 2025 Literature in English - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 11 - Question 11</small></p><p><strong>WAEC 2025 Literature in English - Question 11</strong></p><p>Resolution in a literary work is also referred to as</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'final outcome', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'final outcome' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'events that increase action', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'events that increase action' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'events that increase tension', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'events that increase tension' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the complication', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the complication' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 12 - Question 12
SET @source_marker := 'WAEC 2025 Literature in English - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 12 - Question 12</small></p><p><strong>WAEC 2025 Literature in English - Question 12</strong></p><p>&quot;The moon looked on the massacre in horror!&quot; illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prologue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'prologue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'epilogue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'epilogue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transferred epithet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'transferred epithet' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pathetic fallacy', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pathetic fallacy' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 13 - Question 13
SET @source_marker := 'WAEC 2025 Literature in English - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 13 - Question 13</small></p><p><strong>WAEC 2025 Literature in English - Question 13</strong></p><p>A dramatic performance with scenes played by body movements or gestures without words, known as</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'melodrama', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'melodrama' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'panygeric', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'panygeric' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pantomime', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pantomime' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'comedy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'comedy' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 14 - Question 14
SET @source_marker := 'WAEC 2025 Literature in English - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 14 - Question 14</small></p><p><strong>WAEC 2025 Literature in English - Question 14</strong></p><p>A short poem lamenting the death of someone is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a sonnet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a sonnet' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an ode', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an ode' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a threnody', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a threnody' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an epic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an epic' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 15 - Question 15
SET @source_marker := 'WAEC 2025 Literature in English - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 15 - Question 15</small></p><p><strong>WAEC 2025 Literature in English - Question 15</strong></p><p>The third stanza of the Shakespearean sonnet is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quatrain', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'quatrain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'octave', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'octave' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sextet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sextet' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'couplet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'couplet' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 16 - Question 16
SET @source_marker := 'WAEC 2025 Literature in English - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 16 - Question 16</small></p><p><strong>WAEC 2025 Literature in English - Question 16</strong></p><p>The extract presents the image of a</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dark night', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dark night' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'calm weather', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'calm weather' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bright day', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bright day' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rough time', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rough time' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 17 - Question 17
SET @source_marker := 'WAEC 2025 Literature in English - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 17 - Question 17</small></p><p><strong>WAEC 2025 Literature in English - Question 17</strong></p><p>The dominant literary device used in the extract is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'parallelism', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'parallelism' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'antithesis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'antithesis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'apostrophe', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'apostrophe' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personification', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personification' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 18 - Question 18
SET @source_marker := 'WAEC 2025 Literature in English - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 18 - Question 18</small></p><p><strong>WAEC 2025 Literature in English - Question 18</strong></p><p>A fable is also known as</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a parody', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a parody' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an apologue', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an apologue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a farce', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a farce' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an epigram', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an epigram' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 19 - Question 19
SET @source_marker := 'WAEC 2025 Literature in English - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 19 - Question 19</small></p><p><strong>WAEC 2025 Literature in English - Question 19</strong></p><p>Exaggerating one&#39;s personal features for comic effect is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contrast', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'contrast' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'satire', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'satire' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lampoon', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lampoon' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'caricature', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'caricature' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 20 - Question 20
SET @source_marker := 'WAEC 2025 Literature in English - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 20 - Question 20</small></p><p><strong>WAEC 2025 Literature in English - Question 20</strong></p><p>&quot;At the last head count, the population of the school was three thousand&quot; is an example of</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metonymy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metonymy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hyperbole', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hyperbole' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'synecdoche', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'synecdoche' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pun', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pun' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 21 - Question 21
SET @source_marker := 'WAEC 2025 Literature in English - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 21 - Question 21</small></p><p><strong>WAEC 2025 Literature in English - Question 21</strong></p><p>The prevailing atmosphere is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'serene', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'serene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'drab', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'drab' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tense', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tense' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pleasant', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pleasant' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 22 - Question 22
SET @source_marker := 'WAEC 2025 Literature in English - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 22 - Question 22</small></p><p><strong>WAEC 2025 Literature in English - Question 22</strong></p><p><em>join in with it, lead it on, but, finally, veer it from</em> illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personification', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'allusion', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'allusion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'simile', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'simile' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'parallelism', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'parallelism' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 23 - Question 23
SET @source_marker := 'WAEC 2025 Literature in English - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 23 - Question 23</small></p><p><strong>WAEC 2025 Literature in English - Question 23</strong></p><p>The attitude of the writer towards Sasu is one of</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'anger', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'anger' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'approval', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'approval' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'surprise', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'surprise' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disdain', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'disdain' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 24 - Question 24
SET @source_marker := 'WAEC 2025 Literature in English - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 24 - Question 24</small></p><p><strong>WAEC 2025 Literature in English - Question 24</strong></p><p><em>rattling like leaves in a storm, fear branded on their faces</em> illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personification and simile', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personification and simile' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personification and metaphor', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personification and metaphor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'simile and metaphor', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'simile and metaphor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'assonance and simile', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'assonance and simile' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 25 - Question 25
SET @source_marker := 'WAEC 2025 Literature in English - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 25 - Question 25</small></p><p><strong>WAEC 2025 Literature in English - Question 25</strong></p><p>The last paragraph illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rising action', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rising action' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'suspense', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'suspense' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'foreshadow', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'foreshadow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'anti-climax', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'anti-climax' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 26 - Question 26
SET @source_marker := 'WAEC 2025 Literature in English - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 26 - Question 26</small></p><p><strong>WAEC 2025 Literature in English - Question 26</strong></p><p><em>child of scorn</em> illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contrast', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'contrast' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'euphemism', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'euphemism' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metaphor', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metaphor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metonymy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metonymy' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 27 - Question 27
SET @source_marker := 'WAEC 2025 Literature in English - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 27 - Question 27</small></p><p><strong>WAEC 2025 Literature in English - Question 27</strong></p><p>The metrical structure is predominantly</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spondaic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'spondaic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'iambic', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'iambic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trochaic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trochaic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dactylic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dactylic' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 28 - Question 28
SET @source_marker := 'WAEC 2025 Literature in English - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 28 - Question 28</small></p><p><strong>WAEC 2025 Literature in English - Question 28</strong></p><p>Reading the poem, one notices that the poet is being</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ironic', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ironic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sarcastic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sarcastic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hyperbolic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hyperbolic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'euphemistic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'euphemistic' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 29 - Question 29
SET @source_marker := 'WAEC 2025 Literature in English - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 29 - Question 29</small></p><p><strong>WAEC 2025 Literature in English - Question 29</strong></p><p>In the last stanza, the persona is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'malnourished', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'malnourished' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fantasising', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fantasising' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pretending', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pretending' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'angry', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'angry' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 30 - Question 30
SET @source_marker := 'WAEC 2025 Literature in English - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 30 - Question 30</small></p><p><strong>WAEC 2025 Literature in English - Question 30</strong></p><p>The two stanzas are built on</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'identical rhyme', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'identical rhyme' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'run on lines', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'run on lines' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alternate rhyme', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alternate rhyme' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'couplets', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'couplets' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 31 - Question 31
SET @source_marker := 'WAEC 2025 Literature in English - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 31 - Question 31</small></p><p><strong>WAEC 2025 Literature in English - Question 31</strong></p><p>The speaker is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Demetrius', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Demetrius' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Egeus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Egeus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hermia', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hermia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Helena', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Helena' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 32 - Question 32
SET @source_marker := 'WAEC 2025 Literature in English - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 32 - Question 32</small></p><p><strong>WAEC 2025 Literature in English - Question 32</strong></p><p>The speech shows that the speaker is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disappointed', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'disappointed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'excited', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'excited' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'in a bad mood', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'in a bad mood' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'high spirits', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'high spirits' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 33 - Question 33
SET @source_marker := 'WAEC 2025 Literature in English - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 33 - Question 33</small></p><p><strong>WAEC 2025 Literature in English - Question 33</strong></p><p>The speaker&#39;s mood stems from</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wanting to punish Hermia', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'wanting to punish Hermia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'meeting with Hermia', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'meeting with Hermia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'having to go into the forest', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'having to go into the forest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'being rejected by the lover', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'being rejected by the lover' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 34 - Question 34
SET @source_marker := 'WAEC 2025 Literature in English - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 34 - Question 34</small></p><p><strong>WAEC 2025 Literature in English - Question 34</strong></p><p>The speaker has just said farewell to</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hermia', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hermia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lysander', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lysander' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Demetrius', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Demetrius' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Helena', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Helena' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 35 - Question 35
SET @source_marker := 'WAEC 2025 Literature in English - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 35 - Question 35</small></p><p><strong>WAEC 2025 Literature in English - Question 35</strong></p><p>The speaker resolves to tell</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Theseus of Hermia&#039;s infidelity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Theseus of Hermia&#039;s infidelity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Egeus of Hermia&#039;s flight', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Egeus of Hermia&#039;s flight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Demetrius of Hermia&#039;s flight', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Demetrius of Hermia&#039;s flight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lysander of Hermia&#039;s infidelity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lysander of Hermia&#039;s infidelity' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 36 - Question 36
SET @source_marker := 'WAEC 2025 Literature in English - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 36 - Question 36</small></p><p><strong>WAEC 2025 Literature in English - Question 36</strong></p><p>The speaker is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Helena', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Helena' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Titania', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Titania' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hermia', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hermia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hippolyta', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hippolyta' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 37 - Question 37
SET @source_marker := 'WAEC 2025 Literature in English - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 37 - Question 37</small></p><p><strong>WAEC 2025 Literature in English - Question 37</strong></p><p>The speech is made in</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oberon&#039;s place', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oberon&#039;s place' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the Queen&#039;s palace', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the Queen&#039;s palace' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Theseus&#039; palace', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Theseus&#039; palace' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the woods', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the woods' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 38 - Question 38
SET @source_marker := 'WAEC 2025 Literature in English - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 38 - Question 38</small></p><p><strong>WAEC 2025 Literature in English - Question 38</strong></p><p>The speaker and the addressee are</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'master and servant', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'master and servant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'friends', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'friends' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lovers', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lovers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'father and daughter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'father and daughter' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 39 - Question 39
SET @source_marker := 'WAEC 2025 Literature in English - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 39 - Question 39</small></p><p><strong>WAEC 2025 Literature in English - Question 39</strong></p><p><em>Now much beshrew my manners and my pride,</em> illustrates the use of</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alliteration', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alliteration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'onomatopoeia', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'onomatopoeia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personification', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'assonance', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'assonance' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 40 - Question 40
SET @source_marker := 'WAEC 2025 Literature in English - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 40 - Question 40</small></p><p><strong>WAEC 2025 Literature in English - Question 40</strong></p><p><em>Thy love ne&#39;er alter, till thy sweet life end.</em> implies</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an enduring love', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an enduring love' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a fickle love', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a fickle love' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a family love', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a family love' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an undying love', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an undying love' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 41 - Question 41
SET @source_marker := 'WAEC 2025 Literature in English - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 41 - Question 41</small></p><p><strong>WAEC 2025 Literature in English - Question 41</strong></p><p>The speaker is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Titania', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Titania' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Egeus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Egeus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Thisbe', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Thisbe' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lysander', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lysander' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 42 - Question 42
SET @source_marker := 'WAEC 2025 Literature in English - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 42 - Question 42</small></p><p><strong>WAEC 2025 Literature in English - Question 42</strong></p><p>The speaker is addressing</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Demetrius', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Demetrius' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Helena', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Helena' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hermia', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hermia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'himself', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'himself' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 43 - Question 43
SET @source_marker := 'WAEC 2025 Literature in English - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 43 - Question 43</small></p><p><strong>WAEC 2025 Literature in English - Question 43</strong></p><p>The speaker is in</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the palace', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the palace' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the woods', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the woods' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a street', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a street' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an apartment', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an apartment' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 44 - Question 44
SET @source_marker := 'WAEC 2025 Literature in English - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 44 - Question 44</small></p><p><strong>WAEC 2025 Literature in English - Question 44</strong></p><p><em>Come, thou gentle day</em> illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'apostrophe', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'apostrophe' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'paradox', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'paradox' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'irony', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'irony' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'euphemism', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'euphemism' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 45 - Question 45
SET @source_marker := 'WAEC 2025 Literature in English - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 45 - Question 45</small></p><p><strong>WAEC 2025 Literature in English - Question 45</strong></p><p>After the speech, the speaker</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'falls asleep', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'falls asleep' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'laughs uncontrollably', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'laughs uncontrollably' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'starts crying', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'starts crying' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'begins to dance', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'begins to dance' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 46 - Question 46
SET @source_marker := 'WAEC 2025 Literature in English - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 46 - Question 46</small></p><p><strong>WAEC 2025 Literature in English - Question 46</strong></p><p>The speaker is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hippolyta', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hippolyta' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bottom', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bottom' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pyramus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pyramus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lysander', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lysander' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 47 - Question 47
SET @source_marker := 'WAEC 2025 Literature in English - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 47 - Question 47</small></p><p><strong>WAEC 2025 Literature in English - Question 47</strong></p><p>The character that speaks before the speaker</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Theseus', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Theseus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pyramus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pyramus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hippolyta', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hippolyta' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Demetrius', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Demetrius' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 48 - Question 48
SET @source_marker := 'WAEC 2025 Literature in English - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 48 - Question 48</small></p><p><strong>WAEC 2025 Literature in English - Question 48</strong></p><p><em>it is not enough to speak, but to speak true</em> illustrates</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'parable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'parable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'epitaph', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'epitaph' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'epigram', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'epigram' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wisecrack', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'wisecrack' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 49 - Question 49
SET @source_marker := 'WAEC 2025 Literature in English - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 49 - Question 49</small></p><p><strong>WAEC 2025 Literature in English - Question 49</strong></p><p>The character that speaks after the speaker is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Demetrius', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Demetrius' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hippolyta', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hippolyta' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lysander', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lysander' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Titania', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Titania' AND deleted = 0);

-- WAEC 2025 Literature in English - Item 50 - Question 50
SET @source_marker := 'WAEC 2025 Literature in English - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @literature_in_english_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Literature in English - Item 50 - Question 50</small></p><p><strong>WAEC 2025 Literature in English - Question 50</strong></p><p>The character that delivers the prologue is</p>', @literature_in_english_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Literature in English', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Snug', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Snug' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Quince', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Quince' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Starveling', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Starveling' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Snout', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Snout' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS waec_2025_literature_in_english_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @waec_exam_body_id
  AND subject_id = @literature_in_english_subject_id
  AND exam_year = 2025
  AND question LIKE '%WAEC 2025 Literature in English - Item%';
