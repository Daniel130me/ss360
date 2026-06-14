-- BECE 2024 English Language questions for the global question bank.
-- Generated from: bece 2024 english language.md
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

DROP PROCEDURE IF EXISTS ss360_require_bece_2024_english_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_bece_2024_english_refs()
BEGIN
    IF @bece_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BECE exam body could not be resolved.';
    END IF;
    IF @english_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'English Language subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_bece_2024_english_refs();
DROP PROCEDURE ss360_require_bece_2024_english_refs;

START TRANSACTION;

-- BECE 2024 English Language - Item 1 - Question 1
SET @source_marker := 'BECE 2024 English Language - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 1 - Question 1</small></p><p><strong>BECE 2024 English Language - Question 1</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Ali&#039;s parents have not bought ....... of the two recommended books.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'any', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'any' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neither', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'neither' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'either', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'either' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'none', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'none' AND deleted = 0);

-- BECE 2024 English Language - Item 2 - Question 2
SET @source_marker := 'BECE 2024 English Language - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 2 - Question 2</small></p><p><strong>BECE 2024 English Language - Question 2</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>We were served a ....... meal at that cosy restaurant.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Spanish delicious spicy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Spanish delicious spicy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spicy Spanish delicious', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'spicy Spanish delicious' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'delicious Spanish spicy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'delicious Spanish spicy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'delicious spicy Spanish', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'delicious spicy Spanish' AND deleted = 0);

-- BECE 2024 English Language - Item 3 - Question 3
SET @source_marker := 'BECE 2024 English Language - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 3 - Question 3</small></p><p><strong>BECE 2024 English Language - Question 3</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Last Wednesday, it rained heavily ........ the match was played.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'yet', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'yet' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'for', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'for' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'and', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'and' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'so', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'so' AND deleted = 0);

-- BECE 2024 English Language - Item 4 - Question 4
SET @source_marker := 'BECE 2024 English Language - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 4 - Question 4</small></p><p><strong>BECE 2024 English Language - Question 4</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Adwoa&#039;s daughter is allergic ....... dust.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'to' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'against', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'against' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'about', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'about' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'with', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'with' AND deleted = 0);

-- BECE 2024 English Language - Item 5 - Question 5
SET @source_marker := 'BECE 2024 English Language - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 5 - Question 5</small></p><p><strong>BECE 2024 English Language - Question 5</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Konlaan suggested that it was time they ....... for the meeting.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have to leave', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'have to leave' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'leave', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'leave' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'left', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'left' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'had to leave', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'had to leave' AND deleted = 0);

-- BECE 2024 English Language - Item 6 - Question 6
SET @source_marker := 'BECE 2024 English Language - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 6 - Question 6</small></p><p><strong>BECE 2024 English Language - Question 6</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>At my last interview, I faced ....... panel.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a seven-member', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'a seven-member' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seven-members&#039;', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seven-members&#039;' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seven-members', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seven-members' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a seven-member&#039;s', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'a seven-member&#039;s' AND deleted = 0);

-- BECE 2024 English Language - Item 7 - Question 7
SET @source_marker := 'BECE 2024 English Language - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 7 - Question 7</small></p><p><strong>BECE 2024 English Language - Question 7</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Last month, there was .......</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an eclipse of a sun', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'an eclipse of a sun' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an eclipse of the sun', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'an eclipse of the sun' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the eclipse of the sun', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'the eclipse of the sun' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the eclipse of a sun', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'the eclipse of a sun' AND deleted = 0);

-- BECE 2024 English Language - Item 8 - Question 8
SET @source_marker := 'BECE 2024 English Language - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 8 - Question 8</small></p><p><strong>BECE 2024 English Language - Question 8</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Dauda saw the thief ....... out of the shop.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ran', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ran' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is running', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'is running' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'run', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'run' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'was running', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'was running' AND deleted = 0);

-- BECE 2024 English Language - Item 9 - Question 9
SET @source_marker := 'BECE 2024 English Language - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 9 - Question 9</small></p><p><strong>BECE 2024 English Language - Question 9</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>If Azameti had won gold, Ghanaians .......</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'will have jubilated', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'will have jubilated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'would have jubilated', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'would have jubilated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'would jubilate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'would jubilate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'will jubilate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'will jubilate' AND deleted = 0);

-- BECE 2024 English Language - Item 10 - Question 10
SET @source_marker := 'BECE 2024 English Language - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 10 - Question 10</small></p><p><strong>BECE 2024 English Language - Question 10</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Among the participants for the competition, Eugenia got there ........ early.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'most', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'most' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'often', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'often' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'very', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'very' AND deleted = 0);

