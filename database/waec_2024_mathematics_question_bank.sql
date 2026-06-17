-- WAEC 2024 Mathematics objective questions for the global question bank.
-- Generated from: q_bank/WAEC_2024_Mathematics_Questions.json
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

DROP PROCEDURE IF EXISTS ss360_require_waec_2024_mathematics_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_waec_2024_mathematics_refs()
BEGIN
    IF @waec_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WAEC exam body could not be resolved.';
    END IF;
    IF @mathematics_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mathematics subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_waec_2024_mathematics_refs();
DROP PROCEDURE ss360_require_waec_2024_mathematics_refs;

START TRANSACTION;

-- WAEC 2024 Mathematics - Item 1 - Question 1
SET @source_marker := 'WAEC 2024 Mathematics - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 1 - Question 1</small></p><p><strong>WAEC 2024 Mathematics - Question 1</strong></p><p>Multiply 3.4 x 10⁻⁵ by 7.1 x 10⁸ and leave the answer in standard form.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Number and Logarithms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2.414 x 10²', 0, 0),
(@question_id, '2.414 x 10³', 0, 0),
(@question_id, '2.414 x 10⁴', 1, 0),
(@question_id, '2.414 x 10⁵', 0, 0);

-- WAEC 2024 Mathematics - Item 2 - Question 2
SET @source_marker := 'WAEC 2024 Mathematics - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 2 - Question 2</small></p><p><strong>WAEC 2024 Mathematics - Question 2</strong></p><p>Given that P = {p: 1&lt; p &lt; 20}, where p is an integer and R = {r : 0 ≤ r ≤ 25, where r is a multiple of 4}. Find P ∩ R</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Sets', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '{4, 8, 10, 16}', 0, 0),
(@question_id, '{4, 8, 12, 16}', 1, 0),
(@question_id, '{4, 8, 12, 16, 20}', 0, 0),
(@question_id, '{4, 8, 12, 16, 20, 24}', 0, 0);

-- WAEC 2024 Mathematics - Item 3 - Question 3
SET @source_marker := 'WAEC 2024 Mathematics - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 3 - Question 3</small></p><p><strong>WAEC 2024 Mathematics - Question 3</strong></p><p>The first term of an Arithmetic Progression (A.P) is 2 and the last term is 29. If the common difference is 3, how many terms are in the A.P.?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Sequences and Series', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '8', 0, 0),
(@question_id, '9', 0, 0),
(@question_id, '10', 1, 0),
(@question_id, '11', 0, 0);

-- WAEC 2024 Mathematics - Item 4 - Question 4
SET @source_marker := 'WAEC 2024 Mathematics - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 4 - Question 4</small></p><p><strong>WAEC 2024 Mathematics - Question 4</strong></p><p>Express in index form: <span contenteditable="false" class="math-editor-rendered" data-latex="log_x a + log_y a = 3"></span></p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Logarithms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'x + y = 3', 0, 0),
(@question_id, 'xy = 3', 0, 0),
(@question_id, 'xy = a³', 1, 0),
(@question_id, 'x + y = a³', 0, 0);

-- WAEC 2024 Mathematics - Item 5 - Question 5
SET @source_marker := 'WAEC 2024 Mathematics - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 5 - Question 5</small></p><p><strong>WAEC 2024 Mathematics - Question 5</strong></p><p>Simplify: <span contenteditable="false" class="math-editor-rendered" data-latex="(2p - q)^2 - (p + q)^2"></span></p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '3p(p - 2q)', 1, 0),
(@question_id, '2p(p - 3q)', 0, 0),
(@question_id, '3p(2p - q)', 0, 0),
(@question_id, '2p(3p - q)', 0, 0);

-- WAEC 2024 Mathematics - Item 6 - Question 6
SET @source_marker := 'WAEC 2024 Mathematics - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 6 - Question 6</small></p><p><strong>WAEC 2024 Mathematics - Question 6</strong></p><p>If <span contenteditable="false" class="math-editor-rendered" data-latex="(3 - 4\\sqrt{2})(1 + 3\\sqrt{2}) = a + b\\sqrt{2}"></span>, find the value of <span contenteditable="false" class="math-editor-rendered" data-latex="b"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Surds', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '-5', 0, 0),
(@question_id, '5', 1, 0),
(@question_id, '-21', 0, 0),
(@question_id, '21', 0, 0);

