-- WAEC 2025 English Language past questions for the global question bank.
-- Generated from: waec 2025 english past question.md
-- Expected payload: 140 questions and 560 options.
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
SET @english_subject_id := (SELECT id FROM subjects WHERE subject IN ('English Language', 'English') ORDER BY FIELD(subject, 'English Language', 'English'), id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_waec_2025_english_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_waec_2025_english_refs()
BEGIN
    IF @waec_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WAEC exam body could not be resolved.';
    END IF;
    IF @english_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'English Language subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_waec_2025_english_refs();
DROP PROCEDURE ss360_require_waec_2025_english_refs;

START TRANSACTION;

-- WAEC 2025 English - Item 1 - Question 1
SET @source_marker := 'WAEC 2025 English - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 1 - Question 1</small></p><p><strong>WAEC 2025 English - Question 1</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>The <u>posh</u> cars were sandwiched between two ______ ones.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rickety', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rickety' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rugged', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rugged' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'modest', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'modest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dented', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dented' AND deleted = 0);

-- WAEC 2025 English - Item 2 - Question 2
SET @source_marker := 'WAEC 2025 English - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 2 - Question 2</small></p><p><strong>WAEC 2025 English - Question 2</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>A <u>trivial</u> issue often becomes ______ when it is not properly handled.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unbearable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unbearable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'valuable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'valuable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ordinary', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ordinary' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'serious', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'serious' AND deleted = 0);

-- WAEC 2025 English - Item 3 - Question 3
SET @source_marker := 'WAEC 2025 English - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 3 - Question 3</small></p><p><strong>WAEC 2025 English - Question 3</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>The rockstar&#039;s <u>stellar</u> performance contrasted sharply with the ______ showing of the amateur group.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'routine', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'routine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'awkward', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'awkward' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mundane', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'mundane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'woeful', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'woeful' AND deleted = 0);

-- WAEC 2025 English - Item 4 - Question 4
SET @source_marker := 'WAEC 2025 English - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 4 - Question 4</small></p><p><strong>WAEC 2025 English - Question 4</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>Tolu was <u>sanctioned</u> for late-coming but his friend was ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pardoned', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'pardoned' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'released', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'released' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ignored', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ignored' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exempted', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'exempted' AND deleted = 0);

-- WAEC 2025 English - Item 5 - Question 5
SET @source_marker := 'WAEC 2025 English - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 5 - Question 5</small></p><p><strong>WAEC 2025 English - Question 5</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>While other teachers&#039; support for the action ______, Victor&#039;s was <u>dogged</u>.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'woeful', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'woeful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disappointing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'disappointing' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wavering', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wavering' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'declining', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'declining' AND deleted = 0);

-- WAEC 2025 English - Item 6 - Question 6
SET @source_marker := 'WAEC 2025 English - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 6 - Question 6</small></p><p><strong>WAEC 2025 English - Question 6</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>Some people are good at <u>terminating</u> other people&#039;s projects but are not capable of ______ theirs.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'designing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'designing' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'executing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'executing' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'initiating', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'initiating' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'organising', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'organising' AND deleted = 0);

-- WAEC 2025 English - Item 7 - Question 7
SET @source_marker := 'WAEC 2025 English - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 7 - Question 7</small></p><p><strong>WAEC 2025 English - Question 7</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>The <u>precarious</u> terraces of the stadium have been transformed into a ______ walkway.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'secure', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'secure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'narrow', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'narrow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'durable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'durable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smooth', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smooth' AND deleted = 0);

-- WAEC 2025 English - Item 8 - Question 8
SET @source_marker := 'WAEC 2025 English - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 8 - Question 8</small></p><p><strong>WAEC 2025 English - Question 8</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>If one thing <u>irritates</u> you, it might ______ another.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'delight', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'delight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'concern', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'concern' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'invigorate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'invigorate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bother', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bother' AND deleted = 0);

-- WAEC 2025 English - Item 9 - Question 9
SET @source_marker := 'WAEC 2025 English - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 9 - Question 9</small></p><p><strong>WAEC 2025 English - Question 9</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>Jane was <u>loud</u> as a teenager but ______ as an adult.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reserved', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reserved' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'peaceful', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'peaceful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'respectful', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'respectful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'humble', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'humble' AND deleted = 0);

-- WAEC 2025 English - Item 10 - Question 10
SET @source_marker := 'WAEC 2025 English - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 10 - Question 10</small></p><p><strong>WAEC 2025 English - Question 10</strong></p><p>Choose the option that is most nearly opposite in meaning to the underlined word and that will correctly fill the gap in the sentence.</p><p>Do not always <u>reprimand</u> your children; it is good to ______ them at times.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Antonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pamper', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'pamper' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'forgive', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'forgive' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'compliment', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'compliment' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'advise', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'advise' AND deleted = 0);

-- WAEC 2025 English - Item 11 - Question 11
SET @source_marker := 'WAEC 2025 English - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 11 - Question 11</small></p><p><strong>WAEC 2025 English - Question 11</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>The aggrieved customers staged a fierce ______ on the street.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contest', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'contest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'argument', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'argument' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fight', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protest', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'protest' AND deleted = 0);

-- WAEC 2025 English - Item 12 - Question 12
SET @source_marker := 'WAEC 2025 English - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 12 - Question 12</small></p><p><strong>WAEC 2025 English - Question 12</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>The accused was brought before the jury for a court ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'proceeding', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'proceeding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'judging', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'judging' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sitting', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sitting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hearing', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hearing' AND deleted = 0);

-- WAEC 2025 English - Item 13 - Question 13
SET @source_marker := 'WAEC 2025 English - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 13 - Question 13</small></p><p><strong>WAEC 2025 English - Question 13</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>From his ______, one can tell that he is an athlete.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'physique', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'physique' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gait', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gait' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stature', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'stature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'anatomy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'anatomy' AND deleted = 0);

-- WAEC 2025 English - Item 14 - Question 14
SET @source_marker := 'WAEC 2025 English - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 14 - Question 14</small></p><p><strong>WAEC 2025 English - Question 14</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>The death of that journalist is still ______ in mystery.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shadowed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shadowed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'conveyed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'conveyed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shrouded', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shrouded' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'confined', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'confined' AND deleted = 0);

-- WAEC 2025 English - Item 15 - Question 15
SET @source_marker := 'WAEC 2025 English - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 15 - Question 15</small></p><p><strong>WAEC 2025 English - Question 15</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>The defendant was charged with ______ because he caused his neighbour&#039;s death.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'patricide', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'patricide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'genocide', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'genocide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'homicide', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'homicide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fratricide', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fratricide' AND deleted = 0);

-- WAEC 2025 English - Item 16 - Question 16
SET @source_marker := 'WAEC 2025 English - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 16 - Question 16</small></p><p><strong>WAEC 2025 English - Question 16</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>Seeing a young crop ______ from the soil is a rare experience.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'creep', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'creep' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sprout', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sprout' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trail', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'trail' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'project', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'project' AND deleted = 0);

-- WAEC 2025 English - Item 17 - Question 17
SET @source_marker := 'WAEC 2025 English - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 17 - Question 17</small></p><p><strong>WAEC 2025 English - Question 17</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>Lawyers are still making efforts to interpret the new ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'system', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'system' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'language', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'language' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'statute', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'statute' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'technique', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'technique' AND deleted = 0);

-- WAEC 2025 English - Item 18 - Question 18
SET @source_marker := 'WAEC 2025 English - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 18 - Question 18</small></p><p><strong>WAEC 2025 English - Question 18</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>The cargo was intercepted on sea by ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pirates', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'pirates' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thieves', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'thieves' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'robbers', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'robbers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'terrorists', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'terrorists' AND deleted = 0);

-- WAEC 2025 English - Item 19 - Question 19
SET @source_marker := 'WAEC 2025 English - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 19 - Question 19</small></p><p><strong>WAEC 2025 English - Question 19</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>The doctors ______ Bola&#039;s grandmother after the heart attack.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'resuscitated', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'resuscitated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'regenerated', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'regenerated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'resurrected', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'resurrected' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'revivified', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'revivified' AND deleted = 0);

