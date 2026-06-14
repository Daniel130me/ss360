-- BECE 2025 English Language questions for the global question bank.
-- Generated from: bece 2025 english language.md
-- Expected payload: 40 questions and 160 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.

SET NAMES utf8mb4;

-- Keep this migration runnable on databases where the global bank tables have
-- not yet been created by the application controller.
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
    KEY idx_qb_topic (topic_id),
    KEY idx_qb_exam_body (exam_body_id),
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
SELECT 'BECE', 'Basic Education Certificate Examination'
WHERE NOT EXISTS (SELECT 1 FROM exam_bodies WHERE name = 'BECE');

SET @bece_exam_body_id := (SELECT id FROM exam_bodies WHERE name = 'BECE' ORDER BY id ASC LIMIT 1);
SET @english_subject_id := (SELECT id FROM subjects WHERE subject IN ('English Language', 'English') ORDER BY FIELD(subject, 'English Language', 'English'), id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_bece_2025_english_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_bece_2025_english_refs()
BEGIN
    IF @bece_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BECE exam body could not be resolved.';
    END IF;
    IF @english_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'English Language subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_bece_2025_english_refs();
DROP PROCEDURE ss360_require_bece_2025_english_refs;

START TRANSACTION;

-- BECE 2025 English Language - Item 1 - Question 1
SET @source_marker := 'BECE 2025 English Language - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 1 - Question 1</small></p><p><strong>BECE 2025 English Language - Question 1</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>If it rained, the farmer ........ his seeds.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'will have sowed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'will have sowed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'will sow', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'will sow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'would have sowed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'would have sowed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'would sow', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'would sow' AND deleted = 0);

-- BECE 2025 English Language - Item 2 - Question 2
SET @source_marker := 'BECE 2025 English Language - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 2 - Question 2</small></p><p><strong>BECE 2025 English Language - Question 2</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>The laptop is ...... than the other two.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'expensive more rather', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'expensive more rather' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'expensive rather more', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'expensive rather more' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'more expensive rather', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'more expensive rather' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rather more expensive', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rather more expensive' AND deleted = 0);

-- BECE 2025 English Language - Item 3 - Question 3
SET @source_marker := 'BECE 2025 English Language - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 3 - Question 3</small></p><p><strong>BECE 2025 English Language - Question 3</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>Although there were ten beautiful bags in the shop, Sandra liked ........ of them.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'both', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'both' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'each', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'each' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neither', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'neither' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'none', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'none' AND deleted = 0);

-- BECE 2025 English Language - Item 4 - Question 4
SET @source_marker := 'BECE 2025 English Language - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 4 - Question 4</small></p><p><strong>BECE 2025 English Language - Question 4</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>Enrolment has increased ........ the new classroom was built.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'since', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'since' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'until', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'until' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'when', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'when' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'while', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'while' AND deleted = 0);

-- BECE 2025 English Language - Item 5 - Question 5
SET @source_marker := 'BECE 2025 English Language - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 5 - Question 5</small></p><p><strong>BECE 2025 English Language - Question 5</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>Our dog ........ barking since the stranger entered the house.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'has been', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'has been' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'is' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'was', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'was' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'would be', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'would be' AND deleted = 0);

-- BECE 2025 English Language - Item 6 - Question 6
SET @source_marker := 'BECE 2025 English Language - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 6 - Question 6</small></p><p><strong>BECE 2025 English Language - Question 6</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>We always ........ the lights before going to bed.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'off', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'off' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'put off', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'put off' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'put out', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'put out' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'out', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'out' AND deleted = 0);

-- BECE 2025 English Language - Item 7 - Question 7
SET @source_marker := 'BECE 2025 English Language - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 7 - Question 7</small></p><p><strong>BECE 2025 English Language - Question 7</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>We saw ........ people in the room.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a little', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'a little' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'much', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'much' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'plenty', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'plenty' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'many', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'many' AND deleted = 0);

-- BECE 2025 English Language - Item 8 - Question 8
SET @source_marker := 'BECE 2025 English Language - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 8 - Question 8</small></p><p><strong>BECE 2025 English Language - Question 8</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>Put the books on the shelf, ........?</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'do you', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'do you' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have you', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'have you' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'will you', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'will you' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'may you', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'may you' AND deleted = 0);