-- WAEC 2024 Mathematics - Item 7 - Question 7
SET @source_marker := 'WAEC 2024 Mathematics - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 7 - Question 7</small></p><p><strong>WAEC 2024 Mathematics - Question 7</strong></p><p>Find the time for which ₦1,250.00 will amount to ₦2,031.25 at 12.5% per annum simple interest.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Commercial Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2 years', 0, 0),
(@question_id, '3 years', 0, 0),
(@question_id, '4 years', 0, 0),
(@question_id, '5 years', 1, 0);

-- WAEC 2024 Mathematics - Item 8 - Question 8
SET @source_marker := 'WAEC 2024 Mathematics - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 8 - Question 8</small></p><p><strong>WAEC 2024 Mathematics - Question 8</strong></p><p>If <span contenteditable="false" class="math-editor-rendered" data-latex="log_3(2x - 1) = 5"></span>, find the value of <span contenteditable="false" class="math-editor-rendered" data-latex="x"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Logarithms', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '8', 0, 0),
(@question_id, '16', 0, 0),
(@question_id, '64', 0, 0),
(@question_id, '122', 1, 0);

-- WAEC 2024 Mathematics - Item 9 - Question 9
SET @source_marker := 'WAEC 2024 Mathematics - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 9 - Question 9</small></p><p><strong>WAEC 2024 Mathematics - Question 9</strong></p><p>The population of a town increases by 3% every year. In the year 2000, the population was 3000. Find the population in the year 2003.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Commercial Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '3,182', 0, 0),
(@question_id, '3,278', 1, 0),
(@question_id, '6,591', 0, 0),
(@question_id, '7,515', 0, 0);

-- WAEC 2024 Mathematics - Item 10 - Question 10
SET @source_marker := 'WAEC 2024 Mathematics - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 10 - Question 10</small></p><p><strong>WAEC 2024 Mathematics - Question 10</strong></p><p>A trader gave a change of ₦ 540.00 instead of ₦ 570.00 to a customer. Calculate the percentage error.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Approximation and Percentage', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{19}"></span>%', 1, 0),
(@question_id, '5<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{9}"></span>%', 0, 0),
(@question_id, '5<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{7}{19}"></span>%', 0, 0),
(@question_id, '5<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{7}{9}"></span>%', 0, 0);

-- WAEC 2024 Mathematics - Item 11 - Question 11
SET @source_marker := 'WAEC 2024 Mathematics - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 11 - Question 11</small></p><p><strong>WAEC 2024 Mathematics - Question 11</strong></p><p>The interior angle of a regular polygon is 168°. Find the number of sides of the polygon.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '24', 0, 0),
(@question_id, '30', 1, 0),
(@question_id, '15', 0, 0),
(@question_id, '12', 0, 0);

-- WAEC 2024 Mathematics - Item 12 - Question 12
SET @source_marker := 'WAEC 2024 Mathematics - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 12 - Question 12</small></p><p><strong>WAEC 2024 Mathematics - Question 12</strong></p><p>If <span contenteditable="false" class="math-editor-rendered" data-latex="3x - 2y = -5"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="x + 2y = 9"></span>, find the value of <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{x-y}{x+y}"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Algebraic Fractions', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{3}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{3}{5}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{-3}{5}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{-5}{3}"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 13 - Question 13
SET @source_marker := 'WAEC 2024 Mathematics - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 13 - Question 13</small></p><p><strong>WAEC 2024 Mathematics - Question 13</strong></p><p>A variable <span contenteditable="false" class="math-editor-rendered" data-latex="W"></span> varies partly as <span contenteditable="false" class="math-editor-rendered" data-latex="M"></span> and partly inversely as <span contenteditable="false" class="math-editor-rendered" data-latex="P"></span>. Which of the following correctly represents the relation with <span contenteditable="false" class="math-editor-rendered" data-latex="k_1"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="k_2"></span> as constants?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Variation', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="W = \\frac{k_1M}{k_2P}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="W = \\frac{(k_1 + k_2)M}{P}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="W = k_1M + \\frac{k_2}{P}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="W = (k_1 + k_2)M + P"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 14 - Question 14
SET @source_marker := 'WAEC 2024 Mathematics - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 14 - Question 14</small></p><p><strong>WAEC 2024 Mathematics - Question 14</strong></p><p>A cylindrical metallic barrel of height 2.5 m and radius 0.245 m is closed at one end. Find, correct to one decimal place, the total surface area of the barrel. Take <span contenteditable="false" class="math-editor-rendered" data-latex="\\pi = \\frac{22}{7}"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2.1 m²', 0, 0),
(@question_id, '3.5 m²', 0, 0),
(@question_id, '4.0 m²', 1, 0),
(@question_id, '9.4 m²', 0, 0);