-- WAEC 2025 English - Item 20 - Question 20
SET @source_marker := 'WAEC 2025 English - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 20 - Question 20</small></p><p><strong>WAEC 2025 English - Question 20</strong></p><p>From the words lettered A to D, choose the word that best completes each of the following sentences.</p><p>Because the couple cannot agree on many things, their relationship is now ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tensed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tensed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stressed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'stressed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'uneasy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'uneasy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'strained', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'strained' AND deleted = 0);

-- WAEC 2025 English - Item 21 - Question 21
SET @source_marker := 'WAEC 2025 English - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 21 - Question 21</small></p><p><strong>WAEC 2025 English - Question 21</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>Revealing that information will cut the ground from under my feet. This means that it will</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'expose my plans.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'expose my plans.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ruin my plans.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ruin my plans.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'support my plans.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'support my plans.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'promote my plans.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'promote my plans.' AND deleted = 0);

-- WAEC 2025 English - Item 22 - Question 22
SET @source_marker := 'WAEC 2025 English - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 22 - Question 22</small></p><p><strong>WAEC 2025 English - Question 22</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>Mother always tells me to keep my nose clean. This means that she tells me to</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'be focused.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'be focused.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stay healthy.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'stay healthy.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stay out of trouble.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'stay out of trouble.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'do what pleases me.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'do what pleases me.' AND deleted = 0);

-- WAEC 2025 English - Item 23 - Question 23
SET @source_marker := 'WAEC 2025 English - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 23 - Question 23</small></p><p><strong>WAEC 2025 English - Question 23</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>This action effectively puts the mockers on the project. This means that the project</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'take off soon.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'take off soon.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'be delayed.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'be delayed.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'not be executed.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'not be executed.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'not begin well.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'not begin well.' AND deleted = 0);

-- WAEC 2025 English - Item 24 - Question 24
SET @source_marker := 'WAEC 2025 English - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 24 - Question 24</small></p><p><strong>WAEC 2025 English - Question 24</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>You can see clearly that we are surpassed in numerical strength. This means that we are</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'much weaker than they.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'much weaker than they.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'by far stronger than they.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'by far stronger than they.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fewer than they are.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fewer than they are.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'more than they are.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'more than they are.' AND deleted = 0);

-- WAEC 2025 English - Item 25 - Question 25
SET @source_marker := 'WAEC 2025 English - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 25 - Question 25</small></p><p><strong>WAEC 2025 English - Question 25</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>One of the athletes was disqualified because she jumped the gun. This means that she started</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hurriedly.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hurriedly.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'without permission.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'without permission.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'too soon.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'too soon.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'on time.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'on time.' AND deleted = 0);

-- WAEC 2025 English - Item 26 - Question 26
SET @source_marker := 'WAEC 2025 English - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 26 - Question 26</small></p><p><strong>WAEC 2025 English - Question 26</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>Be careful of what you say; there are no flies on the boss. This means that the boss is</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'strict', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'strict' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smart', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smart' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gullible', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gullible' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neat', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'neat' AND deleted = 0);

-- WAEC 2025 English - Item 27 - Question 27
SET @source_marker := 'WAEC 2025 English - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 27 - Question 27</small></p><p><strong>WAEC 2025 English - Question 27</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>The students cocked their ears at the principal&#039;s speech. This means that they listened with</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'no understanding', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'no understanding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'no interest', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'no interest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'little interest', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'little interest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rapt attention', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rapt attention' AND deleted = 0);

-- WAEC 2025 English - Item 28 - Question 28
SET @source_marker := 'WAEC 2025 English - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 28 - Question 28</small></p><p><strong>WAEC 2025 English - Question 28</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>Your daughter will do very well in school. She has a good head on her shoulders. This means that she</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is very beautiful', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'is very beautiful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is well-behaved and diligent', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'is well-behaved and diligent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is sensible', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'is sensible' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thinks fast', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'thinks fast' AND deleted = 0);

-- WAEC 2025 English - Item 29 - Question 29
SET @source_marker := 'WAEC 2025 English - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 29 - Question 29</small></p><p><strong>WAEC 2025 English - Question 29</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>The accountant has been under a cloud since the fraud scandal. This means that the accountant is</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unhappy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unhappy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'worried', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'worried' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'under suspicion', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'under suspicion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'under supervision', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'under supervision' AND deleted = 0);

-- WAEC 2025 English - Item 30 - Question 30
SET @source_marker := 'WAEC 2025 English - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 30 - Question 30</small></p><p><strong>WAEC 2025 English - Question 30</strong></p><p>After each of the following sentences, a list of possible interpretations is given. Choose the interpretation that is most appropriate for each sentence.</p><p>Immediately the truth was revealed, Ngozi flew into a rage. This means that Ngozi</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'English Language', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ran away', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ran away' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'became sad', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'became sad' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'became desperate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'became desperate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'suddenly became very angry', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'suddenly became very angry' AND deleted = 0);

-- WAEC 2025 English - Item 31 - Question 31
SET @source_marker := 'WAEC 2025 English - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 31 - Question 31</small></p><p><strong>WAEC 2025 English - Question 31</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>Parents encourage their children to exercise financial <u>prudence</u>.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'credence', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'credence' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sincerity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sincerity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'precision', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'precision' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'caution', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'caution' AND deleted = 0);

-- WAEC 2025 English - Item 32 - Question 32
SET @source_marker := 'WAEC 2025 English - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 32 - Question 32</small></p><p><strong>WAEC 2025 English - Question 32</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>Awa <u>deceived</u> Ahmed into handing over all his savings.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cooked', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cooked' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'betrayed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'betrayed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cheated', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cheated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fooled', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fooled' AND deleted = 0);

-- WAEC 2025 English - Item 33 - Question 33
SET @source_marker := 'WAEC 2025 English - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 33 - Question 33</small></p><p><strong>WAEC 2025 English - Question 33</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>It turned out that the plaintiff&#039;s <u>claim</u> was false.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contention', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'contention' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'allegation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'allegation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'surmise', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'surmise' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pronouncement', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'pronouncement' AND deleted = 0);

-- WAEC 2025 English - Item 34 - Question 34
SET @source_marker := 'WAEC 2025 English - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 34 - Question 34</small></p><p><strong>WAEC 2025 English - Question 34</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>The aggrieved faction held a <u>clandestine</u> meeting.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quiet', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'quiet' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'brief', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'brief' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'secret', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'secret' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quick', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'quick' AND deleted = 0);

-- WAEC 2025 English - Item 35 - Question 35
SET @source_marker := 'WAEC 2025 English - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 35 - Question 35</small></p><p><strong>WAEC 2025 English - Question 35</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>Morgan Pharmacy is the <u>sole</u> distributor of the antiviral drug.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'creditable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'creditable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'only', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'first', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'first' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'major', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'major' AND deleted = 0);

-- WAEC 2025 English - Item 36 - Question 36
SET @source_marker := 'WAEC 2025 English - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 36 - Question 36</small></p><p><strong>WAEC 2025 English - Question 36</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>Police officers holding batons <u>impounded</u> the banker&#039;s car.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'collected', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'collected' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'banned', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'banned' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seized', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seized' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'damaged', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'damaged' AND deleted = 0);

-- WAEC 2025 English - Item 37 - Question 37
SET @source_marker := 'WAEC 2025 English - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 37 - Question 37</small></p><p><strong>WAEC 2025 English - Question 37</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>The English teacher is always <u>cheerful</u>.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'zealous', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'zealous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'satisfied', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'satisfied' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'careful', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'careful' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gleeful', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gleeful' AND deleted = 0);

-- WAEC 2025 English - Item 38 - Question 38
SET @source_marker := 'WAEC 2025 English - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 38 - Question 38</small></p><p><strong>WAEC 2025 English - Question 38</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>The Chairman is of the opinion that laying off workers is <u>pernicious</u> to the growth of the company.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'indispensable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'indispensable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'irrelevant', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'irrelevant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'crucial', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'crucial' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'harmful', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'harmful' AND deleted = 0);

