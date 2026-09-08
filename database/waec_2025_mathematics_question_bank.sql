-- WAEC 2025 Mathematics objective questions for the global question bank.
-- Generated from: q_bank/WAEC_2025_Mathematics_Questions.json
-- Expected payload: 50 questions and 200 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.

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
SET @mathematics_subject_id := (SELECT id FROM subjects WHERE subject IN ('Mathematics', 'Maths', 'Math') ORDER BY FIELD(subject, 'Mathematics', 'Maths', 'Math'), id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_waec_2025_mathematics_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_waec_2025_mathematics_refs()
BEGIN
    IF @waec_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WAEC exam body could not be resolved.';
    END IF;
    IF @mathematics_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mathematics subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_waec_2025_mathematics_refs();
DROP PROCEDURE ss360_require_waec_2025_mathematics_refs;

START TRANSACTION;

-- WAEC 2025 Mathematics - Item 1 - Question 1
SET @source_marker := 'WAEC 2025 Mathematics - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 1 - Question 1</small></p><p><strong>WAEC 2025 Mathematics - Question 1</strong></p><p>Find (101₂)², expressing the answer in base 2.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Number and Logarithms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11101', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '11101' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10101', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10101' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10010', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10010' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11001', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '11001' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 2 - Question 2
SET @source_marker := 'WAEC 2025 Mathematics - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 2 - Question 2</small></p><p><strong>WAEC 2025 Mathematics - Question 2</strong></p><p>If three children share ₦10.50 among themselves in the ratio 6:7:8, how much is the largest share?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Commercial Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦3.50', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦3.50' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦4.00', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦4.00' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦4.50', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦4.50' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦3.00', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦3.00' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 3 - Question 3
SET @source_marker := 'WAEC 2025 Mathematics - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 3 - Question 3</small></p><p><strong>WAEC 2025 Mathematics - Question 3</strong></p><p>Express 0.000834 in standard form.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Number and Logarithms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x 10⁻⁴', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.34 x 10⁻⁴' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x 10⁻³', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.34 x 10⁻³' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x 10⁴', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.34 x 10⁴' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x 10³', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.34 x 10³' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 4 - Question 4
SET @source_marker := 'WAEC 2025 Mathematics - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 4 - Question 4</small></p><p><strong>WAEC 2025 Mathematics - Question 4</strong></p><p>Simplify 0.027⁻¹⁄₃</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '³⁄₁₀', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '³⁄₁₀' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3¹⁄₃', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3¹⁄₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '¹⁄₃', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '¹⁄₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 5 - Question 5
SET @source_marker := 'WAEC 2025 Mathematics - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 5 - Question 5</small></p><p><strong>WAEC 2025 Mathematics - Question 5</strong></p><p>Given that log₂a = log₈₄, find a.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Number and Logarithms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2¹⁄₂', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2¹⁄₂' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2²⁄₃', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2²⁄₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4²⁄₃', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4²⁄₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4¹⁄₂', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4¹⁄₂' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 6 - Question 6
SET @source_marker := 'WAEC 2025 Mathematics - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 6 - Question 6</small></p><p><strong>WAEC 2025 Mathematics - Question 6</strong></p><p>By selling some crates of soft drinks for ₦600.00, a dealer makes a profit of 50%. How much did the dealer pay for the drinks?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Commercial Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦400.00', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦400.00' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦1200.00', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦1200.00' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦900.00', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦900.00' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦450.00', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦450.00' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 7 - Question 7
SET @source_marker := 'WAEC 2025 Mathematics - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 7 - Question 7</small></p><p><strong>WAEC 2025 Mathematics - Question 7</strong></p><p>Find the nth term Un of the A.P. 11, 4, -3, …</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Sequences and Series', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 19 - 7n', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Un = 19 - 7n' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 19 + 7n', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Un = 19 + 7n' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 18 - 7n', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Un = 18 - 7n' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 18 + 7n', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Un = 18 + 7n' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 8 - Question 8
SET @source_marker := 'WAEC 2025 Mathematics - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 8 - Question 8</small></p><p><strong>WAEC 2025 Mathematics - Question 8</strong></p><p>If R = {2, 4, 6, 7} and S = {1, 2, 4, 8} then R ∪ S equals</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Sets', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '{1, 2, 4, 6, 7, 8}', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '{1, 2, 4, 6, 7, 8}' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '{1, 2, 4, 7, 8}', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '{1, 2, 4, 7, 8}' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '{1, 4, 7, 8}', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '{1, 4, 7, 8}' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '{2, 6, 7}', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '{2, 6, 7}' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 9 - Question 9
SET @source_marker := 'WAEC 2025 Mathematics - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 9 - Question 9</small></p><p><strong>WAEC 2025 Mathematics - Question 9</strong></p><p>If <br>¹⁶⁄₉<br>, x, 1, y are in geometric progression (G.P.). Find the product of x and y.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Sequences and Series', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '¹⁶⁄₉', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '¹⁶⁄₉' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '³⁄₄', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '³⁄₄' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '⁴⁄₃', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '⁴⁄₃' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 10 - Question 10
SET @source_marker := 'WAEC 2025 Mathematics - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 10 - Question 10</small></p><p><strong>WAEC 2025 Mathematics - Question 10</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q10_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 10" style="max-width:100%;height:auto;"></p><p>In the diagram above, the shaded portion is</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(P ∪ Q)ᶜ ∩ R', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(P ∪ Q)ᶜ ∩ R' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pᶜ ∩ Q ∩ R', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pᶜ ∩ Q ∩ R' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pᶜ ∩ R', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pᶜ ∩ R' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Qᶜ ∩ R', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Qᶜ ∩ R' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 11 - Question 11
SET @source_marker := 'WAEC 2025 Mathematics - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 11 - Question 11</small></p><p><strong>WAEC 2025 Mathematics - Question 11</strong></p><p>Find the values of x for which the expression is undefined: (6x - 1)/(x² + 4x - 5)</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '+5 or -1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '+5 or -1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-5 or +1', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-5 or +1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-5 or -1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-5 or -1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '+4 or +1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '+4 or +1' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 12 - Question 12
SET @source_marker := 'WAEC 2025 Mathematics - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 12 - Question 12</small></p><p><strong>WAEC 2025 Mathematics - Question 12</strong></p><p>Solve the inequality ¹⁄₃(2x - 1) &lt; 5</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; -5', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'x &lt; -5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; 8', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'x &lt; 8' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; -6', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'x &lt; -6' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; 7', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'x &lt; 7' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 13 - Question 13
SET @source_marker := 'WAEC 2025 Mathematics - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 13 - Question 13</small></p><p><strong>WAEC 2025 Mathematics - Question 13</strong></p><p>What is the smaller value of x for which x² - 3x + 2 = 0 ?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 14 - Question 14
SET @source_marker := 'WAEC 2025 Mathematics - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 14 - Question 14</small></p><p><strong>WAEC 2025 Mathematics - Question 14</strong></p><p>Factorize the expression x(a - c) + y(c - a)</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(a - c)(y - x)', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(a - c)(y - x)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(a + c)(x + y)', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(a + c)(x + y)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(a + c)(x - y)', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(a + c)(x - y)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(a - c)(x - y)', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(a - c)(x - y)' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 15 - Question 15
SET @source_marker := 'WAEC 2025 Mathematics - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 15 - Question 15</small></p><p><strong>WAEC 2025 Mathematics - Question 15</strong></p><p>If y ∝ 1⁄x² and x = 3, when y = 4, find y when x = 2</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '9' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '18' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 16 - Question 16
SET @source_marker := 'WAEC 2025 Mathematics - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 16 - Question 16</small></p><p><strong>WAEC 2025 Mathematics - Question 16</strong></p><p>Solve the equation 3x² + 25x - 18 = 0</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-3, 2', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-3, 2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-9, 
²⁄₃', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-9, 
²⁄₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2, 9', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-2, 9' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2, 3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-2, 3' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 17 - Question 17
SET @source_marker := 'WAEC 2025 Mathematics - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 17 - Question 17</small></p><p><strong>WAEC 2025 Mathematics - Question 17</strong></p><p>Solve the equation (x + 2)(x - 7) = 0</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1 or 8', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-1 or 8' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-4 or 5', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-4 or 5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-3 or 6', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-3 or 6' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2 or 7', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-2 or 7' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 18 - Question 18
SET @source_marker := 'WAEC 2025 Mathematics - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 18 - Question 18</small></p><p><strong>WAEC 2025 Mathematics - Question 18</strong></p><p>Solve the following simultaneous equations: x + y = <br>³⁄₂<br>, x - y = <br>⁵⁄₂<br>. And use your result to find the value of 2y + x.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '¹⁄₂', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '¹⁄₂' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-1' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 19 - Question 19
SET @source_marker := 'WAEC 2025 Mathematics - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 19 - Question 19</small></p><p><strong>WAEC 2025 Mathematics - Question 19</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q19_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 19" style="max-width:100%;height:auto;"></p><p>Which of the following could be the inequality illustrated in the sketch graph above?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y ≤ -3x + 3', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'y ≤ -3x + 3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y ≤ 3x + 2', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'y ≤ 3x + 2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y ≥ -2x + 3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'y ≥ -2x + 3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y ≤ x + 3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'y ≤ x + 3' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 20 - Question 20
SET @source_marker := 'WAEC 2025 Mathematics - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 20 - Question 20</small></p><p><strong>WAEC 2025 Mathematics - Question 20</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q20_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 20" style="max-width:100%;height:auto;"></p><p>What is the minimum value of y?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-7', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-7' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-10', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-10' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-4', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-1' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 21 - Question 21
SET @source_marker := 'WAEC 2025 Mathematics - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 21 - Question 21</small></p><p><strong>WAEC 2025 Mathematics - Question 21</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q21_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 21" style="max-width:100%;height:auto;"></p><p>Find the roots of the equation y = 3x² + x - 7.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.4 and -1.7', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.4 and -1.7' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.0 and -1.9', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.0 and -1.9' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.0 and -1.2', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.0 and -1.2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.1 and -1.3', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.1 and -1.3' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 22 - Question 22
SET @source_marker := 'WAEC 2025 Mathematics - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 22 - Question 22</small></p><p><strong>WAEC 2025 Mathematics - Question 22</strong></p><p>The diagonals AC and BD of a rhombus ABCD are 16 cm and 12 cm long, respectively. Calculate the area of the rhombus.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '96 cm²', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '96 cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '36 cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '36 cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '48 cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '48 cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '24 cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '24 cm²' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 23 - Question 23
SET @source_marker := 'WAEC 2025 Mathematics - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 23 - Question 23</small></p><p><strong>WAEC 2025 Mathematics - Question 23</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q23_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 23" style="max-width:100%;height:auto;"></p><p>A cylindrical container, closed at both ends, has a radius of 7 cm and a height of 5 cm. Use this information to answer the questions below. Find the total surface area of the container.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '35 cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '35 cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '528 cm²', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '528 cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '154 cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '154 cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '220 cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '220 cm²' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 24 - Question 24
SET @source_marker := 'WAEC 2025 Mathematics - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 24 - Question 24</small></p><p><strong>WAEC 2025 Mathematics - Question 24</strong></p><p>Find the total surface area of a solid circular cone with base radius 3 cm and slant height 4 cm. [Take π = ²²⁄₇]</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '66 cm²', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '66 cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '37⁵⁄₇cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '37⁵⁄₇cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '75³⁄₇cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '75³⁄₇cm²' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '78⁶⁄₇cm²', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '78⁶⁄₇cm²' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 25 - Question 25
SET @source_marker := 'WAEC 2025 Mathematics - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 25 - Question 25</small></p><p><strong>WAEC 2025 Mathematics - Question 25</strong></p><p>A water tank of height ¹⁄₂ m has a square base of side 1 ¹⁄₂m. If it is filled with water from a water tanker holding 1500 litres, how many litres of water are left in the water tanker? [1000 litres = 1 m³]</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Commercial Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '375 litres', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '375 litres' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3750 litres', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3750 litres' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '37.5 litres', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '37.5 litres' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '37500 litres', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '37500 litres' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 26 - Question 26
SET @source_marker := 'WAEC 2025 Mathematics - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 26 - Question 26</small></p><p><strong>WAEC 2025 Mathematics - Question 26</strong></p><p>A hollow sphere has a volume of k cm³ and a surface area of k cm². Calculate the diameter of the sphere.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3 cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3 cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9 cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '9 cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'More information needed.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'More information needed.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6 cm', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6 cm' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 27 - Question 27
SET @source_marker := 'WAEC 2025 Mathematics - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 27 - Question 27</small></p><p><strong>WAEC 2025 Mathematics - Question 27</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q27_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 27" style="max-width:100%;height:auto;"></p><p>The diagram above shows a cone with the dimensions of its frustum indicated. Calculate the height of the cone.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '24 cm', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '24 cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15 cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '15 cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8 cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8 cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12 cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12 cm' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 28 - Question 28
SET @source_marker := 'WAEC 2025 Mathematics - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 28 - Question 28</small></p><p><strong>WAEC 2025 Mathematics - Question 28</strong></p><p>The positions of two countries, P and Q, are (15°N, 12°E) and (65°N, 12°E) respectively. What is the difference in latitude?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Bearing and Earth Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '50°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '50°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '104°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '104°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '80°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '80°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '100°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '100°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 29 - Question 29
SET @source_marker := 'WAEC 2025 Mathematics - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 29 - Question 29</small></p><p><strong>WAEC 2025 Mathematics - Question 29</strong></p><p>A 120° sector of a circle of radius 21 cm is bent to form a cone. What is the base radius of the cone?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3¹⁄₂ cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3¹⁄₂ cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10¹⁄₂ cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10¹⁄₂ cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14 cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '14 cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7 cm', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7 cm' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 30 - Question 30
SET @source_marker := 'WAEC 2025 Mathematics - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 30 - Question 30</small></p><p><strong>WAEC 2025 Mathematics - Question 30</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q30_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 30" style="max-width:100%;height:auto;"></p><p>A cylindrical container, closed at both ends, has a radius of 7 cm and a height of 5 cm. Use this information to answer the questions below. What is the volume of the container?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '770 cm³', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '770 cm³' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '35 cm³', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '35 cm³' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '220 cm³', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '220 cm³' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '154 cm³', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '154 cm³' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 31 - Question 31
SET @source_marker := 'WAEC 2025 Mathematics - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 31 - Question 31</small></p><p><strong>WAEC 2025 Mathematics - Question 31</strong></p><p>If log₁₀x = 2.3675 and log₁₀y = 2.9738, what is the value of x + y, correct to three significant figures</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Number and Logarithms', 'The source appears to omit barred-log notation. Answer uses the barred characteristic interpretation, giving x + y ≈ 0.117.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.118', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.118' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.903', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.903' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.117', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.117' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.944', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.944' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 32 - Question 32
SET @source_marker := 'WAEC 2025 Mathematics - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 32 - Question 32</small></p><p><strong>WAEC 2025 Mathematics - Question 32</strong></p><p>The angle of a sector of a circle is 108 °. If the radius of the circle is 3¹⁄₂cm, find the perimeter of the sector.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6 ³⁄₅ cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6 ³⁄₅ cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7²⁄₁₀ cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7²⁄₁₀ cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6 ⁴⁄₅ cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6 ⁴⁄₅ cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '13 ³⁄₅ cm', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '13 ³⁄₅ cm' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 33 - Question 33
SET @source_marker := 'WAEC 2025 Mathematics - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 33 - Question 33</small></p><p><strong>WAEC 2025 Mathematics - Question 33</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q33_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 33" style="max-width:100%;height:auto;"></p><p>In the diagram above, AO is perpendicular to OB. Find x.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '15°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '22.5°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '22.5°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.5°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.5°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '30°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '30°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 34 - Question 34
SET @source_marker := 'WAEC 2025 Mathematics - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 34 - Question 34</small></p><p><strong>WAEC 2025 Mathematics - Question 34</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q34_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 34" style="max-width:100%;height:auto;"></p><p>In the diagram above. O is the centre of the circle and |BD| = |DC|. If ∠DCB = 35°, find ∠BAO</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '25°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '25°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '30°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '30°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '20°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '20°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '35°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '35°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 35 - Question 35
SET @source_marker := 'WAEC 2025 Mathematics - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 35 - Question 35</small></p><p><strong>WAEC 2025 Mathematics - Question 35</strong></p><p>Which of the following angles is an exterior angle of a regular polygon?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '95°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '95°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '78°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '78°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '72°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '72°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '85°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '85°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 36 - Question 36
SET @source_marker := 'WAEC 2025 Mathematics - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 36 - Question 36</small></p><p><strong>WAEC 2025 Mathematics - Question 36</strong></p><p>The locus of a point which is equidistant from two given fixed points is the</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Angle bisector of the straight lines joining them.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Angle bisector of the straight lines joining them.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Parallel line to the straight line joining them.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Parallel line to the straight line joining them.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Perpendicular to the straight line joining them.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Perpendicular to the straight line joining them.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Perpendicular bisector of the straight line joining them.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Perpendicular bisector of the straight line joining them.' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 37 - Question 37
SET @source_marker := 'WAEC 2025 Mathematics - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 37 - Question 37</small></p><p><strong>WAEC 2025 Mathematics - Question 37</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q37_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 37" style="max-width:100%;height:auto;"></p><p>In the diagram,|AB| = 12cm, |AE| = 8cm, |DC| = 9cm and BD||DC. Find the length of EC.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6cm', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '9cm' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 38 - Question 38
SET @source_marker := 'WAEC 2025 Mathematics - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 38 - Question 38</small></p><p><strong>WAEC 2025 Mathematics - Question 38</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q38_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 38" style="max-width:100%;height:auto;"></p><p>In the diagram above, PQ is parallel to TU, ∠PQR = 50°, ∠QRS = 86°, and ∠STU = 64°. Calculate the value of x</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '100°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '100°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '108°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '108°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '120°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '120°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '136°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '136°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 39 - Question 39
SET @source_marker := 'WAEC 2025 Mathematics - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 39 - Question 39</small></p><p><strong>WAEC 2025 Mathematics - Question 39</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q39_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 39" style="max-width:100%;height:auto;"></p><p>In the diagram below, AB||DC, the bisectors of ∠BAC and ∠ACD meet at E. Find the value of ∠AEC</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '45°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '45°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '60°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '60°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '30°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '30°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '90°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '90°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 40 - Question 40
SET @source_marker := 'WAEC 2025 Mathematics - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 40 - Question 40</small></p><p><strong>WAEC 2025 Mathematics - Question 40</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q40_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 40" style="max-width:100%;height:auto;"></p><p>In the diagram above, AB||CD. What is the size of the angle marked x?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '93°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '93°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '77°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '77°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '103°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '103°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '62°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '62°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 41 - Question 41
SET @source_marker := 'WAEC 2025 Mathematics - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 41 - Question 41</small></p><p><strong>WAEC 2025 Mathematics - Question 41</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q41_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 41" style="max-width:100%;height:auto;"></p><p>In the diagram above, the value of angles b + c is</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '90°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '90°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '180°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '180°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'd°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'd°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 42 - Question 42
SET @source_marker := 'WAEC 2025 Mathematics - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 42 - Question 42</small></p><p><strong>WAEC 2025 Mathematics - Question 42</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q42_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 42" style="max-width:100%;height:auto;"></p><p>In △ABC above, BC is produced to D, |AB| = |AC|, and ∠BAC = 50°. Find ∠ACD.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '115°', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '115°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '65°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '65°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '60°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '60°' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '50°', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '50°' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 43 - Question 43
SET @source_marker := 'WAEC 2025 Mathematics - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 43 - Question 43</small></p><p><strong>WAEC 2025 Mathematics - Question 43</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q43_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 43" style="max-width:100%;height:auto;"></p><p>In the diagram above, ∠PRQ = 90°, ∠QPR = 30° and |PQ| = 10 cm. Find y</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5cm', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5cm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3cm', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3cm' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 44 - Question 44
SET @source_marker := 'WAEC 2025 Mathematics - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 44 - Question 44</small></p><p><strong>WAEC 2025 Mathematics - Question 44</strong></p><p>What is the mode of the numbers 8, 10, 9, 9, 10, 8, 11, 8, 10, 9, 8, and 14?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Statistics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '9' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '11' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 45 - Question 45
SET @source_marker := 'WAEC 2025 Mathematics - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 45 - Question 45</small></p><p><strong>WAEC 2025 Mathematics - Question 45</strong></p><p>The bearing of two points Q and R from a point P are 030° and 120°, respectively. If |PQ| = 12 m and |PR| = 5 m, find the distance QR.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Bearing and Earth Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11 m', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '11 m' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '13 m', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '13 m' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9 m', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '9 m' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7 m', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7 m' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 46 - Question 46
SET @source_marker := 'WAEC 2025 Mathematics - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 46 - Question 46</small></p><p><strong>WAEC 2025 Mathematics - Question 46</strong></p><p>Without using tables, find the value of: sin 20°⁄cos 70° + cos 25°⁄sin 65°</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Trigonometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-1' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 47 - Question 47
SET @source_marker := 'WAEC 2025 Mathematics - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 47 - Question 47</small></p><p><strong>WAEC 2025 Mathematics - Question 47</strong></p><p>The mean of 20 observations in an experiment is 4. If the observed largest value is 23, find the mean of the remaining observations.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Statistics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.60', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.60' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.85', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.85' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 48 - Question 48
SET @source_marker := 'WAEC 2025 Mathematics - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 48 - Question 48</small></p><p><strong>WAEC 2025 Mathematics - Question 48</strong></p><p>Two fair dice are tossed together once. Find the probability that the sum of the outcomes is at least 10.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Probability', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '¹⁄₆', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '¹⁄₆' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '¹⁄₁₂', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '¹⁄₁₂' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '¹⁄₄', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '¹⁄₄' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '⁵⁄₃₆', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '⁵⁄₃₆' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 49 - Question 49
SET @source_marker := 'WAEC 2025 Mathematics - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 49 - Question 49</small></p><p><strong>WAEC 2025 Mathematics - Question 49</strong></p><p>Find the median of the following numbers: 2.64, 2.50, 2.72, 2.91, and 2.35</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Statistics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.50', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.50' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.64', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.64' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.91', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.91' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.72', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.72' AND deleted = 0);

-- WAEC 2025 Mathematics - Item 50 - Question 50
SET @source_marker := 'WAEC 2025 Mathematics - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Mathematics - Item 50 - Question 50</small></p><p><strong>WAEC 2025 Mathematics - Question 50</strong></p><p>From a box containing 2 red, 6 white, and 5 black balls, a ball is randomly selected. What is the probability that the selected ball is black?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Probability', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '⁵⁄₁₃', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '⁵⁄₁₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '⁵⁄₁₁', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '⁵⁄₁₁' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '²⁄₁₃', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '²⁄₁₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '⁵⁄₆', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '⁵⁄₆' AND deleted = 0);