-- WAEC 2024 Mathematics - Item 15 - Question 15
SET @source_marker := 'WAEC 2024 Mathematics - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 15 - Question 15</small></p><p><strong>WAEC 2024 Mathematics - Question 15</strong></p><p>Make <span contenteditable="false" class="math-editor-rendered" data-latex="R"></span> the subject of the relation <span contenteditable="false" class="math-editor-rendered" data-latex="V = \\pi l(R^2 - r^2)"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Change of Subject', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="R = \\sqrt{\\frac{V}{\\pi l} + r^2}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="R = \\sqrt{\\frac{V}{\\pi l} - r^2}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="R = \\sqrt{V - \\pi lr^2}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="R = \\sqrt{V + \\pi lr^2}"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 16 - Question 16
SET @source_marker := 'WAEC 2024 Mathematics - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 16 - Question 16</small></p><p><strong>WAEC 2024 Mathematics - Question 16</strong></p><p>Consider the following statements: m = Edna is respectful n = Edna is brilliant, If m ⇒ n, which of the following is valid?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Logic', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '¬n ⇒ ¬m.', 1, 0),
(@question_id, '¬m ⇒ ¬n.', 0, 0),
(@question_id, 'n ⇒ ¬m.', 0, 0),
(@question_id, 'm ⇒ n.', 0, 0);

-- WAEC 2024 Mathematics - Item 17 - Question 17
SET @source_marker := 'WAEC 2024 Mathematics - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 17 - Question 17</small></p><p><strong>WAEC 2024 Mathematics - Question 17</strong></p><p>A number is added to both the numerator and the denominator of the fraction <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{8}"></span>. If the result is <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span>, find the number.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '3', 0, 0),
(@question_id, '4', 0, 0),
(@question_id, '5', 0, 0),
(@question_id, '6', 1, 0);

-- WAEC 2024 Mathematics - Item 18 - Question 18
SET @source_marker := 'WAEC 2024 Mathematics - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 18 - Question 18</small></p><p><strong>WAEC 2024 Mathematics - Question 18</strong></p><p>Gifty, Justina, and Frank shared 60 oranges in the ratio 5: 3: 7 respectively. How many oranges did Justina receive?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Ratio', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '16', 0, 0),
(@question_id, '12', 1, 0),
(@question_id, '20', 0, 0),
(@question_id, '28', 0, 0);

-- WAEC 2024 Mathematics - Item 19 - Question 19
SET @source_marker := 'WAEC 2024 Mathematics - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 19 - Question 19</small></p><p><strong>WAEC 2024 Mathematics - Question 19</strong></p><p>Find the quadratic equation whose roots are <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{2}{3}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="-1"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Quadratic Equations', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="3x^2 - x - 2 = 0"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="3x^2 + x + 2 = 0"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="3x^2 + x - 2 = 0"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="3x^2 + x - 1 = 0"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 20 - Question 20
SET @source_marker := 'WAEC 2024 Mathematics - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 20 - Question 20</small></p><p><strong>WAEC 2024 Mathematics - Question 20</strong></p><p>A piece of rod of length 44 m is cut to form a rectangular shape such that the ratio of the length to the breadth is 7: 4. Find the breadth.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '8m', 1, 0),
(@question_id, '14m', 0, 0),
(@question_id, '16m', 0, 0),
(@question_id, '24m', 0, 0);