-- WAEC 2025 English - Item 39 - Question 39
SET @source_marker := 'WAEC 2025 English - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 39 - Question 39</small></p><p><strong>WAEC 2025 English - Question 39</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>It was she that <u>commanded</u> me to leave the room.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'persuaded', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'persuaded' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ordered', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ordered' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'induced', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'induced' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'encouraged', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'encouraged' AND deleted = 0);

-- WAEC 2025 English - Item 40 - Question 40
SET @source_marker := 'WAEC 2025 English - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 40 - Question 40</small></p><p><strong>WAEC 2025 English - Question 40</strong></p><p>From the words lettered A to D below each of the following sentences, choose the word or group of words that is nearest in meaning to the underlined word as it is used in the sentence.</p><p>The valedictorian was admired for her <u>perseverance</u> while at school.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Synonyms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tenacity', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tenacity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enthusiasm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'enthusiasm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'patience', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'patience' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'humility', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'humility' AND deleted = 0);

-- WAEC 2025 English - Item 41 - Question 41
SET @source_marker := 'WAEC 2025 English - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 41 - Question 41</small></p><p><strong>WAEC 2025 English - Question 41</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The fisherman said he sighted a ______ of fish in the river.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'colony', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'colony' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'swarm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'swarm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pack', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'pack' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shoal', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shoal' AND deleted = 0);

-- WAEC 2025 English - Item 42 - Question 42
SET @source_marker := 'WAEC 2025 English - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 42 - Question 42</small></p><p><strong>WAEC 2025 English - Question 42</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The principal corrected no one else but ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'She', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'She' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Me', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Me' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Myself', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Myself' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'I' AND deleted = 0);

-- WAEC 2025 English - Item 43 - Question 43
SET @source_marker := 'WAEC 2025 English - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 43 - Question 43</small></p><p><strong>WAEC 2025 English - Question 43</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The thug was ______ murder.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'charged with', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'charged with' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sued with', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sued with' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'convicted for', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'convicted for' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'charged for', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'charged for' AND deleted = 0);

-- WAEC 2025 English - Item 44 - Question 44
SET @source_marker := 'WAEC 2025 English - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 44 - Question 44</small></p><p><strong>WAEC 2025 English - Question 44</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>Asokoro office ______ is located in Ibadan.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'headquarter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'headquarter' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'headquarters', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'headquarters' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'headquarters&#039;', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'headquarters&#039;' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'headquarter&#039;s', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'headquarter&#039;s' AND deleted = 0);

-- WAEC 2025 English - Item 45 - Question 45
SET @source_marker := 'WAEC 2025 English - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 45 - Question 45</small></p><p><strong>WAEC 2025 English - Question 45</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>John should be through with his work, ______?</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shouldn&#039;t he', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shouldn&#039;t he' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'can&#039;t he', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'can&#039;t he' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'isn&#039;t it', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'isn&#039;t it' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'didn&#039;t he', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'didn&#039;t he' AND deleted = 0);

-- WAEC 2025 English - Item 46 - Question 46
SET @source_marker := 'WAEC 2025 English - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 46 - Question 46</small></p><p><strong>WAEC 2025 English - Question 46</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>This is the man ______ I said told me the interesting story.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whom', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whom' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'who', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'who' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whose', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whose' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'which', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'which' AND deleted = 0);

-- WAEC 2025 English - Item 47 - Question 47
SET @source_marker := 'WAEC 2025 English - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 47 - Question 47</small></p><p><strong>WAEC 2025 English - Question 47</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The accused forgot ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'what the police said', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'what the police said' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'why the police said', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'why the police said' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'that the police said', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'that the police said' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'when the police said', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'when the police said' AND deleted = 0);

-- WAEC 2025 English - Item 48 - Question 48
SET @source_marker := 'WAEC 2025 English - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 48 - Question 48</small></p><p><strong>WAEC 2025 English - Question 48</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The officer ______ is my brother.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'in uniform', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'in uniform' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'in uniform dress', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'in uniform dress' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'with uniform', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'with uniform' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'on uniform', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'on uniform' AND deleted = 0);

-- WAEC 2025 English - Item 49 - Question 49
SET @source_marker := 'WAEC 2025 English - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 49 - Question 49</small></p><p><strong>WAEC 2025 English - Question 49</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The footballers have been practising ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hard in the stadium all morning', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hard in the stadium all morning' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'all morning hard in the stadium', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'all morning hard in the stadium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'all morning in the stadium hard', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'all morning in the stadium hard' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'in the stadium hard all morning', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'in the stadium hard all morning' AND deleted = 0);

-- WAEC 2025 English - Item 50 - Question 50
SET @source_marker := 'WAEC 2025 English - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 50 - Question 50</small></p><p><strong>WAEC 2025 English - Question 50</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>Professor John is the leader of the ______ committee to review the new book.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fifty-man', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fifty-man' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fifty-men', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fifty-men' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fifty-men&#039;s', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fifty-men&#039;s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fifty-man&#039;s', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fifty-man&#039;s' AND deleted = 0);

-- WAEC 2025 English - Item 51 - Question 51
SET @source_marker := 'WAEC 2025 English - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 51 - Question 51</small></p><p><strong>WAEC 2025 English - Question 51</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>James appears ______ wiser than his friends.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'much more', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'much more' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'more', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'more' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'most', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'most' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'much', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'much' AND deleted = 0);

-- WAEC 2025 English - Item 52 - Question 52
SET @source_marker := 'WAEC 2025 English - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 52 - Question 52</small></p><p><strong>WAEC 2025 English - Question 52</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>That world famous athlete is guilty ______ way you look at it.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whatever', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whatever' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whenever', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whenever' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whichever', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whichever' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'however', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'however' AND deleted = 0);

-- WAEC 2025 English - Item 53 - Question 53
SET @source_marker := 'WAEC 2025 English - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 53 - Question 53</small></p><p><strong>WAEC 2025 English - Question 53</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>We were all afraid when the alarm ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'went off', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'went off' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'died off', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'died off' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rang up', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rang up' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ran off', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ran off' AND deleted = 0);

-- WAEC 2025 English - Item 54 - Question 54
SET @source_marker := 'WAEC 2025 English - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 54 - Question 54</small></p><p><strong>WAEC 2025 English - Question 54</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The material used for sewing my dress is ______ to yours.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'more superior', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'more superior' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'very superior', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'very superior' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'superior', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'superior' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'most superior', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'most superior' AND deleted = 0);

-- WAEC 2025 English - Item 55 - Question 55
SET @source_marker := 'WAEC 2025 English - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 55 - Question 55</small></p><p><strong>WAEC 2025 English - Question 55</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>We were lucky our driver didn&#039;t die in the accident, ______?</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'weren&#039;t we', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'weren&#039;t we' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'didn&#039;t we', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'didn&#039;t we' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'isn&#039;t it', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'isn&#039;t it' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'did we', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'did we' AND deleted = 0);

-- WAEC 2025 English - Item 56 - Question 56
SET @source_marker := 'WAEC 2025 English - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 56 - Question 56</small></p><p><strong>WAEC 2025 English - Question 56</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The ______ were decorated with flowers.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'girls&#039; shoes', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'girls&#039; shoes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'girls shoes&#039;', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'girls shoes&#039;' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'girls&#039; shoes&#039;', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'girls&#039; shoes&#039;' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'girls shoes', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'girls shoes' AND deleted = 0);

-- WAEC 2025 English - Item 57 - Question 57
SET @source_marker := 'WAEC 2025 English - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 57 - Question 57</small></p><p><strong>WAEC 2025 English - Question 57</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>Before the lecturer entered the hall, we ______ the board.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'are cleaning', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'are cleaning' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have cleaned', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'have cleaned' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'clean', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'clean' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'had cleaned', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'had cleaned' AND deleted = 0);