-- BECE 2025 English Language - Item 9 - Question 9
SET @source_marker := 'BECE 2025 English Language - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 9 - Question 9</small></p><p><strong>BECE 2025 English Language - Question 9</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>Amira prepared a delicious meal for her ........</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sisters-in-law', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sisters-in-law' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sister&#039;s-in-law', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sister&#039;s-in-law' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sisters-in-laws', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sisters-in-laws' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sisters&#039;-in-laws', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sisters&#039;-in-laws' AND deleted = 0);

-- BECE 2025 English Language - Item 10 - Question 10
SET @source_marker := 'BECE 2025 English Language - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 10 - Question 10</small></p><p><strong>BECE 2025 English Language - Question 10</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>The coach advised the two players to cooperate with ........</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'each other', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'each other' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'each one', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'each one' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ourselves', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ourselves' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'themselves', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'themselves' AND deleted = 0);

-- BECE 2025 English Language - Item 11 - Question 11
SET @source_marker := 'BECE 2025 English Language - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 11 - Question 11</small></p><p><strong>BECE 2025 English Language - Question 11</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>Selfish people always consider ........ first.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'herself', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'herself' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'myself', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'myself' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ourselves', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ourselves' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'themselves', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'themselves' AND deleted = 0);

-- BECE 2025 English Language - Item 12 - Question 12
SET @source_marker := 'BECE 2025 English Language - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 12 - Question 12</small></p><p><strong>BECE 2025 English Language - Question 12</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>Their gardener was ........ old to work.</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'even', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'even' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'so', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'so' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'too', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'too' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'very', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'very' AND deleted = 0);

-- BECE 2025 English Language - Item 13 - Question 13
SET @source_marker := 'BECE 2025 English Language - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 13 - Question 13</small></p><p><strong>BECE 2025 English Language - Question 13</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p><strong>To ........ did you deliver the message?</strong></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'who', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'who' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whoever', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whoever' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whom', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whom' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whomever', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whomever' AND deleted = 0);

-- BECE 2025 English Language - Item 14 - Question 14
SET @source_marker := 'BECE 2025 English Language - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 14 - Question 14</small></p><p><strong>BECE 2025 English Language - Question 14</strong></p><p>From the options A to D, choose the correct reported speech for the sentence below.</p><p><strong>Amarh asked Tettey, &quot;Did you see the new student yesterday?&quot;</strong></p><p>Amarh asked Tettey ........</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Reported Speech', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'if he had seen the new student the previous day', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'if he had seen the new student the previous day' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'if he had seen the new student yesterday', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'if he had seen the new student yesterday' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'did he see the new student the previous day', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'did he see the new student the previous day' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whether he saw the new student yesterday', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whether he saw the new student yesterday' AND deleted = 0);

-- BECE 2025 English Language - Item 15 - Question 15
SET @source_marker := 'BECE 2025 English Language - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 15 - Question 15</small></p><p><strong>BECE 2025 English Language - Question 15</strong></p><p>From the options A to D, choose the correct passive form of the sentence below.</p><p><strong>Had they completed the project before the deadline?</strong></p><p>........ the project been completed by them before the deadline?</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Passive Voice', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Has', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Has' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Was', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Was' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Had', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Had' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Were', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Were' AND deleted = 0);

-- BECE 2025 English Language - Item 16 - Question 16
SET @source_marker := 'BECE 2025 English Language - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 16 - Question 16</small></p><p><strong>BECE 2025 English Language - Question 16</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in the sentence.</p><p>Paul <u>purposely</u> left the door open.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carelessly', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'carelessly' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hurriedly', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hurriedly' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'intentionally', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'intentionally' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'occasionally', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'occasionally' AND deleted = 0);

-- BECE 2025 English Language - Item 17 - Question 17
SET @source_marker := 'BECE 2025 English Language - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 17 - Question 17</small></p><p><strong>BECE 2025 English Language - Question 17</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in the sentence.</p><p>Nobody paid any attention to the workers&#039; <u>demands</u>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'agitations', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'agitations' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'complaints', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'complaints' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'objections', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'objections' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'requests', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'requests' AND deleted = 0);

-- BECE 2025 English Language - Item 18 - Question 18
SET @source_marker := 'BECE 2025 English Language - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 18 - Question 18</small></p><p><strong>BECE 2025 English Language - Question 18</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in the sentence.</p><p>The boy&#039;s account of the incident was <u>elaborate</u>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'clear', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'clear' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'detailed', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'detailed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'interesting', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'interesting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'realistic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'realistic' AND deleted = 0);