-- WAEC 2024 Mathematics - Item 21 - Question 21
SET @source_marker := 'WAEC 2024 Mathematics - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 21 - Question 21</small></p><p><strong>WAEC 2024 Mathematics - Question 21</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q21_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 21" style="max-width:100%;height:auto;"></p><p>In the diagram above, <span contenteditable="false" class="math-editor-rendered" data-latex="\\overline{MN} \\parallel \\overline{KL}"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="\\overline{ML}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="\\overline{KN}"></span> intersect at <span contenteditable="false" class="math-editor-rendered" data-latex="X"></span>. If <span contenteditable="false" class="math-editor-rendered" data-latex="|MN| = 12\\text{ cm}"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="|KL| = 9\\text{ cm}"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="|MX| = 10\\text{ cm}"></span> and the area of <span contenteditable="false" class="math-editor-rendered" data-latex="\\triangle MXN"></span> is <span contenteditable="false" class="math-editor-rendered" data-latex="16\\text{ cm}^2"></span>, calculate the area of <span contenteditable="false" class="math-editor-rendered" data-latex="\\triangle LXK"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '9cm²', 1, 0),
(@question_id, '8cm²', 0, 0),
(@question_id, '10cm²', 0, 0),
(@question_id, '12cm²', 0, 0);

-- WAEC 2024 Mathematics - Item 22 - Question 22
SET @source_marker := 'WAEC 2024 Mathematics - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 22 - Question 22</small></p><p><strong>WAEC 2024 Mathematics - Question 22</strong></p><p>A ladder 15 m long leans against a vertical pole, making an angle of 72° with the horizontal. Calculate, correct to one decimal place, the distance between the foot of the ladder and the pole.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Trigonometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '15.8 m', 0, 0),
(@question_id, '14.3 m', 0, 0),
(@question_id, '4.9 m', 0, 0),
(@question_id, '4.6 m', 1, 0);

-- WAEC 2024 Mathematics - Item 23 - Question 23
SET @source_marker := 'WAEC 2024 Mathematics - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 23 - Question 23</small></p><p><strong>WAEC 2024 Mathematics - Question 23</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q23_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 23" style="max-width:100%;height:auto;"></p><p>In the diagram above, <span contenteditable="false" class="math-editor-rendered" data-latex="O"></span> is the centre of the circle. If <span contenteditable="false" class="math-editor-rendered" data-latex="|OA| = 25\\text{ cm}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="|AB| = 40\\text{ cm}"></span>, find <span contenteditable="false" class="math-editor-rendered" data-latex="|OH|"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Circle Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '15 cm', 1, 0),
(@question_id, '20 cm', 0, 0),
(@question_id, '25 cm', 0, 0),
(@question_id, '30 cm', 0, 0);

-- WAEC 2024 Mathematics - Item 24 - Question 24
SET @source_marker := 'WAEC 2024 Mathematics - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 24 - Question 24</small></p><p><strong>WAEC 2024 Mathematics - Question 24</strong></p><p>A car valued at ₦ 600,000.00 depreciates by 10% each year. What will be the value of the car at the end of two years?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Commercial Mathematics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '₦ 120,000.00', 0, 0),
(@question_id, '₦ 480,000.00', 0, 0),
(@question_id, '₦ 486,000.00', 1, 0),
(@question_id, '₦ 540,000.00', 0, 0);

-- WAEC 2024 Mathematics - Item 25 - Question 25
SET @source_marker := 'WAEC 2024 Mathematics - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 25 - Question 25</small></p><p><strong>WAEC 2024 Mathematics - Question 25</strong></p><p>Given that P is 25 m on a bearing of 330° from Q, how far south of P is Q?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Bearings', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '25.2 m', 0, 0),
(@question_id, '21.7 m', 1, 0),
(@question_id, '19.8 m', 0, 0),
(@question_id, '18.5 m', 0, 0);