-- MathQuill formatting repairs for WAEC 2025 Mathematics notation.
-- These updates keep the import repeat-safe while replacing plain Unicode math
-- with the same MathQuill span format used by the assessment editor.

-- MathQuill repair: WAEC 2025 Mathematics - Item 1 - Question 1
SET @source_marker := 'WAEC 2025 Mathematics - Item 1 - Question 1';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 1 - Question 1</small></p><p><strong>WAEC 2025 Mathematics - Question 1</strong></p><p>Find <span contenteditable="false" class="math-editor-rendered" data-latex="(101₂)"></span>², expressing the answer in base 2.</p>',
    question_category = 'Number and Logarithms',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11101', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10101', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10010', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11001', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 2 - Question 2
SET @source_marker := 'WAEC 2025 Mathematics - Item 2 - Question 2';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 2 - Question 2</small></p><p><strong>WAEC 2025 Mathematics - Question 2</strong></p><p>If three children share ₦10.50 among themselves in the ratio 6:7:8, how much is the largest share?</p>',
    question_category = 'Commercial Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦3.50', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦4.00', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦4.50', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦3.00', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 3 - Question 3
SET @source_marker := 'WAEC 2025 Mathematics - Item 3 - Question 3';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 3 - Question 3</small></p><p><strong>WAEC 2025 Mathematics - Question 3</strong></p><p>Express 0.000834 in standard form.</p>',
    question_category = 'Number and Logarithms',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x <span contenteditable="false" class="math-editor-rendered" data-latex="10^{-4}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x <span contenteditable="false" class="math-editor-rendered" data-latex="10^{-3}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x <span contenteditable="false" class="math-editor-rendered" data-latex="10^{4}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.34 x <span contenteditable="false" class="math-editor-rendered" data-latex="10^{3}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 4 - Question 4