-- BECE 2025 English Language - Item 19 - Question 19
SET @source_marker := 'BECE 2025 English Language - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 19 - Question 19</small></p><p><strong>BECE 2025 English Language - Question 19</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in the sentence.</p><p>It was <u>forecast</u> that there would be thunderstorm in the evening.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'broadcast', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'broadcast' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'calculated', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'calculated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'observed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'observed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'predicted', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'predicted' AND deleted = 0);

-- BECE 2025 English Language - Item 20 - Question 20
SET @source_marker := 'BECE 2025 English Language - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 20 - Question 20</small></p><p><strong>BECE 2025 English Language - Question 20</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in the sentence.</p><p>His <u>dubious</u> attitude has made him lose all his good friends.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deceitful', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'deceitful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disrespectful', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'disrespectful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'untrue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'untrue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unforgiving', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unforgiving' AND deleted = 0);

-- BECE 2025 English Language - Item 21 - Question 21
SET @source_marker := 'BECE 2025 English Language - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 21 - Question 21</small></p><p><strong>BECE 2025 English Language - Question 21</strong></p><p>In each of the following sentences, a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>Aminu is <u>full of himself</u>. This means that Aminu is ........</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'arrogant', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'arrogant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dangerous', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dangerous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'greedy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'greedy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quarrelsome', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'quarrelsome' AND deleted = 0);

-- BECE 2025 English Language - Item 22 - Question 22
SET @source_marker := 'BECE 2025 English Language - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 22 - Question 22</small></p><p><strong>BECE 2025 English Language - Question 22</strong></p><p>In each of the following sentences, a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>She tried to <u>throw dust in our eyes</u>. This means that she tried to ........</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cheat us', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cheat us' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deceive us', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'deceive us' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fight us', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fight us' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'make us blind', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'make us blind' AND deleted = 0);

-- BECE 2025 English Language - Item 23 - Question 23
SET @source_marker := 'BECE 2025 English Language - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 23 - Question 23</small></p><p><strong>BECE 2025 English Language - Question 23</strong></p><p>In each of the following sentences, a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>On seeing the angry mob approaching the school, our school prefect told us to <u>take to our heels</u>. This means that the prefect told us to ........</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hurry up', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hurry up' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'join them', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'join them' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'run away', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'run away' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'walk gracefully', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'walk gracefully' AND deleted = 0);

-- BECE 2025 English Language - Item 24 - Question 24
SET @source_marker := 'BECE 2025 English Language - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 24 - Question 24</small></p><p><strong>BECE 2025 English Language - Question 24</strong></p><p>In each of the following sentences, a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>The two boys have often been <u>at loggerheads</u> with each other. This means that they ........</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'are usually seen walking together', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'are usually seen walking together' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have often exchanged ideas', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'have often exchanged ideas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have often had strong disagreements', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'have often had strong disagreements' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'usually have the same views on issues', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'usually have the same views on issues' AND deleted = 0);

-- BECE 2025 English Language - Item 25 - Question 25
SET @source_marker := 'BECE 2025 English Language - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 25 - Question 25</small></p><p><strong>BECE 2025 English Language - Question 25</strong></p><p>In each of the following sentences, a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>I learnt to <u>paddle my own canoe</u>. This means that I ........</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'am independent and need no help from others', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'am independent and need no help from others' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'do not interfere in other people&#039;s matters', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'do not interfere in other people&#039;s matters' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have no help in my fishing business', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'have no help in my fishing business' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'work hard to feed myself and my family', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'work hard to feed myself and my family' AND deleted = 0);

-- BECE 2025 English Language - Item 26 - Question 26
SET @source_marker := 'BECE 2025 English Language - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 26 - Question 26</small></p><p><strong>BECE 2025 English Language - Question 26</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word to fill the gap in the sentence.</p><p>The Policeman was reported to have <u>concealed</u> the evidence, but ........ it to the Jury.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disclosed', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'disclosed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gathered', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gathered' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'found', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'found' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'planted', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'planted' AND deleted = 0);

-- BECE 2025 English Language - Item 27 - Question 27
SET @source_marker := 'BECE 2025 English Language - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 27 - Question 27</small></p><p><strong>BECE 2025 English Language - Question 27</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word to fill the gap in the sentence.</p><p>He loves taking <u>hasty</u> decisions so he never makes ........ moves.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'calculated', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'calculated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smart', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smart' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'delayed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'delayed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'final', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'final' AND deleted = 0);