-- WAEC 2025 English - Item 58 - Question 58
SET @source_marker := 'WAEC 2025 English - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 58 - Question 58</small></p><p><strong>WAEC 2025 English - Question 58</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>______ the hours of nine and ten, the surgeons completed the operation.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'In', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'In' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Between', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Between' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Upon', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Upon' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Before', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Before' AND deleted = 0);

-- WAEC 2025 English - Item 59 - Question 59
SET @source_marker := 'WAEC 2025 English - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 59 - Question 59</small></p><p><strong>WAEC 2025 English - Question 59</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>Mother bought ______ at the fair.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an expensive Japanese red car', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'an expensive Japanese red car' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an expensive red Japanese car', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'an expensive red Japanese car' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a red expensive Japanese car', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'a red expensive Japanese car' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a Japanese red expensive car', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'a Japanese red expensive car' AND deleted = 0);

-- WAEC 2025 English - Item 60 - Question 60
SET @source_marker := 'WAEC 2025 English - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 60 - Question 60</small></p><p><strong>WAEC 2025 English - Question 60</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The duty of our teacher is to give instructions; ______ is to obey.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'our', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'our' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ours&#039;', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ours&#039;' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'our&#039;s', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'our&#039;s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ours', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ours' AND deleted = 0);

-- WAEC 2025 English - Item 61 - Question 61
SET @source_marker := 'WAEC 2025 English - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 61 - Question 61</small></p><p><strong>WAEC 2025 English - Question 61</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The teacher has ______ with the principal.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fallen down', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fallen down' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fallen of', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fallen of' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fallen apart', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fallen apart' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fallen out', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fallen out' AND deleted = 0);

-- WAEC 2025 English - Item 62 - Question 62
SET @source_marker := 'WAEC 2025 English - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 62 - Question 62</small></p><p><strong>WAEC 2025 English - Question 62</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>A meeting was called ______ the instance of the chairman.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'on', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'on' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'by', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'by' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'at', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'at' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'for', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'for' AND deleted = 0);

-- WAEC 2025 English - Item 63 - Question 63
SET @source_marker := 'WAEC 2025 English - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 63 - Question 63</small></p><p><strong>WAEC 2025 English - Question 63</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>Business is poor these days ______ workers are on strike.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'because', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'because' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'so that', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'so that' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'whereas', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'whereas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'no matter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'no matter' AND deleted = 0);

-- WAEC 2025 English - Item 64 - Question 64
SET @source_marker := 'WAEC 2025 English - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 64 - Question 64</small></p><p><strong>WAEC 2025 English - Question 64</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The test seemed ______ simple that we thought we would all pass.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'very', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'very' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'so', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'so' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'too', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'too' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'over', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'over' AND deleted = 0);

-- WAEC 2025 English - Item 65 - Question 65
SET @source_marker := 'WAEC 2025 English - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 65 - Question 65</small></p><p><strong>WAEC 2025 English - Question 65</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p><strong>Tayo:</strong> I think I can now solve the problem.</p><p><strong>Essien:</strong> ______</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'So do I', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'So do I' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'So I can', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'So I can' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Either do I', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Either do I' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Neither can I', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Neither can I' AND deleted = 0);

-- WAEC 2025 English - Item 66 - Question 66
SET @source_marker := 'WAEC 2025 English - Item 66 - Question 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 66 - Question 66</small></p><p><strong>WAEC 2025 English - Question 66</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The ______ scientist has discovered a cure for cancer.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'young Nigerian brilliant', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'young Nigerian brilliant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'brilliant young Nigerian', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'brilliant young Nigerian' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'young brilliant Nigerian', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'young brilliant Nigerian' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nigerian brilliant young', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Nigerian brilliant young' AND deleted = 0);

-- WAEC 2025 English - Item 67 - Question 67
SET @source_marker := 'WAEC 2025 English - Item 67 - Question 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 67 - Question 67</small></p><p><strong>WAEC 2025 English - Question 67</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The couple ______ their first child when I entered college.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'haven&#039;t had', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'haven&#039;t had' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hadn&#039;t had', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hadn&#039;t had' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hasn&#039;t had', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hasn&#039;t had' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'were not having', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'were not having' AND deleted = 0);

-- WAEC 2025 English - Item 68 - Question 68
SET @source_marker := 'WAEC 2025 English - Item 68 - Question 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 68 - Question 68</small></p><p><strong>WAEC 2025 English - Question 68</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>The fire fighters worked hard to ______ the inferno.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'put off', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'put off' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'put away', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'put away' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'put by', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'put by' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'put out', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'put out' AND deleted = 0);

-- WAEC 2025 English - Item 69 - Question 69
SET @source_marker := 'WAEC 2025 English - Item 69 - Question 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 69 - Question 69</small></p><p><strong>WAEC 2025 English - Question 69</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes each of the following sentences.</p><p>Those novels are interesting. I wonder if you can get me ______.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'others such many', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'others such many' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'many such others', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'many such others' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'many others such', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'many others such' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'such many others', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'such many others' AND deleted = 0);

-- WAEC 2025 English - Item 70 - Question 71
SET @source_marker := 'WAEC 2025 English - Item 70 - Question 71';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 70 - Question 71</small></p><p><strong>WAEC 2025 English - Question 71</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>Jim had his first ______ in professional boxing when he was seventeen and that match has remained indelible in his memory.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'session', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'session' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'attempt', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'attempt' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'entry', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'entry' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bout', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bout' AND deleted = 0);

-- WAEC 2025 English - Item 71 - Question 72
SET @source_marker := 'WAEC 2025 English - Item 71 - Question 72';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 71 - Question 72</small></p><p><strong>WAEC 2025 English - Question 72</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>Jim came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands. Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'stage' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cage' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'podium', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'podium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ring', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ring' AND deleted = 0);

-- WAEC 2025 English - Item 72 - Question 73
SET @source_marker := 'WAEC 2025 English - Item 72 - Question 73';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 72 - Question 73</small></p><p><strong>WAEC 2025 English - Question 73</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>Jim came into the ring amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands. Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'referee', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'referee' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'starter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'starter' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'umpire', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'umpire' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'announcer', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'announcer' AND deleted = 0);

-- WAEC 2025 English - Item 73 - Question 74
SET @source_marker := 'WAEC 2025 English - Item 73 - Question 74';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 73 - Question 74</small></p><p><strong>WAEC 2025 English - Question 74</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>Jim came into the ring amidst loud cheers from the spectators after he had been called by the announcer. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands. Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'parachute', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'parachute' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'braces', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'braces' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'kid&#039;s gloves', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'kid&#039;s gloves' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'boxing gloves', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'boxing gloves' AND deleted = 0);

-- WAEC 2025 English - Item 74 - Question 75
SET @source_marker := 'WAEC 2025 English - Item 74 - Question 75';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 74 - Question 75</small></p><p><strong>WAEC 2025 English - Question 75</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>Jim came into the ring amidst loud cheers from the spectators after he had been called by the announcer. He was wearing customized trunks and boxing gloves to prevent damage to his hands. Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sparring partner', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sparring partner' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fighting partner', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fighting partner' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contestant', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'contestant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'opponent', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'opponent' AND deleted = 0);

-- WAEC 2025 English - Item 75 - Question 76
SET @source_marker := 'WAEC 2025 English - Item 75 - Question 76';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 75 - Question 76</small></p><p><strong>WAEC 2025 English - Question 76</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>Jim came into the ring amidst loud cheers from the spectators after he had been called by the announcer. He was wearing customized trunks and boxing gloves to prevent damage to his hands. Jim and his opponent moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hook', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hook' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'knock', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'knock' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smack', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smack' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'kick', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'kick' AND deleted = 0);

-- WAEC 2025 English - Item 76 - Question 77
SET @source_marker := 'WAEC 2025 English - Item 76 - Question 77';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 76 - Question 77</small></p><p><strong>WAEC 2025 English - Question 77</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hands', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hands' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'palms', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'palms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'elbow', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'elbow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fists', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fists' AND deleted = 0);