SET @source_marker := 'WAEC 2025 Mathematics - Item 4 - Question 4';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 4 - Question 4</small></p><p><strong>WAEC 2025 Mathematics - Question 4</strong></p><p>Simplify 0.<span contenteditable="false" class="math-editor-rendered" data-latex="027\\frac{-1}{3}"></span></p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{3}{10}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="3\\frac{1}{3}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{3}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 5 - Question 5
SET @source_marker := 'WAEC 2025 Mathematics - Item 5 - Question 5';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 5 - Question 5</small></p><p><strong>WAEC 2025 Mathematics - Question 5</strong></p><p>Given that <span contenteditable="false" class="math-editor-rendered" data-latex="log_{2}a ="></span><span contenteditable="false" class="math-editor-rendered" data-latex="log_{84}"></span>, find a.</p>',
    question_category = 'Number and Logarithms',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="2\\frac{1}{2}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="2\\frac{2}{3}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="4\\frac{2}{3}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="4\\frac{1}{2}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 6 - Question 6
SET @source_marker := 'WAEC 2025 Mathematics - Item 6 - Question 6';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 6 - Question 6</small></p><p><strong>WAEC 2025 Mathematics - Question 6</strong></p><p>By selling some crates of soft drinks for ₦600.00, a dealer makes a profit of 50%. How much did the dealer pay for the drinks?</p>',
    question_category = 'Commercial Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦400.00', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦1200.00', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦900.00', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦450.00', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 7 - Question 7