-- BECE 2025 English Language - Item 28 - Question 28
SET @source_marker := 'BECE 2025 English Language - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 28 - Question 28</small></p><p><strong>BECE 2025 English Language - Question 28</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word to fill the gap in the sentence.</p><p>Those children think their uncle is <u>miserly</u> yet he is ........ to strangers.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'friendly', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'friendly' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'generous', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'generous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'strict', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'strict' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wicked', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wicked' AND deleted = 0);

-- BECE 2025 English Language - Item 29 - Question 29
SET @source_marker := 'BECE 2025 English Language - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 29 - Question 29</small></p><p><strong>BECE 2025 English Language - Question 29</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word to fill the gap in the sentence.</p><p>Though we expected <strong>.......</strong>, the judge handled the case with <u>partiality</u></p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fairness', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fairness' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'happiness', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'happiness' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'patience', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'patience' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seriousness', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seriousness' AND deleted = 0);

-- BECE 2025 English Language - Item 30 - Question 30
SET @source_marker := 'BECE 2025 English Language - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 30 - Question 30</small></p><p><strong>BECE 2025 English Language - Question 30</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word to fill the gap in the sentence.</p><p>The minister publicly <u>rebukes</u> his assistant and always ........ his secretary.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'advises', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'advises' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commends', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'commends' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'embraces', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'embraces' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'harasses', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'harasses' AND deleted = 0);

-- BECE 2025 English Language - Item 31 - Question 31
SET @source_marker := 'BECE 2025 English Language - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 31 - Question 31</small></p><p><strong>BECE 2025 English Language - Question 31</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>Akuba was trained as an accountant. After graduation, she went out to <strong>-31-</strong> employment. She visited several firms but was <strong>-32-</strong> in securing a job. Afiba, her friend, finally advised her to read the newspapers for <strong>-33-</strong> of vacant positions. Fortunately, a reputable company was looking for a <strong>-34-</strong> accountant who was <strong>-35-</strong> in financial reporting. Akuba immediately submitted her application, attended an interview and within a week, she received an appointment letter. Her patience and perseverance had finally paid off.</p><p>Akuba was trained as an accountant. After graduation, she went out to <strong>-31-</strong> employment.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'search', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'search' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'look', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'look' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seek', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seek' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'request', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'request' AND deleted = 0);

-- BECE 2025 English Language - Item 32 - Question 32
SET @source_marker := 'BECE 2025 English Language - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 32 - Question 32</small></p><p><strong>BECE 2025 English Language - Question 32</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>Akuba was trained as an accountant. After graduation, she went out to <strong>-31-</strong> employment. She visited several firms but was <strong>-32-</strong> in securing a job. Afiba, her friend, finally advised her to read the newspapers for <strong>-33-</strong> of vacant positions. Fortunately, a reputable company was looking for a <strong>-34-</strong> accountant who was <strong>-35-</strong> in financial reporting. Akuba immediately submitted her application, attended an interview and within a week, she received an appointment letter. Her patience and perseverance had finally paid off.</p><p>She visited several firms but was <strong>-32-</strong> in securing a job.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unfortunate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unfortunate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unsuccessful', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unsuccessful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unlucky', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unlucky' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disappointed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'disappointed' AND deleted = 0);

-- BECE 2025 English Language - Item 33 - Question 33
SET @source_marker := 'BECE 2025 English Language - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 33 - Question 33</small></p><p><strong>BECE 2025 English Language - Question 33</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>Akuba was trained as an accountant. After graduation, she went out to <strong>-31-</strong> employment. She visited several firms but was <strong>-32-</strong> in securing a job. Afiba, her friend, finally advised her to read the newspapers for <strong>-33-</strong> of vacant positions. Fortunately, a reputable company was looking for a <strong>-34-</strong> accountant who was <strong>-35-</strong> in financial reporting. Akuba immediately submitted her application, attended an interview and within a week, she received an appointment letter. Her patience and perseverance had finally paid off.</p><p>Afiba, her friend, finally advised her to read the newspapers for <strong>-33-</strong> of vacant positions.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'information', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'information' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'notices', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'notices' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'advertisements', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'advertisements' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'announcements', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'announcements' AND deleted = 0);