-- WAEC 2024 Mathematics - Item 26 - Question 26
SET @source_marker := 'WAEC 2024 Mathematics - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 26 - Question 26</small></p><p><strong>WAEC 2024 Mathematics - Question 26</strong></p><p>The length and breadth of a cuboid are 15 cm and 8 cm respectively. If the volume of the cuboid is 1560 cm³, calculate the total surface area.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '976cm²', 0, 0),
(@question_id, '838cm²', 1, 0),
(@question_id, '792cm²', 0, 0),
(@question_id, '746cm²', 0, 0);

-- WAEC 2024 Mathematics - Item 27 - Question 27
SET @source_marker := 'WAEC 2024 Mathematics - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 27 - Question 27</small></p><p><strong>WAEC 2024 Mathematics - Question 27</strong></p><p>The number <span contenteditable="false" class="math-editor-rendered" data-latex="1621_x"></span> was subtracted from <span contenteditable="false" class="math-editor-rendered" data-latex="6244_x"></span>. If the result was <span contenteditable="false" class="math-editor-rendered" data-latex="4323_x"></span>, find <span contenteditable="false" class="math-editor-rendered" data-latex="x"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Number Bases', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Seven', 1, 0),
(@question_id, 'Eight', 0, 0),
(@question_id, 'Nine', 0, 0),
(@question_id, 'Ten', 0, 0);

-- WAEC 2024 Mathematics - Item 28 - Question 28
SET @source_marker := 'WAEC 2024 Mathematics - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 28 - Question 28</small></p><p><strong>WAEC 2024 Mathematics - Question 28</strong></p><p>Factorize completely: <span contenteditable="false" class="math-editor-rendered" data-latex="27x^2 - 48y^2"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '3(3x + 4y)(3x - 4y)', 1, 0),
(@question_id, '3(3x + 4y)(3x + 4y)', 0, 0),
(@question_id, '3(9x - 16y)(9x + 16y)', 0, 0),
(@question_id, '3(9x - 16y)(9x - 16y)', 0, 0);

-- WAEC 2024 Mathematics - Item 29 - Question 29
SET @source_marker := 'WAEC 2024 Mathematics - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 29 - Question 29</small></p><p><strong>WAEC 2024 Mathematics - Question 29</strong></p><p>For what values of <span contenteditable="false" class="math-editor-rendered" data-latex="x"></span> is <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{x-3}{4} + \\frac{x+1}{8} \\ge 2"></span>?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Linear Inequalities', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="x \\ge 5"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="x \\ge 6"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="x \\ge 7"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="x \\ge 8"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 30 - Question 30
SET @source_marker := 'WAEC 2024 Mathematics - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 30 - Question 30</small></p><p><strong>WAEC 2024 Mathematics - Question 30</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q30_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 30" style="max-width:100%;height:auto;"></p><p>In the diagram above, <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle SQR = 52^{\\circ}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle PRT = 16^{\\circ}"></span>. Find the value of the angle marked <span contenteditable="false" class="math-editor-rendered" data-latex="y"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Circle Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="64^{\\circ}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="68^{\\circ}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="112^{\\circ}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="128^{\\circ}"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 31 - Question 31
SET @source_marker := 'WAEC 2024 Mathematics - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 31 - Question 31</small></p><p><strong>WAEC 2024 Mathematics - Question 31</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q31_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 31" style="max-width:100%;height:auto;"></p><p>In the diagram above, <span contenteditable="false" class="math-editor-rendered" data-latex="JKL"></span> is a tangent to the circle <span contenteditable="false" class="math-editor-rendered" data-latex="GHIK"></span> at <span contenteditable="false" class="math-editor-rendered" data-latex="K"></span>. Find the value of the angle marked <span contenteditable="false" class="math-editor-rendered" data-latex="x"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Circle Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '93°', 0, 0),
(@question_id, '55°', 1, 0),
(@question_id, '42°', 0, 0),
(@question_id, '23°', 0, 0);