-- BECE 2024 English Language - Item 11 - Question 11
SET @source_marker := 'BECE 2024 English Language - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 11 - Question 11</small></p><p><strong>BECE 2024 English Language - Question 11</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Afiba&#039;s aunt, ....... lives in Tamale, spoke to us very courteously.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whom', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whom' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'which', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'which' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'who', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'who' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'that', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'that' AND deleted = 0);

-- BECE 2024 English Language - Item 12 - Question 12
SET @source_marker := 'BECE 2024 English Language - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 12 - Question 12</small></p><p><strong>BECE 2024 English Language - Question 12</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>You haven&#039;t met each other before, ....... you?</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hadn&#039;t', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hadn&#039;t' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'had', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'had' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'haven&#039;t', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'haven&#039;t' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'have' AND deleted = 0);

-- BECE 2024 English Language - Item 13 - Question 13
SET @source_marker := 'BECE 2024 English Language - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 13 - Question 13</small></p><p><strong>BECE 2024 English Language - Question 13</strong></p><p>Choose from the options A to D, the one which most suitably completes the sentence.</p><p>Which of the ....... fragrance(s) is milder?</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'most', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'most' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'two', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'two' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'one', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'one' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'all', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'all' AND deleted = 0);

-- BECE 2024 English Language - Item 14 - Question 14
SET @source_marker := 'BECE 2024 English Language - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 14 - Question 14</small></p><p><strong>BECE 2024 English Language - Question 14</strong></p><p>The correct passive form of the sentence below is:</p><p>For winning the first position in the Essay Competition, the school gave Linda a laptop.</p><p>For winning the first position in the Essay Competition, Linda ....... given a laptop by the school.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Passive Voice', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'is' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'was', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'was' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is being', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'is being' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'has been', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'has been' AND deleted = 0);

-- BECE 2024 English Language - Item 15 - Question 15
SET @source_marker := 'BECE 2024 English Language - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 15 - Question 15</small></p><p><strong>BECE 2024 English Language - Question 15</strong></p><p>The correct reported speech for the sentence below is:</p><p>&quot;I will keep my word&quot;, promised Kende.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Kende promise to keep her word.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Kende promise to keep her word.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Kende promised to keep her word.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Kende promised to keep her word.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Kende is promising to keep her word.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Kende is promising to keep her word.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Kende promises to keep her word.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Kende promises to keep her word.' AND deleted = 0);

-- BECE 2024 English Language - Item 16 - Question 16
SET @source_marker := 'BECE 2024 English Language - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 16 - Question 16</small></p><p><strong>BECE 2024 English Language - Question 16</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in each sentence.</p><p>Mama said, &quot;You can only fight off bullies if you are <u>assertive</u>&quot;.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smart', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smart' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bold', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bold' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'strong', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'strong' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'muscular', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'muscular' AND deleted = 0);

-- BECE 2024 English Language - Item 17 - Question 17
SET @source_marker := 'BECE 2024 English Language - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 17 - Question 17</small></p><p><strong>BECE 2024 English Language - Question 17</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in each sentence.</p><p>The <u>salient</u> points of the topic have been thoroughly discussed.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chosen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'chosen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'important', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'important' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'interesting', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'interesting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'highlighted', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'highlighted' AND deleted = 0);

-- BECE 2024 English Language - Item 18 - Question 18
SET @source_marker := 'BECE 2024 English Language - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 18 - Question 18</small></p><p><strong>BECE 2024 English Language - Question 18</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in each sentence.</p><p>Little Asabea <u>wondered</u> why her grandfather walked so slowly.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thought about why', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'thought about why' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'felt frustrated that', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'felt frustrated that' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'was saddened that', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'was saddened that' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'was curious about why', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'was curious about why' AND deleted = 0);

-- BECE 2024 English Language - Item 19 - Question 19
SET @source_marker := 'BECE 2024 English Language - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 19 - Question 19</small></p><p><strong>BECE 2024 English Language - Question 19</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in each sentence.</p><p>The <u>rampant</u> destruction of property must be checked.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unpleasant', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unpleasant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'uncontrolled', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'uncontrolled' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'regular', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'regular' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'common', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'common' AND deleted = 0);