-- WAEC 2025 English - Item 77 - Question 78
SET @source_marker := 'WAEC 2025 English - Item 77 - Question 78';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 77 - Question 78</small></p><p><strong>WAEC 2025 English - Question 78</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>After this attack from his rival, Jim raised his arms and held his fists in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'defending', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'defending' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dodging', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dodging' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dubbing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dubbing' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'parrying', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'parrying' AND deleted = 0);

-- WAEC 2025 English - Item 78 - Question 79
SET @source_marker := 'WAEC 2025 English - Item 78 - Question 79';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 78 - Question 79</small></p><p><strong>WAEC 2025 English - Question 79</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'round', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'round' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lap', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'lap' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'turn', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'turn' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'leg', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'leg' AND deleted = 0);

-- WAEC 2025 English - Item 79 - Question 80
SET @source_marker := 'WAEC 2025 English - Item 79 - Question 80';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 79 - Question 80</small></p><p><strong>WAEC 2025 English - Question 80</strong></p><p><strong>Shared Passage For Questions 71-80</strong></p><p>In the following passage, the numbered gaps indicate missing words. Against each number in the list below the passage, options are given. Choose the word that is most suitable to fill the numbered gaps in the passage.</p><p><strong>Passage</strong></p><p>Jim had his first <strong>-71-</strong> in professional boxing when he was seventeen and that match has remained indelible in his memory. Before the match, he had gone for a weigh-in along with other boxers. On the D-day, he came into the <strong>-72-</strong> amidst loud cheers from the spectators after he had been called by the <strong>-73-</strong>. He was wearing customized trunks and <strong>-74-</strong> to prevent damage to his hands.</p><p>Jim and his <strong>-75-</strong> moved round throwing punches at each other. Jim threw a right <strong>-76-</strong>, left himself open and got cut by a strong counter punch. After this attack from his rival, Jim raised his arms and held his <strong>-77-</strong> in front of his face to protect himself by <strong>-78-</strong> the punches as they came.</p><p>During the second <strong>-79-</strong>, Jim delivered a sucker punch which got his opponent in the ribs leading to loss of consciousness. Consequently, Jim won the game by <strong>-80-</strong>.</p><p>Consequently, Jim won the game by <strong>-80-</strong>.</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Cloze Passage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'luck', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'luck' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'knockout', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'knockout' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'default', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'default' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unanimity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unanimity' AND deleted = 0);

-- WAEC 2025 English - Item 80 - Question 81
SET @source_marker := 'WAEC 2025 English - Item 80 - Question 81';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 80 - Question 81</small></p><p><strong>WAEC 2025 English - Question 81</strong></p><p>From the words or group of words lettered A to D, choose the word or group of words that best completes the following sentence.</p><p>We were lucky our driver didn&#039;t die in the accident, ..........?</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Sentence Completion', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'weren&#039;t we', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'weren&#039;t we' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'didn&#039;t we', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'didn&#039;t we' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'isn&#039;t it', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'isn&#039;t it' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'did we', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'did we' AND deleted = 0);

-- WAEC 2025 English - Item 81 - Question 81
SET @source_marker := 'WAEC 2025 English - Item 81 - Question 81';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 81 - Question 81</small></p><p><strong>WAEC 2025 English - Question 81</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>M<u>o</u>ney</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'port', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'port' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'son', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'son' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'coney', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'coney' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bottle', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bottle' AND deleted = 0);

-- WAEC 2025 English - Item 82 - Question 82
SET @source_marker := 'WAEC 2025 English - Item 82 - Question 82';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 82 - Question 82</small></p><p><strong>WAEC 2025 English - Question 82</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>p<u>our</u></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hour', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'how', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'how' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'favour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ore', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ore' AND deleted = 0);

-- WAEC 2025 English - Item 83 - Question 83
SET @source_marker := 'WAEC 2025 English - Item 83 - Question 83';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 83 - Question 83</small></p><p><strong>WAEC 2025 English - Question 83</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>t<u>ie</u></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hey', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hey' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'farce', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'farce' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hail', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hail' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bile', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bile' AND deleted = 0);

-- WAEC 2025 English - Item 84 - Question 84
SET @source_marker := 'WAEC 2025 English - Item 84 - Question 84';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 84 - Question 84</small></p><p><strong>WAEC 2025 English - Question 84</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>p<u>u</u>t</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fool', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fool' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'school', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'school' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wool', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wool' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cool', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cool' AND deleted = 0);

-- WAEC 2025 English - Item 85 - Question 85
SET @source_marker := 'WAEC 2025 English - Item 85 - Question 85';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 85 - Question 85</small></p><p><strong>WAEC 2025 English - Question 85</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>t<u>ai</u>lor</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'torn', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'torn' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dent', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'orchard', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'orchard' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'partake', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'partake' AND deleted = 0);

-- WAEC 2025 English - Item 86 - Question 86
SET @source_marker := 'WAEC 2025 English - Item 86 - Question 86';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 86 - Question 86</small></p><p><strong>WAEC 2025 English - Question 86</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>f<u>a</u>te</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'share', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'share' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'flat', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'flat' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'said', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'said' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'weight', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'weight' AND deleted = 0);

-- WAEC 2025 English - Item 87 - Question 87
SET @source_marker := 'WAEC 2025 English - Item 87 - Question 87';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 87 - Question 87</small></p><p><strong>WAEC 2025 English - Question 87</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>f<u>er</u>n</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'heart', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'heart' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'merge', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'merge' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'eureka', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'eureka' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'beryl', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'beryl' AND deleted = 0);

-- WAEC 2025 English - Item 88 - Question 88
SET @source_marker := 'WAEC 2025 English - Item 88 - Question 88';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 88 - Question 88</small></p><p><strong>WAEC 2025 English - Question 88</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>p<u>ow</u>der</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'potty', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'potty' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lout', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'lout' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tour', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'low', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'low' AND deleted = 0);

-- WAEC 2025 English - Item 89 - Question 89
SET @source_marker := 'WAEC 2025 English - Item 89 - Question 89';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 89 - Question 89</small></p><p><strong>WAEC 2025 English - Question 89</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>cr<u>ui</u>se</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quite', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'quite' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hood', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hood' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'move', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'move' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'suite', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'suite' AND deleted = 0);

-- WAEC 2025 English - Item 90 - Question 90
SET @source_marker := 'WAEC 2025 English - Item 90 - Question 90';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 90 - Question 90</small></p><p><strong>WAEC 2025 English - Question 90</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>p<u>ure</u></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'favour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'schwa', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'schwa' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'furore', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'furore' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fur', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fur' AND deleted = 0);

-- WAEC 2025 English - Item 91 - Question 91
SET @source_marker := 'WAEC 2025 English - Item 91 - Question 91';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 91 - Question 91</small></p><p><strong>WAEC 2025 English - Question 91</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>sp<u>o</u>t</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sport', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sport' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'glut', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'glut' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'slot', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'slot' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hurt', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hurt' AND deleted = 0);

-- WAEC 2025 English - Item 92 - Question 92
SET @source_marker := 'WAEC 2025 English - Item 92 - Question 92';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 92 - Question 92</small></p><p><strong>WAEC 2025 English - Question 92</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>th<u>ere</u></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'their', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'their' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ear', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ear' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fear', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fear' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'peer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'peer' AND deleted = 0);

-- WAEC 2025 English - Item 93 - Question 93
SET @source_marker := 'WAEC 2025 English - Item 93 - Question 93';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 93 - Question 93</small></p><p><strong>WAEC 2025 English - Question 93</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>cr<u>e</u>st</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'goitre', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'goitre' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'breakfast', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'breakfast' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'firm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'firm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wheat', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wheat' AND deleted = 0);

-- WAEC 2025 English - Item 94 - Question 94
SET @source_marker := 'WAEC 2025 English - Item 94 - Question 94';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 94 - Question 94</small></p><p><strong>WAEC 2025 English - Question 94</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>sh<u>ea</u>th</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'meadow', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'meadow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'beach', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'beach' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'weather', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'weather' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'heart', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'heart' AND deleted = 0);