SET @source_marker := 'WAEC 2025 Mathematics - Item 7 - Question 7';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 7 - Question 7</small></p><p><strong>WAEC 2025 Mathematics - Question 7</strong></p><p>Find the nth term Un of the A.P. 11, 4, -3, …</p>',
    question_category = 'Sequences and Series',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 19 - 7n', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 19 + 7n', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 18 - 7n', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Un = 18 + 7n', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 8 - Question 8
SET @source_marker := 'WAEC 2025 Mathematics - Item 8 - Question 8';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 8 - Question 8</small></p><p><strong>WAEC 2025 Mathematics - Question 8</strong></p><p>If <span contenteditable="false" class="math-editor-rendered" data-latex="R = {2, 4, 6, 7}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="S = {1, 2, 4, 8}"></span> then <span contenteditable="false" class="math-editor-rendered" data-latex="R \\cup S"></span> equals</p>',
    question_category = 'Sets',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="{1, 2, 4, 6, 7, 8}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="{1, 2, 4, 7, 8}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="{1, 4, 7, 8}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="{2, 6, 7}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 9 - Question 9
SET @source_marker := 'WAEC 2025 Mathematics - Item 9 - Question 9';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 9 - Question 9</small></p><p><strong>WAEC 2025 Mathematics - Question 9</strong></p><p>If <br><span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{16}{9}"></span><br>, x, 1, y are in geometric progression (G.P.). Find the product of x and y.</p>',
    question_category = 'Sequences and Series',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{16}{9}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{3}{4}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{4}{3}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 10 - Question 10