-- BECE 2024 English Language - Item 20 - Question 20
SET @source_marker := 'BECE 2024 English Language - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 20 - Question 20</small></p><p><strong>BECE 2024 English Language - Question 20</strong></p><p>Choose from the options A to D, the one which is nearest in meaning to the underlined word in each sentence.</p><p>We&#039;re so excited because Amuzu&#039;s <u>proposal</u> has been accepted.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'offer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'offer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'opinion', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'opinion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'view', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'view' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'suggestion', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'suggestion' AND deleted = 0);

-- BECE 2024 English Language - Item 21 - Question 21
SET @source_marker := 'BECE 2024 English Language - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 21 - Question 21</small></p><p><strong>BECE 2024 English Language - Question 21</strong></p><p>In each of the following sentences a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>&quot;Do not be such a <u>wet blanket</u>, Afua. Your brother needs all the support you can give him&quot;, Auntie Araba chided her daughter.</p><p>This means that Afua ...... her brother.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'couldn&#039;t wash for', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'couldn&#039;t wash for' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'liked to discourage', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'liked to discourage' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'didn&#039;t care about', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'didn&#039;t care about' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'was too weak to help', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'was too weak to help' AND deleted = 0);

-- BECE 2024 English Language - Item 22 - Question 22
SET @source_marker := 'BECE 2024 English Language - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 22 - Question 22</small></p><p><strong>BECE 2024 English Language - Question 22</strong></p><p>In each of the following sentences a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>The chief advised his subjects not to allow anger to <u>get the better of them</u>.</p><p>This means that they should not let anger ...... them.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sadden', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sadden' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'divide', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'divide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deceive', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'deceive' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'control', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'control' AND deleted = 0);

-- BECE 2024 English Language - Item 23 - Question 23
SET @source_marker := 'BECE 2024 English Language - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 23 - Question 23</small></p><p><strong>BECE 2024 English Language - Question 23</strong></p><p>In each of the following sentences a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>Asuo had to <u>eat his words</u> when Asante Kotoko lost to Tano Bofoakwa FC.</p><p>This means that Asuo .......</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'denied everything he had said', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'denied everything he had said' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lost his appetite', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'lost his appetite' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'admitted that he was wrong', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'admitted that he was wrong' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'became very ashamed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'became very ashamed' AND deleted = 0);

-- BECE 2024 English Language - Item 24 - Question 24
SET @source_marker := 'BECE 2024 English Language - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 24 - Question 24</small></p><p><strong>BECE 2024 English Language - Question 24</strong></p><p>In each of the following sentences a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>The fraudster was <u>paid back in his own coins</u>.</p><p>This means that he was .......</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'given new coins', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'given new coins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'given a hot chase', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'given a hot chase' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'swindled', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'swindled' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'punished', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'punished' AND deleted = 0);

-- BECE 2024 English Language - Item 25 - Question 25
SET @source_marker := 'BECE 2024 English Language - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 25 - Question 25</small></p><p><strong>BECE 2024 English Language - Question 25</strong></p><p>In each of the following sentences a group of words has been underlined. Choose from the options A to D, the one that best explains the underlined group of words.</p><p>Yaaba <u>hit the nail on the head</u> when she told us that we could only succeed through hard work.</p><p>This means that Yaaba .......</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Idioms / Meaning in Context', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'told us the truth', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'told us the truth' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'showed that she disliked us', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'showed that she disliked us' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'was a good hairdresser', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'was a good hairdresser' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tried to deceive us', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tried to deceive us' AND deleted = 0);

-- BECE 2024 English Language - Item 26 - Question 26
SET @source_marker := 'BECE 2024 English Language - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 26 - Question 26</small></p><p><strong>BECE 2024 English Language - Question 26</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word in each sentence.</p><p>Regions with <u>abundant</u> rainfall are different from those having ....... moisture.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'uncertain', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'uncertain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reduced', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reduced' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'scanty', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'scanty' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unpredictable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unpredictable' AND deleted = 0);

-- BECE 2024 English Language - Item 27 - Question 27
SET @source_marker := 'BECE 2024 English Language - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 27 - Question 27</small></p><p><strong>BECE 2024 English Language - Question 27</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word in each sentence.</p><p>Due to the ongoing road construction, our shops have been <u>temporarily</u> closed down.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'legally', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'legally' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'permanently', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'permanently' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'constantly', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'constantly' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deliberately', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'deliberately' AND deleted = 0);

-- BECE 2024 English Language - Item 28 - Question 28
SET @source_marker := 'BECE 2024 English Language - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 28 - Question 28</small></p><p><strong>BECE 2024 English Language - Question 28</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word in each sentence.</p><p>It is hard to tell when this began or where it will .......</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cease', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cease' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'remain', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'remain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reside', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reside' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fall', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fall' AND deleted = 0);