-- WAEC 2025 English - Item 95 - Question 95
SET @source_marker := 'WAEC 2025 English - Item 95 - Question 95';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 95 - Question 95</small></p><p><strong>WAEC 2025 English - Question 95</strong></p><p>From the words lettered A to D, choose the word that has the same vowel sound as the one represented by the underlined letter(s).</p><p>g<u>o</u>rilla</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Vowel Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tot', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tot' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'colour', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'colour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ordain', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ordain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'doe', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'doe' AND deleted = 0);

-- WAEC 2025 English - Item 96 - Question 96
SET @source_marker := 'WAEC 2025 English - Item 96 - Question 96';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 96 - Question 96</small></p><p><strong>WAEC 2025 English - Question 96</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound(s) as the one represented by the letter(s) underlined.</p><p>Or<u>ch</u>id</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sceptre', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sceptre' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'skewer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'skewer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sham', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sham' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chagrin', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'chagrin' AND deleted = 0);

-- WAEC 2025 English - Item 97 - Question 97
SET @source_marker := 'WAEC 2025 English - Item 97 - Question 97';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 97 - Question 97</small></p><p><strong>WAEC 2025 English - Question 97</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound(s) as the one represented by the letter(s) underlined.</p><p>pic<u>t</u>ure</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'passion', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'passion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'castor', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'castor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'nation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lurch', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'lurch' AND deleted = 0);

-- WAEC 2025 English - Item 98 - Question 98
SET @source_marker := 'WAEC 2025 English - Item 98 - Question 98';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 98 - Question 98</small></p><p><strong>WAEC 2025 English - Question 98</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound(s) as the one represented by the letter(s) underlined.</p><p>fi<u>ss</u>ure</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'erase', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'erase' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'vision', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'vision' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unsure', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'unsure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'feature', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'feature' AND deleted = 0);

-- WAEC 2025 English - Item 99 - Question 99
SET @source_marker := 'WAEC 2025 English - Item 99 - Question 99';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 99 - Question 99</small></p><p><strong>WAEC 2025 English - Question 99</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound(s) as the one represented by the letter(s) underlined.</p><p>vi<u>s</u>it</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'easy', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'easy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'peace', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'peace' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'face', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'face' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mouse', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'mouse' AND deleted = 0);

-- WAEC 2025 English - Item 100 - Question 100
SET @source_marker := 'WAEC 2025 English - Item 100 - Question 100';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 100 - Question 100</small></p><p><strong>WAEC 2025 English - Question 100</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound(s) as the one represented by the letter(s) underlined.</p><p><u>h</u>ack</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'schedule', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'schedule' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'behaviour', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'behaviour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'honourable', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'honourable' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exhibit', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'exhibit' AND deleted = 0);

-- WAEC 2025 English - Item 101 - Question 101
SET @source_marker := 'WAEC 2025 English - Item 101 - Question 101';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 101 - Question 101</small></p><p><strong>WAEC 2025 English - Question 101</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letter.</p><p><u>l</u>eft</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'half', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'half' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'could', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'could' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'yolk', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'yolk' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bulk', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bulk' AND deleted = 0);

-- WAEC 2025 English - Item 102 - Question 102
SET @source_marker := 'WAEC 2025 English - Item 102 - Question 102';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 102 - Question 102</small></p><p><strong>WAEC 2025 English - Question 102</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letter.</p><p><u>f</u>ly</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tough', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tough' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'though', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'though' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dough', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dough' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'revive', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'revive' AND deleted = 0);

-- WAEC 2025 English - Item 103 - Question 103
SET @source_marker := 'WAEC 2025 English - Item 103 - Question 103';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 103 - Question 103</small></p><p><strong>WAEC 2025 English - Question 103</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound(s) as the one represented by the underlined letters.</p><p>te<u>xt</u></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'kissed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'kissed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'west', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'west' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fixed', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fixed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'risked', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'risked' AND deleted = 0);

-- WAEC 2025 English - Item 104 - Question 104
SET @source_marker := 'WAEC 2025 English - Item 104 - Question 104';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 104 - Question 104</small></p><p><strong>WAEC 2025 English - Question 104</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letter.</p><p>u<u>n</u>cle</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'singe', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'singe' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'knuckle', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'knuckle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bangle', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bangle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ankle', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ankle' AND deleted = 0);

-- WAEC 2025 English - Item 105 - Question 105
SET @source_marker := 'WAEC 2025 English - Item 105 - Question 105';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 105 - Question 105</small></p><p><strong>WAEC 2025 English - Question 105</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letter.</p><p><u>d</u>rive</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wounded', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wounded' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'kicked', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'kicked' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'jumped', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'jumped' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'risked', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'risked' AND deleted = 0);

-- WAEC 2025 English - Item 106 - Question 106
SET @source_marker := 'WAEC 2025 English - Item 106 - Question 106';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 106 - Question 106</small></p><p><strong>WAEC 2025 English - Question 106</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letter.</p><p>la<u>b</u>oratory</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thumb', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'thumb' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'subtle', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'subtle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'debtor', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'debtor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dabble', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dabble' AND deleted = 0);

-- WAEC 2025 English - Item 107 - Question 107
SET @source_marker := 'WAEC 2025 English - Item 107 - Question 107';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 107 - Question 107</small></p><p><strong>WAEC 2025 English - Question 107</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letters.</p><p>u<u>ph</u>olstery</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'phonetics', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'phonetics' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'upheaval', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'upheaval' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reception', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reception' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rehearsal', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rehearsal' AND deleted = 0);

-- WAEC 2025 English - Item 108 - Question 108
SET @source_marker := 'WAEC 2025 English - Item 108 - Question 108';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 108 - Question 108</small></p><p><strong>WAEC 2025 English - Question 108</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letters.</p><p>rou<u>ge</u></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'leisure', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'leisure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'jest', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'jest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gem', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rage' AND deleted = 0);

-- WAEC 2025 English - Item 109 - Question 109
SET @source_marker := 'WAEC 2025 English - Item 109 - Question 109';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 109 - Question 109</small></p><p><strong>WAEC 2025 English - Question 109</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letters.</p><p><u>th</u>en</p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wealthy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wealthy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smooth', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smooth' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'den', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'den' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thaw', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'thaw' AND deleted = 0);

-- WAEC 2025 English - Item 110 - Question 110
SET @source_marker := 'WAEC 2025 English - Item 110 - Question 110';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 110 - Question 110</small></p><p><strong>WAEC 2025 English - Question 110</strong></p><p>From the words lettered A to D, choose the word that has the same consonant sound as the one represented by the underlined letters.</p><p>si<u>gn</u></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Consonant Sounds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hymn', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hymn' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'single', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'single' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fawn', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fawn' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'thing' AND deleted = 0);

-- WAEC 2025 English - Item 111 - Question 111
SET @source_marker := 'WAEC 2025 English - Item 111 - Question 111';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 111 - Question 111</small></p><p><strong>WAEC 2025 English - Question 111</strong></p><p>From the words lettered A to D, choose the word that rhymes with the given word.</p><p><strong>fright</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Rhymes', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'freight', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'freight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'plait', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'plait' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'height', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'height' AND deleted = 0);

-- WAEC 2025 English - Item 112 - Question 112
SET @source_marker := 'WAEC 2025 English - Item 112 - Question 112';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 112 - Question 112</small></p><p><strong>WAEC 2025 English - Question 112</strong></p><p>From the words lettered A to D, choose the word that rhymes with the given word.</p><p><strong>tie</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Rhymes', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hay', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hay' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'high', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'high' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'claim', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'claim' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dim', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'dim' AND deleted = 0);

-- WAEC 2025 English - Item 113 - Question 113
SET @source_marker := 'WAEC 2025 English - Item 113 - Question 113';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 113 - Question 113</small></p><p><strong>WAEC 2025 English - Question 113</strong></p><p>From the words lettered A to D, choose the word that rhymes with the given word.</p><p><strong>tern</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Rhymes', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'born', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'born' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'earn', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'earn' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fan', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fan' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'birth', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'birth' AND deleted = 0);