-- WAEC 2024 Mathematics - Item 32 - Question 32
SET @source_marker := 'WAEC 2024 Mathematics - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 32 - Question 32</small></p><p><strong>WAEC 2024 Mathematics - Question 32</strong></p><p>A cone and a cylinder are of equal volume. The base radius of the cone is twice the radius of the cylinder. What is the ratio of the height of the cylinder to that of the cone?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5: 4', 0, 0),
(@question_id, '4: 3', 1, 0),
(@question_id, '3: 2', 0, 0),
(@question_id, '3: 4', 0, 0);

-- WAEC 2024 Mathematics - Item 33 - Question 33
SET @source_marker := 'WAEC 2024 Mathematics - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 33 - Question 33</small></p><p><strong>WAEC 2024 Mathematics - Question 33</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q33_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 33" style="max-width:100%;height:auto;"></p><p>Find, correct to the nearest ​​​​​​whole number, the value of h in the diagram above.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Trigonometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '15 m', 0, 0),
(@question_id, '22 m', 0, 0),
(@question_id, '23 m', 1, 0),
(@question_id, '18 m', 0, 0);

-- WAEC 2024 Mathematics - Item 34 - Question 34
SET @source_marker := 'WAEC 2024 Mathematics - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 34 - Question 34</small></p><p><strong>WAEC 2024 Mathematics - Question 34</strong></p><p>The gradient of the line joining the points P(2, -8) and Q(1, y) is -4. Find the value of y</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Coordinate Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2', 0, 0),
(@question_id, '4', 0, 0),
(@question_id, '-4', 1, 0),
(@question_id, '-3', 0, 0);

-- WAEC 2024 Mathematics - Item 35 - Question 35
SET @source_marker := 'WAEC 2024 Mathematics - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 35 - Question 35</small></p><p><strong>WAEC 2024 Mathematics - Question 35</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q35_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 35" style="max-width:100%;height:auto;"></p><p>In the diagram above, <span contenteditable="false" class="math-editor-rendered" data-latex="PQ \\parallel RS"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle WYZ = 44^{\\circ}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle WXY = 50^{\\circ}"></span>. Find <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle WTX"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Angles and Parallel Lines', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '65°', 0, 0),
(@question_id, '68°', 0, 0),
(@question_id, '86°', 1, 0),
(@question_id, '90°', 0, 0);

-- WAEC 2024 Mathematics - Item 36 - Question 36
SET @source_marker := 'WAEC 2024 Mathematics - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 36 - Question 36</small></p><p><strong>WAEC 2024 Mathematics - Question 36</strong></p><p>The perimeter of a rectangular garden is 90 m. If the width is 7 m less than the length, find the length of the garden.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '19 m', 0, 0),
(@question_id, '23 m', 0, 0),
(@question_id, '24 m', 0, 0),
(@question_id, '26 m', 1, 0);

-- WAEC 2024 Mathematics - Item 37 - Question 37
SET @source_marker := 'WAEC 2024 Mathematics - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 37 - Question 37</small></p><p><strong>WAEC 2024 Mathematics - Question 37</strong></p><p>Four of the angles of a hexagon sum up to <span contenteditable="false" class="math-editor-rendered" data-latex="420^{\\circ}"></span>. If the remaining angles are equal, find the value of each of the angles.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Polygons', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="60^{\\circ}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="100^{\\circ}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="120^{\\circ}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="150^{\\circ}"></span>', 1, 0);

-- WAEC 2024 Mathematics - Item 38 - Question 38
SET @source_marker := 'WAEC 2024 Mathematics - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 38 - Question 38</small></p><p><strong>WAEC 2024 Mathematics - Question 38</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q38_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 38" style="max-width:100%;height:auto;"></p><p>Find the value of x in the diagram above.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '120°', 0, 0),
(@question_id, '100°', 0, 0),
(@question_id, '60°', 1, 0),
(@question_id, '150°', 0, 0);

-- WAEC 2024 Mathematics - Item 39 - Question 39
SET @source_marker := 'WAEC 2024 Mathematics - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 39 - Question 39</small></p><p><strong>WAEC 2024 Mathematics - Question 39</strong></p><p>The following are the masses (in kg) of members in a club: 59, 44, 53, 49, 57, 40, 48, and 50. Calculate the mean mass.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Statistics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '44 kg', 0, 0),
(@question_id, '50 kg', 1, 0),
(@question_id, '40 kg', 0, 0),
(@question_id, '53 kg', 0, 0);