-- BECE 2024 English Language - Item 29 - Question 29
SET @source_marker := 'BECE 2024 English Language - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 29 - Question 29</small></p><p><strong>BECE 2024 English Language - Question 29</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word in each sentence.</p><p>Some exercises may seem easy in <u>theoretical</u> terms but can be really difficult in ....... aspects.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'actual', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'actual' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'natural', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'natural' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'logical', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'logical' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'practical', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'practical' AND deleted = 0);

-- BECE 2024 English Language - Item 30 - Question 30
SET @source_marker := 'BECE 2024 English Language - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 30 - Question 30</small></p><p><strong>BECE 2024 English Language - Question 30</strong></p><p>Choose from the options A to D, the one that is most nearly opposite in meaning to the underlined word in each sentence.</p><p>It is good to get a cure for a disease, but it is better to ....... the disease.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'avoid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'avoid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prevent', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'prevent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'counter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'counter' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protect', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'protect' AND deleted = 0);

-- BECE 2024 English Language - Item 31 - Question 31
SET @source_marker := 'BECE 2024 English Language - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 31 - Question 31</small></p><p><strong>BECE 2024 English Language - Question 31</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>The meeting began with the reading of the minutes of the previous meeting. The Chairman asked if there were any corrections to be made to the minutes. Then one member complained that after checking the <strong>-31-</strong> list, he realised that his name had been wrongly spelt. The Chairman apologised for the error and the matter was resolved. Two <strong>-32-</strong> were proposed and voted on. At the end of the discussions, the Chairman asked a member to <strong>-33-</strong> for the closure of the meeting. Tetteh Oko did and he was <strong>-34-</strong> by Adjoa Mansa. The meeting was then <strong>-35-</strong> to a new date.</p><p>Select the word that best fills gap <strong>-31-</strong>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'compiled', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'compiled' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'present', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'present' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'attendance', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'attendance' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'register', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'register' AND deleted = 0);

-- BECE 2024 English Language - Item 32 - Question 32
SET @source_marker := 'BECE 2024 English Language - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 32 - Question 32</small></p><p><strong>BECE 2024 English Language - Question 32</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>The meeting began with the reading of the minutes of the previous meeting. The Chairman asked if there were any corrections to be made to the minutes. Then one member complained that after checking the <strong>-31-</strong> list, he realised that his name had been wrongly spelt. The Chairman apologised for the error and the matter was resolved. Two <strong>-32-</strong> were proposed and voted on. At the end of the discussions, the Chairman asked a member to <strong>-33-</strong> for the closure of the meeting. Tetteh Oko did and he was <strong>-34-</strong> by Adjoa Mansa. The meeting was then <strong>-35-</strong> to a new date.</p><p>Select the word that best fills gap <strong>-32-</strong>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ideas', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ideas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'intentions', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'intentions' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decisions', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'decisions' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'motions', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'motions' AND deleted = 0);

-- BECE 2024 English Language - Item 33 - Question 33
SET @source_marker := 'BECE 2024 English Language - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 33 - Question 33</small></p><p><strong>BECE 2024 English Language - Question 33</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>The meeting began with the reading of the minutes of the previous meeting. The Chairman asked if there were any corrections to be made to the minutes. Then one member complained that after checking the <strong>-31-</strong> list, he realised that his name had been wrongly spelt. The Chairman apologised for the error and the matter was resolved. Two <strong>-32-</strong> were proposed and voted on. At the end of the discussions, the Chairman asked a member to <strong>-33-</strong> for the closure of the meeting. Tetteh Oko did and he was <strong>-34-</strong> by Adjoa Mansa. The meeting was then <strong>-35-</strong> to a new date.</p><p>Select the word that best fills gap <strong>-33-</strong>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'move', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'move' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'call', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'call' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'declare', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'declare' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'recommend', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'recommend' AND deleted = 0);

-- BECE 2024 English Language - Item 34 - Question 34
SET @source_marker := 'BECE 2024 English Language - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 34 - Question 34</small></p><p><strong>BECE 2024 English Language - Question 34</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>The meeting began with the reading of the minutes of the previous meeting. The Chairman asked if there were any corrections to be made to the minutes. Then one member complained that after checking the <strong>-31-</strong> list, he realised that his name had been wrongly spelt. The Chairman apologised for the error and the matter was resolved. Two <strong>-32-</strong> were proposed and voted on. At the end of the discussions, the Chairman asked a member to <strong>-33-</strong> for the closure of the meeting. Tetteh Oko did and he was <strong>-34-</strong> by Adjoa Mansa. The meeting was then <strong>-35-</strong> to a new date.</p><p>Select the word that best fills gap <strong>-34-</strong>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'upheld', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'upheld' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'approved', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'approved' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seconded', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seconded' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'supported', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'supported' AND deleted = 0);