-- WAEC 2025 English - Item 114 - Question 114
SET @source_marker := 'WAEC 2025 English - Item 114 - Question 114';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 114 - Question 114</small></p><p><strong>WAEC 2025 English - Question 114</strong></p><p>From the words lettered A to D, choose the word that rhymes with the given word.</p><p><strong>fear</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Rhymes', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wore', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wore' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'there', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'there' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deer', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'deer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'care', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'care' AND deleted = 0);

-- WAEC 2025 English - Item 115 - Question 115
SET @source_marker := 'WAEC 2025 English - Item 115 - Question 115';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 115 - Question 115</small></p><p><strong>WAEC 2025 English - Question 115</strong></p><p>From the words lettered A to D, choose the word that rhymes with the given word.</p><p><strong>mother</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Rhymes', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'other', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'other' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smoothen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smoothen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'smoulder', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'smoulder' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'murder', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'murder' AND deleted = 0);

-- WAEC 2025 English - Item 116 - Question 116
SET @source_marker := 'WAEC 2025 English - Item 116 - Question 116';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 116 - Question 116</small></p><p><strong>WAEC 2025 English - Question 116</strong></p><p>From the words lettered A to D, choose the one that has the correct stress.</p><p><strong>cumulative</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cu-<strong>MU</strong>-la-tive', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cu-<strong>MU</strong>-la-tive' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<strong>CU</strong>-mu-la-tive', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '<strong>CU</strong>-mu-la-tive' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cu-mu-<strong>LA</strong>-tive', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cu-mu-<strong>LA</strong>-tive' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cu-mu-la-<strong>TIVE</strong>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cu-mu-la-<strong>TIVE</strong>' AND deleted = 0);

-- WAEC 2025 English - Item 117 - Question 117
SET @source_marker := 'WAEC 2025 English - Item 117 - Question 117';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 117 - Question 117</small></p><p><strong>WAEC 2025 English - Question 117</strong></p><p>From the words lettered A to D, choose the one that has the correct stress.</p><p><strong>concessionaire</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'con-cess-<strong>ION</strong>-aire', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'con-cess-<strong>ION</strong>-aire' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'con-cess-ion-<strong>AIRE</strong>', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'con-cess-ion-<strong>AIRE</strong>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'con-<strong>CESS</strong>-ion-aire', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'con-<strong>CESS</strong>-ion-aire' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<strong>CON</strong>-cess-ion-aire', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '<strong>CON</strong>-cess-ion-aire' AND deleted = 0);

-- WAEC 2025 English - Item 118 - Question 118
SET @source_marker := 'WAEC 2025 English - Item 118 - Question 118';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 118 - Question 118</small></p><p><strong>WAEC 2025 English - Question 118</strong></p><p>From the words lettered A to D, choose the one that has the correct stress.</p><p><strong>horizontal</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hor-i-<strong>ZON</strong>-tal', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hor-i-<strong>ZON</strong>-tal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hor-<strong>I</strong>-zon-tal', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hor-<strong>I</strong>-zon-tal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<strong>HOR</strong>-i-zon-tal', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '<strong>HOR</strong>-i-zon-tal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hor-i-zon-<strong>TAL</strong>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hor-i-zon-<strong>TAL</strong>' AND deleted = 0);

-- WAEC 2025 English - Item 119 - Question 119
SET @source_marker := 'WAEC 2025 English - Item 119 - Question 119';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 119 - Question 119</small></p><p><strong>WAEC 2025 English - Question 119</strong></p><p>From the words lettered A to D, choose the one that has the correct stress.</p><p><strong>apathetic</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<strong>AP</strong>-a-thet-ic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '<strong>AP</strong>-a-thet-ic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ap-a-<strong>THET</strong>-ic', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ap-a-<strong>THET</strong>-ic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ap-a-thet-<strong>IC</strong>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ap-a-thet-<strong>IC</strong>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ap-<strong>A</strong>-thet-ic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ap-<strong>A</strong>-thet-ic' AND deleted = 0);

-- WAEC 2025 English - Item 120 - Question 120
SET @source_marker := 'WAEC 2025 English - Item 120 - Question 120';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 120 - Question 120</small></p><p><strong>WAEC 2025 English - Question 120</strong></p><p>From the words lettered A to D, choose the one that has the correct stress.</p><p><strong>effeminate</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<strong>E</strong>-ffem-i-nate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '<strong>E</strong>-ffem-i-nate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'e-<strong>FFEM</strong>-i-nate', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'e-<strong>FFEM</strong>-i-nate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'e-ffem-i-<strong>NATE</strong>', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'e-ffem-i-<strong>NATE</strong>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'e-ffem-<strong>I</strong>-nate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'e-ffem-<strong>I</strong>-nate' AND deleted = 0);

-- WAEC 2025 English - Item 121 - Question 121
SET @source_marker := 'WAEC 2025 English - Item 121 - Question 121';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 121 - Question 121</small></p><p><strong>WAEC 2025 English - Question 121</strong></p><p><strong>Identify the word with a different stress pattern</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'maintenance', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'maintenance' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'primary', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'primary' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enigma', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'enigma' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'candidate', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'candidate' AND deleted = 0);

-- WAEC 2025 English - Item 122 - Question 122
SET @source_marker := 'WAEC 2025 English - Item 122 - Question 122';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 122 - Question 122</small></p><p><strong>WAEC 2025 English - Question 122</strong></p><p><strong>Identify the word with a different stress pattern</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'caution', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'caution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mountain', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'mountain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'creature', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'creature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'extrude', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'extrude' AND deleted = 0);

-- WAEC 2025 English - Item 123 - Question 123
SET @source_marker := 'WAEC 2025 English - Item 123 - Question 123';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 123 - Question 123</small></p><p><strong>WAEC 2025 English - Question 123</strong></p><p><strong>Identify the word with a different stress pattern</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'declare', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'declare' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'annoy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'annoy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'radar', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'radar' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'believe', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'believe' AND deleted = 0);

-- WAEC 2025 English - Item 124 - Question 124
SET @source_marker := 'WAEC 2025 English - Item 124 - Question 124';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 124 - Question 124</small></p><p><strong>WAEC 2025 English - Question 124</strong></p><p><strong>Identify the word with a different stress pattern</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'discover', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'discover' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pertinent', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'pertinent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'retrospect', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'retrospect' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'penitence', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'penitence' AND deleted = 0);

-- WAEC 2025 English - Item 125 - Question 125
SET @source_marker := 'WAEC 2025 English - Item 125 - Question 125';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 125 - Question 125</small></p><p><strong>WAEC 2025 English - Question 125</strong></p><p><strong>Identify the word with a different stress pattern</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Stress Pattern', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'belief', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'belief' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enjoy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'enjoy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'refer', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'refer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reason', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reason' AND deleted = 0);

-- WAEC 2025 English - Item 126 - Question 126
SET @source_marker := 'WAEC 2025 English - Item 126 - Question 126';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 126 - Question 126</small></p><p><strong>WAEC 2025 English - Question 126</strong></p><p><em>In each of the following sentences, the word that receives the emphatic stress is written in Capital letters. Choose the option to which the given sentence is the appropriate answer.</em></p><p><strong>Ojo won the prize for the best TEACHER.</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Emphatic Stress', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did Ojo win the award for the best teacher?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did Ojo win the award for the best teacher?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did Ojo lose the prize for the best teacher?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did Ojo lose the prize for the best teacher?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did Ojo win the prize for the best dancer?', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did Ojo win the prize for the best dancer?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did Oke win the prize for the best teacher?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did Oke win the prize for the best teacher?' AND deleted = 0);