-- WAEC 2024 Mathematics - Item 40 - Question 40
SET @source_marker := 'WAEC 2024 Mathematics - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 40 - Question 40</small></p><p><strong>WAEC 2024 Mathematics - Question 40</strong></p><p>The following are the masses (in kg) of members in a club: 59, 44, 53, 49, 57, 40, 48, and 50. Calculate the variance of the distribution.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Statistics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '35', 1, 0),
(@question_id, '36', 0, 0),
(@question_id, '40', 0, 0),
(@question_id, '50', 0, 0);

-- WAEC 2024 Mathematics - Item 41 - Question 41
SET @source_marker := 'WAEC 2024 Mathematics - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 41 - Question 41</small></p><p><strong>WAEC 2024 Mathematics - Question 41</strong></p><p>Two opposite sides of a rectangle are (5x + 3) m and (2x + 9) m. If an adjacent side is (6x - 7) m, find in m², the area of the rectangle.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Algebra', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '45', 0, 0),
(@question_id, '65', 1, 0),
(@question_id, '125', 0, 0),
(@question_id, '165', 0, 0);

-- WAEC 2024 Mathematics - Item 42 - Question 42
SET @source_marker := 'WAEC 2024 Mathematics - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 42 - Question 42</small></p><p><strong>WAEC 2024 Mathematics - Question 42</strong></p><p>A die is tossed once. Find the probability of getting a prime number.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Probability', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{6}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{3}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{2}{3}"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 43 - Question 43
SET @source_marker := 'WAEC 2024 Mathematics - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 43 - Question 43</small></p><p><strong>WAEC 2024 Mathematics - Question 43</strong></p><p>The area of a sector of a circle with radius 7 cm is <span contenteditable="false" class="math-editor-rendered" data-latex="51.3\\text{ cm}^2"></span>. Calculate, correct to the nearest whole number, the angle of the sector. Take <span contenteditable="false" class="math-editor-rendered" data-latex="\\pi = \\frac{22}{7}"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Mensuration', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="60^{\\circ}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="120^{\\circ}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="150^{\\circ}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="150^{\\circ}"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 44 - Question 44
SET @source_marker := 'WAEC 2024 Mathematics - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 44 - Question 44</small></p><p><strong>WAEC 2024 Mathematics - Question 44</strong></p><p>A cliff on the bank of a river 87 m high. A boat on the river is 22 m away from the cliff. Calculate, correct to the nearest degree, the angle of depression of the boat from the top of the cliff.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Trigonometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '76°', 1, 0),
(@question_id, '64°', 0, 0),
(@question_id, '36°', 0, 0),
(@question_id, '24°', 0, 0);

-- WAEC 2024 Mathematics - Item 45 - Question 45
SET @source_marker := 'WAEC 2024 Mathematics - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 45 - Question 45</small></p><p><strong>WAEC 2024 Mathematics - Question 45</strong></p><p><img src="../uploads/question_bank/waec_2024_mathematics/Q45_diagram.png" alt="Diagram for WAEC 2024 Mathematics Question 45" style="max-width:100%;height:auto;"></p><p>In the diagram, <span contenteditable="false" class="math-editor-rendered" data-latex="\\overline{TU}"></span> is a tangent to the circle <span contenteditable="false" class="math-editor-rendered" data-latex="SPQR"></span> at <span contenteditable="false" class="math-editor-rendered" data-latex="P"></span>. If <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle PTS = 44^{\\circ}"></span> and <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle SQP = 35^{\\circ}"></span>, find <span contenteditable="false" class="math-editor-rendered" data-latex="\\angle PST"></span>.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Circle Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '101°', 1, 0),
(@question_id, '125°', 0, 0),
(@question_id, '130°', 0, 0),
(@question_id, '135°', 0, 0);