SET @source_marker := 'WAEC 2025 Mathematics - Item 10 - Question 10';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 10 - Question 10</small></p><p><strong>WAEC 2025 Mathematics - Question 10</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q10_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 10" style="max-width:100%;height:auto;"></p><p>In the diagram above, the shaded portion is</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(<span contenteditable="false" class="math-editor-rendered" data-latex="P \\cup Q"></span>)ᶜ <span contenteditable="false" class="math-editor-rendered" data-latex="\\cap"></span> R', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pᶜ <span contenteditable="false" class="math-editor-rendered" data-latex="\\cap"></span> <span contenteditable="false" class="math-editor-rendered" data-latex="Q \\cap R"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pᶜ <span contenteditable="false" class="math-editor-rendered" data-latex="\\cap"></span> R', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Qᶜ <span contenteditable="false" class="math-editor-rendered" data-latex="\\cap"></span> R', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 11 - Question 11
SET @source_marker := 'WAEC 2025 Mathematics - Item 11 - Question 11';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 11 - Question 11</small></p><p><strong>WAEC 2025 Mathematics - Question 11</strong></p><p>Find the values of x for which the expression is undefined: <span contenteditable="false" class="math-editor-rendered" data-latex="(6 \\times - 1)"></span>/<span contenteditable="false" class="math-editor-rendered" data-latex="( \\times ^{2} + 4 \\times - 5)"></span></p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '+5 or -1', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-5 or +1', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-5 or -1', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '+4 or +1', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 12 - Question 12
SET @source_marker := 'WAEC 2025 Mathematics - Item 12 - Question 12';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 12 - Question 12</small></p><p><strong>WAEC 2025 Mathematics - Question 12</strong></p><p>Solve the inequality <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{3}"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(2 \\times - 1)"></span> &lt; 5</p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; -5', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; 8', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; -6', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'x &lt; 7', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 13 - Question 13
SET @source_marker := 'WAEC 2025 Mathematics - Item 13 - Question 13';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 13 - Question 13</small></p><p><strong>WAEC 2025 Mathematics - Question 13</strong></p><p>What is the smaller value of x for which <span contenteditable="false" class="math-editor-rendered" data-latex="\\times ^{2} - 3 \\times + 2 = 0"></span> ?</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 14 - Question 14
SET @source_marker := 'WAEC 2025 Mathematics - Item 14 - Question 14';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 14 - Question 14</small></p><p><strong>WAEC 2025 Mathematics - Question 14</strong></p><p>Factorize the expression x<span contenteditable="false" class="math-editor-rendered" data-latex="(a - c)"></span> + y<span contenteditable="false" class="math-editor-rendered" data-latex="(c - a)"></span></p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="(a - c)"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(y - \\times )"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="(a + c)"></span><span contenteditable="false" class="math-editor-rendered" data-latex="( \\times + y)"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="(a + c)"></span><span contenteditable="false" class="math-editor-rendered" data-latex="( \\times - y)"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="(a - c)"></span><span contenteditable="false" class="math-editor-rendered" data-latex="( \\times - y)"></span>', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 15 - Question 15
SET @source_marker := 'WAEC 2025 Mathematics - Item 15 - Question 15';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 15 - Question 15</small></p><p><strong>WAEC 2025 Mathematics - Question 15</strong></p><p>If y <span contenteditable="false" class="math-editor-rendered" data-latex="\\propto"></span> 1⁄x² and x = 3, when y = 4, find y when x = 2</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 16 - Question 16
SET @source_marker := 'WAEC 2025 Mathematics - Item 16 - Question 16';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 16 - Question 16</small></p><p><strong>WAEC 2025 Mathematics - Question 16</strong></p><p>Solve the equation <span contenteditable="false" class="math-editor-rendered" data-latex="3 \\times ^{2} + 25 \\times - 18"></span> = 0</p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-3, 2', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-9, 
<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{2}{3}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2, 9', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2, 3', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 17 - Question 17
SET @source_marker := 'WAEC 2025 Mathematics - Item 17 - Question 17';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 17 - Question 17</small></p><p><strong>WAEC 2025 Mathematics - Question 17</strong></p><p>Solve the equation <span contenteditable="false" class="math-editor-rendered" data-latex="( \\times + 2)"></span><span contenteditable="false" class="math-editor-rendered" data-latex="( \\times - 7)"></span> = 0</p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1 or 8', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-4 or 5', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-3 or 6', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2 or 7', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 18 - Question 18
SET @source_marker := 'WAEC 2025 Mathematics - Item 18 - Question 18';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 18 - Question 18</small></p><p><strong>WAEC 2025 Mathematics - Question 18</strong></p><p>Solve the following simultaneous equations: x + y = <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{3}{2}"></span>, x - y = <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{2}"></span>. And use your result to find the value of 2y + x.</p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 19 - Question 19
SET @source_marker := 'WAEC 2025 Mathematics - Item 19 - Question 19';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 19 - Question 19</small></p><p><strong>WAEC 2025 Mathematics - Question 19</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q19_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 19" style="max-width:100%;height:auto;"></p><p>Which of the following could be the inequality illustrated in the sketch graph above?</p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y <span contenteditable="false" class="math-editor-rendered" data-latex="\\le"></span> -3x + 3', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y <span contenteditable="false" class="math-editor-rendered" data-latex="\\le"></span> 3x + 2', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y <span contenteditable="false" class="math-editor-rendered" data-latex="\\ge"></span> -2x + 3', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'y <span contenteditable="false" class="math-editor-rendered" data-latex="\\le"></span> x + 3', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 20 - Question 20
SET @source_marker := 'WAEC 2025 Mathematics - Item 20 - Question 20';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 20 - Question 20</small></p><p><strong>WAEC 2025 Mathematics - Question 20</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q20_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 20" style="max-width:100%;height:auto;"></p><p>What is the minimum value of y?</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-7', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-10', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-4', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 21 - Question 21
SET @source_marker := 'WAEC 2025 Mathematics - Item 21 - Question 21';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 21 - Question 21</small></p><p><strong>WAEC 2025 Mathematics - Question 21</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q21_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 21" style="max-width:100%;height:auto;"></p><p>Find the roots of the equation y = <span contenteditable="false" class="math-editor-rendered" data-latex="3 \\times ^{2} + \\times - 7"></span>.</p>',
    question_category = 'Algebra',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.4 and -1.7', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.0 and -1.9', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.0 and -1.2', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.1 and -1.3', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 22 - Question 22