-- BECE 2025 English Language - Item 34 - Question 34
SET @source_marker := 'BECE 2025 English Language - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 34 - Question 34</small></p><p><strong>BECE 2025 English Language - Question 34</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>Akuba was trained as an accountant. After graduation, she went out to <strong>-31-</strong> employment. She visited several firms but was <strong>-32-</strong> in securing a job. Afiba, her friend, finally advised her to read the newspapers for <strong>-33-</strong> of vacant positions. Fortunately, a reputable company was looking for a <strong>-34-</strong> accountant who was <strong>-35-</strong> in financial reporting. Akuba immediately submitted her application, attended an interview and within a week, she received an appointment letter. Her patience and perseverance had finally paid off.</p><p>Fortunately, a reputable company was looking for a <strong>-34-</strong> accountant who was <strong>-35-</strong> in financial reporting.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'certified', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'certified' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'skilled', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'skilled' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'responsible', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'responsible' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'professional', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'professional' AND deleted = 0);

-- BECE 2025 English Language - Item 35 - Question 35
SET @source_marker := 'BECE 2025 English Language - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 35 - Question 35</small></p><p><strong>BECE 2025 English Language - Question 35</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>Akuba was trained as an accountant. After graduation, she went out to <strong>-31-</strong> employment. She visited several firms but was <strong>-32-</strong> in securing a job. Afiba, her friend, finally advised her to read the newspapers for <strong>-33-</strong> of vacant positions. Fortunately, a reputable company was looking for a <strong>-34-</strong> accountant who was <strong>-35-</strong> in financial reporting. Akuba immediately submitted her application, attended an interview and within a week, she received an appointment letter. Her patience and perseverance had finally paid off.</p><p>Fortunately, a reputable company was looking for a professional accountant who was <strong>-35-</strong> in financial reporting.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'competent', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'competent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'proficient', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'proficient' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'knowledgeable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'knowledgeable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'specialized', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'specialized' AND deleted = 0);

-- BECE 2025 English Language - Item 36 - Question 36
SET @source_marker := 'BECE 2025 English Language - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 36 - Question 36</small></p><p><strong>BECE 2025 English Language - Question 36</strong></p><p>Choose from the options A to D, the one which has the same initial consonant sound as the word underlined in the sentence below.</p><p>The car sped around the <u>curve</u>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Initial Consonant Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chain', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'chain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cell', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cell' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'colonel', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'colonel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ciao', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ciao' AND deleted = 0);

-- BECE 2025 English Language - Item 37 - Question 37
SET @source_marker := 'BECE 2025 English Language - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 37 - Question 37</small></p><p><strong>BECE 2025 English Language - Question 37</strong></p><p>Choose from the options A to D, the one which has the same initial consonant sound as the word underlined in the sentence below.</p><p>We won the <u>game</u> easily.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Initial Consonant Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'giant', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'giant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gentle', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gentle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'general', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'general' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'goat', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'goat' AND deleted = 0);

-- BECE 2025 English Language - Item 38 - Question 38
SET @source_marker := 'BECE 2025 English Language - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 38 - Question 38</small></p><p><strong>BECE 2025 English Language - Question 38</strong></p><p>Choose from the options A to D, the one which has the same initial consonant sound as the word underlined in the sentence below.</p><p>She received a beautiful <u>psalm</u>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Initial Consonant Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sand', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sand' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'palm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'palm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shall', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shall' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'page', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'page' AND deleted = 0);

-- BECE 2025 English Language - Item 39 - Question 39
SET @source_marker := 'BECE 2025 English Language - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 39 - Question 39</small></p><p><strong>BECE 2025 English Language - Question 39</strong></p><p>Choose from the options A to D, the one which has the same vowel sound as the word underlined in the sentences below.</p><p>The city grew quieter with each passing <u>hour</u>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Vowel Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bowl', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bowl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'your', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'your' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'owl', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'owl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tour', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tour' AND deleted = 0);

-- BECE 2025 English Language - Item 40 - Question 40
SET @source_marker := 'BECE 2025 English Language - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 English Language - Item 40 - Question 40</small></p><p><strong>BECE 2025 English Language - Question 40</strong></p><p>Choose from the options A to D, the one which has the same vowel sound as the word underlined in the sentences below.</p><p>The <u>queue</u> moved slowly, yet no one seemed to mind.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Vowel Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quest', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'quest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'few', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'few' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fee', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fee' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cool', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cool' AND deleted = 0);

COMMIT;

-- Verification helpers after running this migration:
-- SELECT COUNT(*) AS bece_2025_questions FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%BECE 2025 English Language - Item%';
-- SELECT COUNT(*) AS bece_2025_options FROM question_bank_options o JOIN question_bank q ON q.id = o.question_id WHERE q.source_type = 'exam_body' AND q.exam_body_id = @bece_exam_body_id AND q.subject_id = @english_subject_id AND q.question LIKE '%BECE 2025 English Language - Item%' AND o.deleted = 0;