-- BECE 2024 English Language - Item 35 - Question 35
SET @source_marker := 'BECE 2024 English Language - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 35 - Question 35</small></p><p><strong>BECE 2024 English Language - Question 35</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage are four options arranged in columns lettered A to D. For each numbered gap, choose from the options provided, the word that is most suitable.</p><p><strong>Passage</strong></p><p>The meeting began with the reading of the minutes of the previous meeting. The Chairman asked if there were any corrections to be made to the minutes. Then one member complained that after checking the <strong>-31-</strong> list, he realised that his name had been wrongly spelt. The Chairman apologised for the error and the matter was resolved. Two <strong>-32-</strong> were proposed and voted on. At the end of the discussions, the Chairman asked a member to <strong>-33-</strong> for the closure of the meeting. Tetteh Oko did and he was <strong>-34-</strong> by Adjoa Mansa. The meeting was then <strong>-35-</strong> to a new date.</p><p>Select the word that best fills gap <strong>-35-</strong>.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'adjourned', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'adjourned' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shifted', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shifted' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deferred', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'deferred' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'postponed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'postponed' AND deleted = 0);

-- BECE 2024 English Language - Item 36 - Question 36
SET @source_marker := 'BECE 2024 English Language - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 36 - Question 36</small></p><p><strong>BECE 2024 English Language - Question 36</strong></p><p>Choose from the options A to D, the one which has the same consonant sound as the word underlined in the sentences below.</p><p>Those two are ar<u>ch</u> rivals.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Consonant Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'splash', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'splash' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'path', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'path' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spark', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'spark' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'patch', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'patch' AND deleted = 0);

-- BECE 2024 English Language - Item 37 - Question 37
SET @source_marker := 'BECE 2024 English Language - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 37 - Question 37</small></p><p><strong>BECE 2024 English Language - Question 37</strong></p><p>Choose from the options A to D, the one which has the same consonant sound as the word underlined in the sentences below.</p><p>Prosper is the new <u>ch</u>ef.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Consonant Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chair', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'chair' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'scheme', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'scheme' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chord', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'chord' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shield', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shield' AND deleted = 0);

-- BECE 2024 English Language - Item 38 - Question 38
SET @source_marker := 'BECE 2024 English Language - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 38 - Question 38</small></p><p><strong>BECE 2024 English Language - Question 38</strong></p><p>Choose from the options A to D, the one which has the same consonant sound as the word underlined in the sentences below.</p><p>Lariba sp<u>r</u>ang to her feet.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Consonant Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'splashed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'splashed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sprayed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sprayed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'struck', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'struck' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'slew', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'slew' AND deleted = 0);

-- BECE 2024 English Language - Item 39 - Question 39
SET @source_marker := 'BECE 2024 English Language - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 39 - Question 39</small></p><p><strong>BECE 2024 English Language - Question 39</strong></p><p>Choose from the options A to D, the one which has the same vowel sound as the word underlined in the sentences below.</p><p>Wh<u>o</u>le grains are healthier than polished ones.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Vowel Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Goal', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Goal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gaul', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Gaul' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gill', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Gill' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gaol', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Gaol' AND deleted = 0);

-- BECE 2024 English Language - Item 40 - Question 40
SET @source_marker := 'BECE 2024 English Language - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 English Language - Item 40 - Question 40</small></p><p><strong>BECE 2024 English Language - Question 40</strong></p><p>Choose from the options A to D, the one which has the same vowel sound as the word underlined in the sentences below.</p><p>The h<u>ei</u>r to the British throne was the Duke of Cornwall.</p>', @english_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Vowel Sound', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'air', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'air' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hail', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hail' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hew', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hew' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'here', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'here' AND deleted = 0);

COMMIT;

-- Verification helpers after running this migration:
-- SELECT COUNT(*) AS bece_2024_questions FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%BECE 2024 English Language - Item%';
-- SELECT COUNT(*) AS bece_2024_options FROM question_bank_options o JOIN question_bank q ON q.id = o.question_id WHERE q.source_type = 'exam_body' AND q.exam_body_id = @bece_exam_body_id AND q.subject_id = @english_subject_id AND q.question LIKE '%BECE 2024 English Language - Item%' AND o.deleted = 0;