-- WAEC 2024 Mathematics - Item 46 - Question 46
SET @source_marker := 'WAEC 2024 Mathematics - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 46 - Question 46</small></p><p><strong>WAEC 2024 Mathematics - Question 46</strong></p><p>The probability that Amaka will pass an examination is <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{3}{7}"></span> and that Bala will pass is <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{4}{9}"></span>. Find the probability that both will pass the examination.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Probability', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{2}{21}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{4}{21}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{5}{21}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{9}{21}"></span>', 0, 0);

-- WAEC 2024 Mathematics - Item 47 - Question 47
SET @source_marker := 'WAEC 2024 Mathematics - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 47 - Question 47</small></p><p><strong>WAEC 2024 Mathematics - Question 47</strong></p><p>Which of the following points lies on the line 3x - 8y = 11?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Coordinate Geometry', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '(1, 1)', 0, 0),
(@question_id, '(1, -1)', 1, 0),
(@question_id, '(-1, 1)', 0, 0),
(@question_id, '(-1, -1)', 0, 0);

-- WAEC 2024 Mathematics - Item 48 - Question 48
SET @source_marker := 'WAEC 2024 Mathematics - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 48 - Question 48</small></p><p><strong>WAEC 2024 Mathematics - Question 48</strong></p><p>Find the range of the following set of numbers: 28, 29, 39, 38, 33, 37, 26, 20, 15, and 25.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Statistics', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '22', 0, 0),
(@question_id, '24', 1, 0),
(@question_id, '25', 0, 0),
(@question_id, '27', 0, 0);

-- WAEC 2024 Mathematics - Item 49 - Question 49
SET @source_marker := 'WAEC 2024 Mathematics - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 49 - Question 49</small></p><p><strong>WAEC 2024 Mathematics - Question 49</strong></p><p>The fourth and eighth terms of an Arithmetic Progression are 16 and 40 respectively. Find the common difference.</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Sequences and Series', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '- 6', 0, 0),
(@question_id, '6', 1, 0),
(@question_id, '-2', 0, 0),
(@question_id, '2', 0, 0);

-- WAEC 2024 Mathematics - Item 50 - Question 50
SET @source_marker := 'WAEC 2024 Mathematics - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @mathematics_subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2024 Mathematics - Item 50 - Question 50</small></p><p><strong>WAEC 2024 Mathematics - Question 50</strong></p><p>For what values of <span contenteditable="false" class="math-editor-rendered" data-latex="y"></span> is <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{y + 2}{8y^2 - 10y + 3}"></span> not defined?</p>', @mathematics_subject_id, 0, 'exam_body', @waec_exam_body_id, 2024, 0, 'Medium', 'SSS3', '', 'Algebraic Fractions', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{-3}{4}"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{-3}{4}"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{-1}{2}"></span>', 0, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{3}{4}"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{1}{2}"></span>', 1, 0),
(@question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{3}{4}"></span>, <span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{-1}{2}"></span>', 0, 0);

COMMIT;

SELECT COUNT(*) AS imported_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @waec_exam_body_id
  AND subject_id = @mathematics_subject_id
  AND exam_year = 2024
  AND question LIKE '%WAEC 2024 Mathematics - Item%';

SELECT COUNT(*) AS imported_options
FROM question_bank_options
WHERE question_id IN (
    SELECT id
    FROM question_bank
    WHERE source_type = 'exam_body'
      AND exam_body_id = @waec_exam_body_id
      AND subject_id = @mathematics_subject_id
      AND exam_year = 2024
      AND question LIKE '%WAEC 2024 Mathematics - Item%'
);

SELECT COUNT(*) AS bad_option_groups
FROM (
    SELECT qb.id
    FROM question_bank qb
    LEFT JOIN question_bank_options qbo ON qbo.question_id = qb.id
    WHERE qb.source_type = 'exam_body'
      AND qb.exam_body_id = @waec_exam_body_id
      AND qb.subject_id = @mathematics_subject_id
      AND qb.exam_year = 2024
      AND qb.question LIKE '%WAEC 2024 Mathematics - Item%'
    GROUP BY qb.id
    HAVING COUNT(qbo.id) <> 4 OR SUM(qbo.answer = 1) <> 1
) invalid_groups;