-- WAEC 2025 English - Item 127 - Question 127
SET @source_marker := 'WAEC 2025 English - Item 127 - Question 127';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 127 - Question 127</small></p><p><strong>WAEC 2025 English - Question 127</strong></p><p><em>In each of the following sentences, the word that receives the emphatic stress is written in Capital letters. Choose the option to which the given sentence is the appropriate answer.</em></p><p><strong>The president rewarded some of the OFFICERS.</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Emphatic Stress', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the senator reward some of the officers?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the senator reward some of the officers?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the president censure some of the officers?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the president censure some of the officers?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the president reward some of the students?', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the president reward some of the students?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the president reward all the officers?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the president reward all the officers?' AND deleted = 0);

-- WAEC 2025 English - Item 128 - Question 128
SET @source_marker := 'WAEC 2025 English - Item 128 - Question 128';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 128 - Question 128</small></p><p><strong>WAEC 2025 English - Question 128</strong></p><p><em>In each of the following sentences, the word that receives the emphatic stress is written in Capital letters. Choose the option to which the given sentence is the appropriate answer.</em></p><p><strong>The woman bought a CARTON of milk.</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Emphatic Stress', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the woman buy a tin of milk?', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the woman buy a tin of milk?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the woman buy a carton of fish?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the woman buy a carton of fish?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the man buy a carton of milk?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the man buy a carton of milk?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did the woman sell a carton of milk?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did the woman sell a carton of milk?' AND deleted = 0);

-- WAEC 2025 English - Item 129 - Question 129
SET @source_marker := 'WAEC 2025 English - Item 129 - Question 129';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 129 - Question 129</small></p><p><strong>WAEC 2025 English - Question 129</strong></p><p><em>In each of the following sentences, the word that receives the emphatic stress is written in Capital letters. Choose the option to which the given sentence is the appropriate answer.</em></p><p><strong>She will send a BAG to him today.</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Emphatic Stress', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Will she send a bag to him tomorrow?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Will she send a bag to him tomorrow?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Will she send a shirt to him today?', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Will she send a shirt to him today?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Will he send a bag to him today?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Will he send a bag to him today?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Will she send a bag to her today?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Will she send a bag to her today?' AND deleted = 0);

-- WAEC 2025 English - Item 130 - Question 130
SET @source_marker := 'WAEC 2025 English - Item 130 - Question 130';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 130 - Question 130</small></p><p><strong>WAEC 2025 English - Question 130</strong></p><p><em>In each of the following sentences, the word that receives the emphatic stress is written in Capital letters. Choose the option to which the given sentence is the appropriate answer.</em></p><p><strong>She slept on the BIG bed.</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Emphatic Stress', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did she sleep on the small bed?', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did she sleep on the small bed?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did he sleep on the big bed?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did he sleep on the big bed?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did she sleep under the big bed?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did she sleep under the big bed?' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Did she sleep on the big couch?', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Did she sleep on the big couch?' AND deleted = 0);

-- WAEC 2025 English - Item 131 - Question 131
SET @source_marker := 'WAEC 2025 English - Item 131 - Question 131';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 131 - Question 131</small></p><p><strong>WAEC 2025 English - Question 131</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#596;&#618;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'note', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'note' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stock', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'stock' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'coin', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'coin' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'roam', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'roam' AND deleted = 0);

-- WAEC 2025 English - Item 132 - Question 132
SET @source_marker := 'WAEC 2025 English - Item 132 - Question 132';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 132 - Question 132</small></p><p><strong>WAEC 2025 English - Question 132</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#604;&#720;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'scourge', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'scourge' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'heart', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'heart' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shears', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shears' AND deleted = 0);

-- WAEC 2025 English - Item 133 - Question 133
SET @source_marker := 'WAEC 2025 English - Item 133 - Question 133';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 133 - Question 133</small></p><p><strong>WAEC 2025 English - Question 133</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#643;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'charm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'charm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'charade', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'charade' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'measure', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'measure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fist', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fist' AND deleted = 0);

-- WAEC 2025 English - Item 134 - Question 134
SET @source_marker := 'WAEC 2025 English - Item 134 - Question 134';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 134 - Question 134</small></p><p><strong>WAEC 2025 English - Question 134</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#650;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hook', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hook' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'souse', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'souse' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cool', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cool' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'juice', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'juice' AND deleted = 0);

-- WAEC 2025 English - Item 135 - Question 135
SET @source_marker := 'WAEC 2025 English - Item 135 - Question 135';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 135 - Question 135</small></p><p><strong>WAEC 2025 English - Question 135</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#230;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'small', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'small' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'around', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'around' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'snag', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'snag' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'also', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'also' AND deleted = 0);

-- WAEC 2025 English - Item 136 - Question 136
SET @source_marker := 'WAEC 2025 English - Item 136 - Question 136';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 136 - Question 136</small></p><p><strong>WAEC 2025 English - Question 136</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/d&#658;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'suggest', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'suggest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gear', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gear' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rich', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rich' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seizure', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seizure' AND deleted = 0);

-- WAEC 2025 English - Item 137 - Question 137
SET @source_marker := 'WAEC 2025 English - Item 137 - Question 137';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 137 - Question 137</small></p><p><strong>WAEC 2025 English - Question 137</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#331;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'thin', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'thin' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sink', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'sink' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hinge', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hinge' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reign', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reign' AND deleted = 0);

-- WAEC 2025 English - Item 138 - Question 138
SET @source_marker := 'WAEC 2025 English - Item 138 - Question 138';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 138 - Question 138</small></p><p><strong>WAEC 2025 English - Question 138</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#952;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'breathe', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'breathe' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wither', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'wither' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stealthy', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'stealthy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'feather', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'feather' AND deleted = 0);

-- WAEC 2025 English - Item 139 - Question 139
SET @source_marker := 'WAEC 2025 English - Item 139 - Question 139';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 139 - Question 139</small></p><p><strong>WAEC 2025 English - Question 139</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/e&#618;/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'said', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'said' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gale', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'gale' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'seize', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'seize' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nine', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'nine' AND deleted = 0);

-- WAEC 2025 English - Item 140 - Question 140
SET @source_marker := 'WAEC 2025 English - Item 140 - Question 140';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 English - Item 140 - Question 140</small></p><p><strong>WAEC 2025 English - Question 140</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/j/</strong></p>', @english_subject_id, 0, 'exam_body', @waec_exam_body_id, 0, 'Medium', 'SSS3', '', 'Phonetics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'value', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'value' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'jest', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'jest' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'flew', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'flew' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'haste', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'haste' AND deleted = 0);

-- Repair already-imported phonetic-symbol rows if a client converted the
-- original UTF-8 symbols to question marks while running this migration.
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 131 - Question 131</small></p><p><strong>WAEC 2025 English - Question 131</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#596;&#618;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 131 - Question 131%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 132 - Question 132</small></p><p><strong>WAEC 2025 English - Question 132</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#604;&#720;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 132 - Question 132%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 133 - Question 133</small></p><p><strong>WAEC 2025 English - Question 133</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#643;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 133 - Question 133%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 134 - Question 134</small></p><p><strong>WAEC 2025 English - Question 134</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#650;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 134 - Question 134%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 135 - Question 135</small></p><p><strong>WAEC 2025 English - Question 135</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#230;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 135 - Question 135%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 136 - Question 136</small></p><p><strong>WAEC 2025 English - Question 136</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/d&#658;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 136 - Question 136%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 137 - Question 137</small></p><p><strong>WAEC 2025 English - Question 137</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#331;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 137 - Question 137%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 138 - Question 138</small></p><p><strong>WAEC 2025 English - Question 138</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/&#952;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 138 - Question 138%';

UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 English - Item 139 - Question 139</small></p><p><strong>WAEC 2025 English - Question 139</strong></p><p><em>Choose the word that contains the sound represented by the given phonetic symbol.</em></p><p><strong>/e&#618;/</strong></p>'
WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @english_subject_id AND question LIKE '%WAEC 2025 English - Item 139 - Question 139%';

COMMIT;

SELECT
    COUNT(*) AS waec_2025_english_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @waec_exam_body_id
  AND subject_id = @english_subject_id
  AND question LIKE '%WAEC 2025 English - Item%';