SET @source_marker := 'WAEC 2025 Mathematics - Item 22 - Question 22';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 22 - Question 22</small></p><p><strong>WAEC 2025 Mathematics - Question 22</strong></p><p>The diagonals AC and BD of a rhombus ABCD are 16 cm and 12 cm long, respectively. Calculate the area of the rhombus.</p>',
    question_category = 'Geometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '96 cm²', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '36 cm²', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '48 cm²', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '24 cm²', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 23 - Question 23
SET @source_marker := 'WAEC 2025 Mathematics - Item 23 - Question 23';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 23 - Question 23</small></p><p><strong>WAEC 2025 Mathematics - Question 23</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q23_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 23" style="max-width:100%;height:auto;"></p><p>A cylindrical container, closed at both ends, has a radius of 7 cm and a height of 5 cm. Use this information to answer the questions below. Find the total surface area of the container.</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '35 cm²', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '528 cm²', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '154 cm²', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '220 cm²', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 24 - Question 24
SET @source_marker := 'WAEC 2025 Mathematics - Item 24 - Question 24';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 24 - Question 24</small></p><p><strong>WAEC 2025 Mathematics - Question 24</strong></p><p>Find the total surface area of a solid circular cone with base radius 3 cm and slant height 4 cm. [Take <span contenteditable="false" class="math-editor-rendered" data-latex="\\pi"></span> = <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{22}{7}"></span>]</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '66 cm²', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="37\\frac{5}{7}"></span>cm²', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="75\\frac{3}{7}"></span>cm²', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="78\\frac{6}{7}"></span>cm²', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 25 - Question 25
SET @source_marker := 'WAEC 2025 Mathematics - Item 25 - Question 25';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 25 - Question 25</small></p><p><strong>WAEC 2025 Mathematics - Question 25</strong></p><p>A water tank of height <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span> m has a square base of side <span contenteditable="false" class="math-editor-rendered" data-latex="1\\frac{1}{2}"></span>m. If it is filled with water from a water tanker holding 1500 litres, how many litres of water are left in the water tanker? [1000 litres = 1 m³]</p>',
    question_category = 'Commercial Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '375 litres', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3750 litres', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '37.5 litres', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '37500 litres', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 26 - Question 26
SET @source_marker := 'WAEC 2025 Mathematics - Item 26 - Question 26';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 26 - Question 26</small></p><p><strong>WAEC 2025 Mathematics - Question 26</strong></p><p>A hollow sphere has a volume of k cm³ and a surface area of k cm². Calculate the diameter of the sphere.</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3 cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9 cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'More information needed.', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6 cm', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 27 - Question 27
SET @source_marker := 'WAEC 2025 Mathematics - Item 27 - Question 27';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 27 - Question 27</small></p><p><strong>WAEC 2025 Mathematics - Question 27</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q27_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 27" style="max-width:100%;height:auto;"></p><p>The diagram above shows a cone with the dimensions of its frustum indicated. Calculate the height of the cone.</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '24 cm', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15 cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8 cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12 cm', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 28 - Question 28
SET @source_marker := 'WAEC 2025 Mathematics - Item 28 - Question 28';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 28 - Question 28</small></p><p><strong>WAEC 2025 Mathematics - Question 28</strong></p><p>The positions of two countries, P and Q, are (<span contenteditable="false" class="math-editor-rendered" data-latex="15^{\\circ}"></span>N, <span contenteditable="false" class="math-editor-rendered" data-latex="12^{\\circ}"></span>E) and (<span contenteditable="false" class="math-editor-rendered" data-latex="65^{\\circ}"></span>N, <span contenteditable="false" class="math-editor-rendered" data-latex="12^{\\circ}"></span>E) respectively. What is the difference in latitude?</p>',
    question_category = 'Bearing and Earth Geometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="50^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="104^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="80^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="100^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 29 - Question 29
SET @source_marker := 'WAEC 2025 Mathematics - Item 29 - Question 29';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 29 - Question 29</small></p><p><strong>WAEC 2025 Mathematics - Question 29</strong></p><p>A <span contenteditable="false" class="math-editor-rendered" data-latex="120^{\\circ}"></span> sector of a circle of radius 21 cm is bent to form a cone. What is the base radius of the cone?</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="3\\frac{1}{2}"></span> cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="10\\frac{1}{2}"></span> cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14 cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7 cm', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 30 - Question 30
SET @source_marker := 'WAEC 2025 Mathematics - Item 30 - Question 30';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 30 - Question 30</small></p><p><strong>WAEC 2025 Mathematics - Question 30</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q30_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 30" style="max-width:100%;height:auto;"></p><p>A cylindrical container, closed at both ends, has a radius of 7 cm and a height of 5 cm. Use this information to answer the questions below. What is the volume of the container?</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '770 cm³', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '35 cm³', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '220 cm³', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '154 cm³', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 31 - Question 31
SET @source_marker := 'WAEC 2025 Mathematics - Item 31 - Question 31';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 31 - Question 31</small></p><p><strong>WAEC 2025 Mathematics - Question 31</strong></p><p>If <span contenteditable="false" class="math-editor-rendered" data-latex="log_{10} \\times = 2.3675"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="log_{10}y = 2.9738"></span>, what is the value of x + y, correct to three significant figures</p>',
    question_category = 'Number and Logarithms',
    explanation = 'The source appears to omit barred-log notation. Answer uses the barred characteristic interpretation, giving x + y ≈ 0.117.'
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.118', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.903', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.117', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.944', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 32 - Question 32
SET @source_marker := 'WAEC 2025 Mathematics - Item 32 - Question 32';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 32 - Question 32</small></p><p><strong>WAEC 2025 Mathematics - Question 32</strong></p><p>The angle of a sector of a circle is <span contenteditable="false" class="math-editor-rendered" data-latex="108 ^{\\circ}"></span>. If the radius of the circle is <span contenteditable="false" class="math-editor-rendered" data-latex="3\\frac{1}{2}"></span>cm, find the perimeter of the sector.</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="6\\frac{3}{5}"></span> cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="7\\frac{2}{10}"></span> cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="6\\frac{4}{5}"></span> cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="13\\frac{3}{5}"></span> cm', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 33 - Question 33
SET @source_marker := 'WAEC 2025 Mathematics - Item 33 - Question 33';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 33 - Question 33</small></p><p><strong>WAEC 2025 Mathematics - Question 33</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q33_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 33" style="max-width:100%;height:auto;"></p><p>In the diagram above, AO is perpendicular to OB. Find x.</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="15^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="22.5^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="7.5^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="30^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 34 - Question 34
SET @source_marker := 'WAEC 2025 Mathematics - Item 34 - Question 34';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 34 - Question 34</small></p><p><strong>WAEC 2025 Mathematics - Question 34</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q34_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 34" style="max-width:100%;height:auto;"></p><p>In the diagram above. O is the centre of the circle and |BD| = |DC|. If ∠DCB = <span contenteditable="false" class="math-editor-rendered" data-latex="35^{\\circ}"></span>, find ∠BAO</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="25^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="30^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="20^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="35^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 35 - Question 35
SET @source_marker := 'WAEC 2025 Mathematics - Item 35 - Question 35';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 35 - Question 35</small></p><p><strong>WAEC 2025 Mathematics - Question 35</strong></p><p>Which of the following angles is an exterior angle of a regular polygon?</p>',
    question_category = 'Geometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="95^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="78^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="72^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="85^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 36 - Question 36
SET @source_marker := 'WAEC 2025 Mathematics - Item 36 - Question 36';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 36 - Question 36</small></p><p><strong>WAEC 2025 Mathematics - Question 36</strong></p><p>The locus of a point which is equidistant from two given fixed points is the</p>',
    question_category = 'Geometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Angle bisector of the straight lines joining them.', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Parallel line to the straight line joining them.', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Perpendicular to the straight line joining them.', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Perpendicular bisector of the straight line joining them.', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 37 - Question 37
SET @source_marker := 'WAEC 2025 Mathematics - Item 37 - Question 37';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 37 - Question 37</small></p><p><strong>WAEC 2025 Mathematics - Question 37</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q37_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 37" style="max-width:100%;height:auto;"></p><p>In the diagram,|AB| = 12cm, |AE| = 8cm, |DC| = 9cm and BD||DC. Find the length of EC.</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6cm', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9cm', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 38 - Question 38
SET @source_marker := 'WAEC 2025 Mathematics - Item 38 - Question 38';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 38 - Question 38</small></p><p><strong>WAEC 2025 Mathematics - Question 38</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q38_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 38" style="max-width:100%;height:auto;"></p><p>In the diagram above, PQ is parallel to TU, ∠PQR = <span contenteditable="false" class="math-editor-rendered" data-latex="50^{\\circ}"></span>, ∠QRS = <span contenteditable="false" class="math-editor-rendered" data-latex="86^{\\circ}"></span>, and ∠STU = <span contenteditable="false" class="math-editor-rendered" data-latex="64^{\\circ}"></span>. Calculate the value of x</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="100^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="108^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="120^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="136^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 39 - Question 39
SET @source_marker := 'WAEC 2025 Mathematics - Item 39 - Question 39';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 39 - Question 39</small></p><p><strong>WAEC 2025 Mathematics - Question 39</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q39_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 39" style="max-width:100%;height:auto;"></p><p>In the diagram below, AB||DC, the bisectors of ∠BAC and ∠ACD meet at E. Find the value of ∠AEC</p>',
    question_category = 'Mensuration',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="45^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="60^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="30^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="90^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 40 - Question 40
SET @source_marker := 'WAEC 2025 Mathematics - Item 40 - Question 40';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 40 - Question 40</small></p><p><strong>WAEC 2025 Mathematics - Question 40</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q40_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 40" style="max-width:100%;height:auto;"></p><p>In the diagram above, AB||CD. What is the size of the angle marked x?</p>',
    question_category = 'Geometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="93^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="77^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="103^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="62^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 41 - Question 41
SET @source_marker := 'WAEC 2025 Mathematics - Item 41 - Question 41';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 41 - Question 41</small></p><p><strong>WAEC 2025 Mathematics - Question 41</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q41_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 41" style="max-width:100%;height:auto;"></p><p>In the diagram above, the value of angles b + c is</p>',
    question_category = 'Geometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="a^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="90^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="180^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="d^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 42 - Question 42
SET @source_marker := 'WAEC 2025 Mathematics - Item 42 - Question 42';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 42 - Question 42</small></p><p><strong>WAEC 2025 Mathematics - Question 42</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q42_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 42" style="max-width:100%;height:auto;"></p><p>In △ABC above, BC is produced to D, |AB| = |AC|, and ∠BAC = <span contenteditable="false" class="math-editor-rendered" data-latex="50^{\\circ}"></span>. Find ∠ACD.</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="115^{\\circ}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="65^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="60^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="50^{\\circ}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 43 - Question 43
SET @source_marker := 'WAEC 2025 Mathematics - Item 43 - Question 43';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 43 - Question 43</small></p><p><strong>WAEC 2025 Mathematics - Question 43</strong></p><p><img src="../uploads/question_bank/waec_2025_mathematics/Q43_diagram.png" alt="Diagram for WAEC 2025 Mathematics Question 43" style="max-width:100%;height:auto;"></p><p>In the diagram above, ∠PRQ = <span contenteditable="false" class="math-editor-rendered" data-latex="90^{\\circ}"></span>, ∠QPR = <span contenteditable="false" class="math-editor-rendered" data-latex="30^{\\circ}"></span> and |PQ| = 10 cm. Find y</p>',
    question_category = 'Mathematics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4cm', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5cm', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3cm', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 44 - Question 44
SET @source_marker := 'WAEC 2025 Mathematics - Item 44 - Question 44';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 44 - Question 44</small></p><p><strong>WAEC 2025 Mathematics - Question 44</strong></p><p>What is the mode of the numbers 8, 10, 9, 9, 10, 8, 11, 8, 10, 9, 8, and 14?</p>',
    question_category = 'Statistics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 45 - Question 45
SET @source_marker := 'WAEC 2025 Mathematics - Item 45 - Question 45';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 45 - Question 45</small></p><p><strong>WAEC 2025 Mathematics - Question 45</strong></p><p>The bearing of two points Q and R from a point P are <span contenteditable="false" class="math-editor-rendered" data-latex="030^{\\circ}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="120^{\\circ}"></span>, respectively. If |PQ| = 12 m and |PR| = 5 m, find the distance QR.</p>',
    question_category = 'Bearing and Earth Geometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11 m', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '13 m', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9 m', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7 m', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 46 - Question 46
SET @source_marker := 'WAEC 2025 Mathematics - Item 46 - Question 46';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 46 - Question 46</small></p><p><strong>WAEC 2025 Mathematics - Question 46</strong></p><p>Without using tables, find the value of: <span contenteditable="false" class="math-editor-rendered" data-latex="sin 20^{\\circ}/cos 70^{\\circ} + cos 25^{\\circ}/sin 65^{\\circ}"></span></p>',
    question_category = 'Trigonometry',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 47 - Question 47
SET @source_marker := 'WAEC 2025 Mathematics - Item 47 - Question 47';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 47 - Question 47</small></p><p><strong>WAEC 2025 Mathematics - Question 47</strong></p><p>The mean of 20 observations in an experiment is 4. If the observed largest value is 23, find the mean of the remaining observations.</p>',
    question_category = 'Statistics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.60', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.85', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 1, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 48 - Question 48
SET @source_marker := 'WAEC 2025 Mathematics - Item 48 - Question 48';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 48 - Question 48</small></p><p><strong>WAEC 2025 Mathematics - Question 48</strong></p><p>Two fair dice are tossed together once. Find the probability that the sum of the outcomes is at least 10.</p>',
    question_category = 'Probability',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{6}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{12}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{4}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{36}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 49 - Question 49
SET @source_marker := 'WAEC 2025 Mathematics - Item 49 - Question 49';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 49 - Question 49</small></p><p><strong>WAEC 2025 Mathematics - Question 49</strong></p><p>Find the median of the following numbers: 2.64, 2.50, 2.72, 2.91, and 2.35</p>',
    question_category = 'Statistics',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.50', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.64', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.91', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.72', 0, 0
WHERE @question_id IS NOT NULL;

-- MathQuill repair: WAEC 2025 Mathematics - Item 50 - Question 50
SET @source_marker := 'WAEC 2025 Mathematics - Item 50 - Question 50';
SET @question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
UPDATE question_bank
SET question = '<p><small>Source: WAEC 2025 Mathematics - Item 50 - Question 50</small></p><p><strong>WAEC 2025 Mathematics - Question 50</strong></p><p>From a box containing 2 red, 6 white, and 5 black balls, a ball is randomly selected. What is the probability that the selected ball is black?</p>',
    question_category = 'Probability',
    explanation = ''
WHERE id = @question_id;
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{13}"></span>', 1, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{11}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{2}{13}"></span>', 0, 0
WHERE @question_id IS NOT NULL;
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{6}"></span>', 0, 0
WHERE @question_id IS NOT NULL;

COMMIT;

SELECT
    COUNT(*) AS waec_2025_mathematics_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @waec_exam_body_id
  AND subject_id = @mathematics_subject_id
  AND exam_year = 2025
  AND question LIKE '%WAEC 2025 Mathematics - Item%';
