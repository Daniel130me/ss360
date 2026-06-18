-- Measures of Central Tendency and Range topic questions for the global question bank.
-- Generated from: q_bank/measures of central tendency.md
-- Expected payload: 70 questions and 280 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    class_id INT NOT NULL,
    topic_name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS question_bank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question LONGTEXT NOT NULL,
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
    KEY idx_qb_topic_lookup (school_id, deleted, review_status, subject_id, topic_id, difficulty),
    KEY idx_qb_topic (topic_id)
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

SET @mathematics_subject_id := (SELECT id FROM subjects WHERE subject IN ('Mathematics', 'Maths', 'Math') ORDER BY FIELD(subject, 'Mathematics', 'Maths', 'Math'), id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_measures_central_tendency_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_measures_central_tendency_refs()
BEGIN
    IF @mathematics_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mathematics subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_measures_central_tendency_refs();
DROP PROCEDURE ss360_require_measures_central_tendency_refs;

INSERT INTO topics (subject_id, class_id, topic_name)
SELECT @mathematics_subject_id, 0, 'Measures of Central Tendency and Range'
WHERE NOT EXISTS (
    SELECT 1 FROM topics
    WHERE subject_id = @mathematics_subject_id
      AND class_id = 0
      AND topic_name = 'Measures of Central Tendency and Range'
);

SET @measures_topic_id := (
    SELECT id FROM topics
    WHERE subject_id = @mathematics_subject_id
      AND topic_name = 'Measures of Central Tendency and Range'
    ORDER BY CASE WHEN class_id = 0 THEN 0 ELSE 1 END, id ASC
    LIMIT 1
);

START TRANSACTION;

-- Measures of Central Tendency and Range Topic Bank - Item 1
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 1</small></p><p><strong>Measures of Central Tendency and Range - Question 1</strong></p><p>Find the mean of 4, 6, 8, 10 and 12.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Mean', '(4 + 6 + 8 + 10 + 12) ÷ 5 = 40 ÷ 5 = 8.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '7', 0, 0),
(@question_id, '8', 1, 0),
(@question_id, '9', 0, 0),
(@question_id, '10', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 2
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 2</small></p><p><strong>Measures of Central Tendency and Range - Question 2</strong></p><p>Find the median of 5, 7, 9, 11 and 13.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Median', 'The middle value of the ordered data is 9.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '7', 0, 0),
(@question_id, '8', 0, 0),
(@question_id, '9', 1, 0),
(@question_id, '11', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 3
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 3</small></p><p><strong>Measures of Central Tendency and Range - Question 3</strong></p><p>Find the mode of 3, 5, 5, 7, 8.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Mode', '5 occurs more often than any other value.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '3', 0, 0),
(@question_id, '5', 1, 0),
(@question_id, '7', 0, 0),
(@question_id, '8', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 4
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 4</small></p><p><strong>Measures of Central Tendency and Range - Question 4</strong></p><p>Find the range of 8, 10, 12, 15 and 18.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Range', 'Range = 18 − 8 = 10.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '8', 0, 0),
(@question_id, '9', 0, 0),
(@question_id, '10', 1, 0),
(@question_id, '26', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 5
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 5</small></p><p><strong>Measures of Central Tendency and Range - Question 5</strong></p><p>The marks scored by a student are 15, 18, 20, 22 and 25. Find the mean mark.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Mean', '(15 + 18 + 20 + 22 + 25) ÷ 5 = 100 ÷ 5 = 20.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '18', 0, 0),
(@question_id, '19', 0, 0),
(@question_id, '20', 1, 0),
(@question_id, '21', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 6
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 6</small></p><p><strong>Measures of Central Tendency and Range - Question 6</strong></p><p>Find the median of 2, 4, 6, 8, 10, 12.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Median', 'Median = (6 + 8) ÷ 2 = 7.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '6', 0, 0),
(@question_id, '7', 1, 0),
(@question_id, '8', 0, 0),
(@question_id, '9', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 7
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 7</small></p><p><strong>Measures of Central Tendency and Range - Question 7</strong></p><p>What is the mode of 9, 8, 7, 9, 6, 5, 9?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Mode', '9 appears three times, more than any other value.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5', 0, 0),
(@question_id, '7', 0, 0),
(@question_id, '8', 0, 0),
(@question_id, '9', 1, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 8
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 8</small></p><p><strong>Measures of Central Tendency and Range - Question 8</strong></p><p>Find the range of the data: 14, 17, 19, 20, 22.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Range', 'Range = 22 − 14 = 8.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '6', 0, 0),
(@question_id, '7', 0, 0),
(@question_id, '8', 1, 0),
(@question_id, '9', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 9
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 9</small></p><p><strong>Measures of Central Tendency and Range - Question 9</strong></p><p>Which measure of central tendency is the value that occurs most frequently in a data set?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Mixed Measures', 'The mode is the value with the highest frequency.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mean', 0, 0),
(@question_id, 'Median', 0, 0),
(@question_id, 'Mode', 1, 0),
(@question_id, 'Range', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 10
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 10</small></p><p><strong>Measures of Central Tendency and Range - Question 10</strong></p><p>Which measure is obtained by subtracting the smallest value from the largest value in a data set?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Easy', 'JSS2/JSS3', '', 'Mixed Measures', 'Range = Largest value − Smallest value.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mean', 0, 0),
(@question_id, 'Median', 0, 0),
(@question_id, 'Mode', 0, 0),
(@question_id, 'Range', 1, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 11
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 11</small></p><p><strong>Measures of Central Tendency and Range - Question 11</strong></p><p>The mean of the numbers 12, 15, 18, 21 and x is 18. Find the value of x.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mean', 'Total = 18 × 5 = 90. Sum of known numbers = 66. Therefore, x = 90 − 66 = 24.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '20', 0, 0),
(@question_id, '22', 0, 0),
(@question_id, '24', 1, 0),
(@question_id, '25', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 12
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 12</small></p><p><strong>Measures of Central Tendency and Range - Question 12</strong></p><p>The average score of 8 students is 14. What is the total of their scores?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mean', 'Total score = Mean × Number of students = 14 × 8 = 112.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '98', 0, 0),
(@question_id, '108', 0, 0),
(@question_id, '112', 1, 0),
(@question_id, '116', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 13
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 13</small></p><p><strong>Measures of Central Tendency and Range - Question 13</strong></p><p>Find the median of 16, 12, 18, 20, 14, 22 and 24.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Median', 'Ordered data: 12, 14, 16, 18, 20, 22, 24. The middle value is 18.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '14', 0, 0),
(@question_id, '16', 1, 0),
(@question_id, '18', 0, 0),
(@question_id, '20', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 14
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 14</small></p><p><strong>Measures of Central Tendency and Range - Question 14</strong></p><p>A student found the median of 11, 7, 15, 13 and 9 as 15. Why is the answer incorrect?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Error Detection', 'The data should first be arranged: 7, 9, 11, 13, 15. The median is 11.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The mean should have been calculated.', 0, 0),
(@question_id, 'The data should first be arranged in order.', 1, 0),
(@question_id, 'The largest value is always the median.', 0, 0),
(@question_id, 'The mode should be found first.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 15
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 15</small></p><p><strong>Measures of Central Tendency and Range - Question 15</strong></p><p>The shoe sizes of 10 students are 38, 39, 40, 39, 41, 39, 40, 42, 40, 39. What is the mode?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mode', '39 appears four times, more than any other value.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '38', 0, 0),
(@question_id, '39', 1, 0),
(@question_id, '40', 0, 0),
(@question_id, '41', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 16
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 16</small></p><p><strong>Measures of Central Tendency and Range - Question 16</strong></p><p>The temperatures recorded over five days were 28°C, 31°C, 30°C, 35°C and 29°C. Find the range.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Range', 'Range = 35 − 28 = 7°C.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5°C', 0, 0),
(@question_id, '6°C', 0, 0),
(@question_id, '7°C', 1, 0),
(@question_id, '8°C', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 17
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 17</small></p><p><strong>Measures of Central Tendency and Range - Question 17</strong></p><p>The table shows the scores of students. Score: 2 3 4 5 Frequency: 1 3 4 2 What is the mode?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'The highest frequency is 4, corresponding to a score of 4.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2', 0, 0),
(@question_id, '3', 0, 0),
(@question_id, '4', 1, 0),
(@question_id, '5', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 18
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 18</small></p><p><strong>Measures of Central Tendency and Range - Question 18</strong></p><p>The table shows the number of books read by students. Books: 1 2 3 4 Frequency: 2 5 3 2 How many students were surveyed?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'Total students = 2 + 5 + 3 + 2 = 12.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '10', 0, 0),
(@question_id, '11', 0, 0),
(@question_id, '12', 1, 0),
(@question_id, '13', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 19
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 19</small></p><p><strong>Measures of Central Tendency and Range - Question 19</strong></p><p>Five friends shared ₦2,500 equally. What was the mean amount received by each friend?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Word Problem', '₦2,500 ÷ 5 = ₦500.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '₦450', 0, 0),
(@question_id, '₦500', 1, 0),
(@question_id, '₦550', 0, 0),
(@question_id, '₦600', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 20
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 20</small></p><p><strong>Measures of Central Tendency and Range - Question 20</strong></p><p>The data set is 6, 8, 8, 9, 10, 11 and 14. Which statement is correct?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mixed Measures', 'Median = 9. Mode = 8. Range = 14 - 6 = 8. Mean = 66 ÷ 7 ≈ 9.43. The mode and range are both 8, so option C is correct.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mean = Median', 0, 0),
(@question_id, 'Median = Mode', 0, 0),
(@question_id, 'Mode = Range', 1, 0),
(@question_id, 'Mean = Range', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 21
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 21</small></p><p><strong>Measures of Central Tendency and Range - Question 21</strong></p><p>The mean age of 6 students is 15 years. If five of the students are 14, 15, 16, 15 and 13 years old, what is the age of the sixth student?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mean', 'Total age = 15 × 6 = 90. Sum of known ages = 73. Sixth age = 90 − 73 = 17 years.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '15 years', 0, 0),
(@question_id, '16 years', 0, 0),
(@question_id, '17 years', 1, 0),
(@question_id, '18 years', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 22
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 22</small></p><p><strong>Measures of Central Tendency and Range - Question 22</strong></p><p>The mean of five numbers is 24. If another number, 30, is added to the data set, what is the new mean?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mean', 'Original total = 24 × 5 = 120. New total = 120 + 30 = 150. New mean = 150 ÷ 6 = 25.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '24', 0, 0),
(@question_id, '25', 1, 0),
(@question_id, '26', 0, 0),
(@question_id, '27', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 23
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 23</small></p><p><strong>Measures of Central Tendency and Range - Question 23</strong></p><p>Find the median of the data set: 21, 15, 17, 19, 13, 25, 23.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Median', 'Ordered data: 13, 15, 17, 19, 21, 23, 25. The middle value is 19.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '17', 0, 0),
(@question_id, '18', 0, 0),
(@question_id, '19', 1, 0),
(@question_id, '21', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 24
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 24</small></p><p><strong>Measures of Central Tendency and Range - Question 24</strong></p><p>Find the mode of the data: 12, 10, 9, 12, 8, 10, 12, 9.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mode', '12 appears three times, more than any other value.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '9', 0, 0),
(@question_id, '10', 0, 0),
(@question_id, '11', 0, 0),
(@question_id, '12', 1, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 25
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 25</small></p><p><strong>Measures of Central Tendency and Range - Question 25</strong></p><p>The heights (in cm) of five students are 145, 148, 152, 150 and 147. Find the range.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Range', 'Range = 152 − 145 = 7 cm.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5 cm', 0, 0),
(@question_id, '6 cm', 0, 0),
(@question_id, '7 cm', 1, 0),
(@question_id, '8 cm', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 26
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 26</small></p><p><strong>Measures of Central Tendency and Range - Question 26</strong></p><p>The table shows the number of goals scored by a football team. Goals: 0 1 2 3 Frequency: 2 5 4 1 What is the total number of matches played?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'Total matches = 2 + 5 + 4 + 1 = 12.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '10', 0, 0),
(@question_id, '11', 0, 0),
(@question_id, '12', 1, 0),
(@question_id, '13', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 27
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 27</small></p><p><strong>Measures of Central Tendency and Range - Question 27</strong></p><p>The table below shows the scores obtained by students. Score: 5 6 7 8 Frequency: 3 4 5 2 Which score is the mode?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'The highest frequency is 5, corresponding to the score 7.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5', 0, 0),
(@question_id, '6', 0, 0),
(@question_id, '7', 1, 0),
(@question_id, '8', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 28
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 28</small></p><p><strong>Measures of Central Tendency and Range - Question 28</strong></p><p>A trader sold 20, 25, 30, 35 and 40 bags of rice on five market days. What was the average number of bags sold per day?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Word Problem', '(20 + 25 + 30 + 35 + 40) ÷ 5 = 150 ÷ 5 = 30.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '28', 0, 0),
(@question_id, '29', 0, 0),
(@question_id, '30', 1, 0),
(@question_id, '31', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 29
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 29</small></p><p><strong>Measures of Central Tendency and Range - Question 29</strong></p><p>The scores of five students are 45, 45, 50, 55 and 80. Which measure of central tendency is most affected by the unusually high score of 80?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Data Interpretation', 'The mean is affected more by extreme values than the median or mode.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Median', 0, 0),
(@question_id, 'Mode', 0, 0),
(@question_id, 'Range', 0, 0),
(@question_id, 'Mean', 1, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 30
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 30</small></p><p><strong>Measures of Central Tendency and Range - Question 30</strong></p><p>A student calculated the range of 18, 25, 20, 27 and 21 as 27 − 20 = 7. What mistake did the student make?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Error Detection', 'Range = Largest − Smallest = 27 − 18 = 9, not 27 − 20.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The student used the median instead of the largest value.', 0, 0),
(@question_id, 'The student failed to use the smallest value.', 1, 0),
(@question_id, 'The student should have calculated the mean first.', 0, 0),
(@question_id, 'The student should have arranged the data before subtracting.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 31
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 31</small></p><p><strong>Measures of Central Tendency and Range - Question 31</strong></p><p>The mean of 7, 9, 12, 14 and x is 11. Find x.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mean', 'Total = 11 × 5 = 55. Sum of known values = 42. Therefore, x = 55 − 42 = 13.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '11', 0, 0),
(@question_id, '12', 0, 0),
(@question_id, '13', 1, 0),
(@question_id, '14', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 32
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 32</small></p><p><strong>Measures of Central Tendency and Range - Question 32</strong></p><p>The table shows the scores of some students. Score: 2 4 6 8 Frequency: 3 2 4 1 Find the mean score.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'Total score = 2×3 + 4×2 + 6×4 + 8×1 = 46. Total frequency = 10. Mean = 46 ÷ 10 = 4.6.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '4.6', 0, 0),
(@question_id, '4.8', 1, 0),
(@question_id, '5.0', 0, 0),
(@question_id, '5.2', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 33
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 33</small></p><p><strong>Measures of Central Tendency and Range - Question 33</strong></p><p>Find the median of 18, 12, 20, 16, 14 and 22.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Median', 'Ordered data: 12, 14, 16, 18, 20, 22. Median = (16 + 18) ÷ 2 = 17.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '15', 0, 0),
(@question_id, '16', 0, 0),
(@question_id, '17', 1, 0),
(@question_id, '18', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 34
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 34</small></p><p><strong>Measures of Central Tendency and Range - Question 34</strong></p><p>The marks obtained by students are 6, 7, 8, 7, 9, 8, 10 and 11. Which statement is correct?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mode', 'Both 7 and 8 occur twice, more than any other value. Therefore, the data is bimodal.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The data has no mode.', 0, 0),
(@question_id, 'The mode is 7 only.', 0, 0),
(@question_id, 'The mode is 8 only.', 0, 0),
(@question_id, 'The data is bimodal.', 1, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 35
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 35</small></p><p><strong>Measures of Central Tendency and Range - Question 35</strong></p><p>The range of the data 9, 12, 15, 18 and x is 14. If x is the largest value, find x.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Range', 'Range = Largest − Smallest. Since the smallest value is 9, x − 9 = 14. Therefore, x = 23.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '20', 0, 0),
(@question_id, '21', 0, 0),
(@question_id, '22', 0, 0),
(@question_id, '23', 1, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 36
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 36</small></p><p><strong>Measures of Central Tendency and Range - Question 36</strong></p><p>A class recorded the following number of absentees in five days: 3, 5, 4, 6 and 2. What was the mean number of absentees per day?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Word Problem', '(3 + 5 + 4 + 6 + 2) ÷ 5 = 20 ÷ 5 = 4.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '3', 0, 0),
(@question_id, '4', 1, 0),
(@question_id, '5', 0, 0),
(@question_id, '6', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 37
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 37</small></p><p><strong>Measures of Central Tendency and Range - Question 37</strong></p><p>The data set 10, 10, 11, 12, 50 contains an extreme value. Which measure gives a better idea of the typical value?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Data Interpretation', 'The median is less affected by the extreme value 50 than the mean.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mean', 0, 0),
(@question_id, 'Median', 1, 0),
(@question_id, 'Range', 0, 0),
(@question_id, 'Total', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 38
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 38</small></p><p><strong>Measures of Central Tendency and Range - Question 38</strong></p><p>The table shows the number of children in some families. Children: 1 2 3 4 Frequency: 2 6 5 1 What is the modal number of children?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'The highest frequency is 6, corresponding to 2 children.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '1', 0, 0),
(@question_id, '2', 1, 0),
(@question_id, '3', 0, 0),
(@question_id, '4', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 39
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 39</small></p><p><strong>Measures of Central Tendency and Range - Question 39</strong></p><p>For the data 4, 6, 6, 8, 10, find the median and mode respectively.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mixed Measures', 'The middle value is 6, so the median is 6. The most frequent value is also 6.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '6 and 6', 1, 0),
(@question_id, '6 and 8', 0, 0),
(@question_id, '8 and 6', 0, 0),
(@question_id, '8 and 10', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 40
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 40</small></p><p><strong>Measures of Central Tendency and Range - Question 40</strong></p><p>A student found the mean of 5, 10, 15 and 20 as 50. What mistake did the student most likely make?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Error Detection', 'The sum is 50, but the mean is 50 ÷ 4 = 12.5.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The student added the values but did not divide by the number of values.', 1, 0),
(@question_id, 'The student arranged the data wrongly.', 0, 0),
(@question_id, 'The student subtracted the smallest value from the largest value.', 0, 0),
(@question_id, 'The student used the middle value.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 41
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 41</small></p><p><strong>Measures of Central Tendency and Range - Question 41</strong></p><p>The table shows the scores of students. Score: 10 20 30 40 Frequency: 2 3 4 1 Find the mean score.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'Total score = 10×2 + 20×3 + 30×4 + 40×1 = 240. Total frequency = 10. Mean = 240 ÷ 10 = 24.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '22', 0, 0),
(@question_id, '24', 1, 0),
(@question_id, '25', 0, 0),
(@question_id, '26', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 42
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 42</small></p><p><strong>Measures of Central Tendency and Range - Question 42</strong></p><p>The mean of six numbers is 18. If one number, 30, is removed, the mean of the remaining five numbers is</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mean', 'Original total = 18 × 6 = 108. New total = 108 − 30 = 78. New mean = 78 ÷ 5 = 15.6.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '14.4', 0, 0),
(@question_id, '15.6', 1, 0),
(@question_id, '16', 0, 0),
(@question_id, '17', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 43
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 43</small></p><p><strong>Measures of Central Tendency and Range - Question 43</strong></p><p>The median of 4, 6, 8, x and 12 is 8. Which value of x makes the statement true?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Median', 'If x = 9, the ordered data are 4, 6, 8, 9, 12. The middle value is 8.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5', 0, 0),
(@question_id, '7', 0, 0),
(@question_id, '9', 1, 0),
(@question_id, '14', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 44
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 44</small></p><p><strong>Measures of Central Tendency and Range - Question 44</strong></p><p>Which of the following data sets has no mode?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mode', 'In 4, 5, 6, 7, 8, no value occurs more than once.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2, 3, 3, 4, 5', 0, 0),
(@question_id, '4, 5, 6, 7, 8', 1, 0),
(@question_id, '6, 6, 7, 8, 9', 0, 0),
(@question_id, '1, 2, 2, 3, 3', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 45
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 45</small></p><p><strong>Measures of Central Tendency and Range - Question 45</strong></p><p>The range of a data set is 18. If the smallest value is 7, what is the largest value?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Range', 'Range = Largest − Smallest. Largest = 18 + 7 = 25.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '11', 0, 0),
(@question_id, '18', 0, 0),
(@question_id, '25', 1, 0),
(@question_id, '26', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 46
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 46</small></p><p><strong>Measures of Central Tendency and Range - Question 46</strong></p><p>A student scored 62, 70, 68, 75 and 80 in five tests. What is the mean score?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Word Problem', 'Mean = (62 + 70 + 68 + 75 + 80) ÷ 5 = 355 ÷ 5 = 71.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '69', 0, 0),
(@question_id, '70', 0, 0),
(@question_id, '71', 1, 0),
(@question_id, '72', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 47
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 47</small></p><p><strong>Measures of Central Tendency and Range - Question 47</strong></p><p>Two pupils have the same mean score, but one pupil has a larger range. What does the larger range show?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Data Interpretation', 'A larger range shows a wider spread between the highest and lowest values.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The pupil has more consistent scores.', 0, 0),
(@question_id, 'The pupil has less variation in scores.', 0, 0),
(@question_id, 'The pupil has more variation in scores.', 1, 0),
(@question_id, 'The pupil has no mode.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 48
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 48</small></p><p><strong>Measures of Central Tendency and Range - Question 48</strong></p><p>The table shows the number of pencils owned by students. Pencils: 1 2 3 4 5 Frequency: 1 3 5 4 2 What is the mode?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'The highest frequency is 5, corresponding to 3 pencils.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2', 0, 0),
(@question_id, '3', 1, 0),
(@question_id, '4', 0, 0),
(@question_id, '5', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 49
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 49</small></p><p><strong>Measures of Central Tendency and Range - Question 49</strong></p><p>For the data 3, 5, 5, 7 and 10, find the mean and mode respectively.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mixed Measures', 'Mean = (3 + 5 + 5 + 7 + 10) ÷ 5 = 30 ÷ 5 = 6. Mode = 5.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '5 and 5', 0, 0),
(@question_id, '6 and 5', 1, 0),
(@question_id, '6 and 7', 0, 0),
(@question_id, '7 and 5', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 50
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 50</small></p><p><strong>Measures of Central Tendency and Range - Question 50</strong></p><p>A student says the mode of 2, 4, 4, 6, 6, 8 is 4 only. What is wrong with the answer?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Error Detection', 'Both 4 and 6 occur twice, so the data is bimodal.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The mode should be 6 only.', 0, 0),
(@question_id, 'The data has no mode.', 0, 0),
(@question_id, 'The data has two modes: 4 and 6.', 1, 0),
(@question_id, 'The median should be used instead.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 51
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 51</small></p><p><strong>Measures of Central Tendency and Range - Question 51</strong></p><p>Find the median of 32, 28, 35, 30, 40, 38, 34 and 36.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Median', 'Ordered data: 28, 30, 32, 34, 35, 36, 38, 40. Median = (34 + 35) ÷ 2 = 34.5.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '33', 0, 0),
(@question_id, '34', 0, 0),
(@question_id, '35', 1, 0),
(@question_id, '36', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 52
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 52</small></p><p><strong>Measures of Central Tendency and Range - Question 52</strong></p><p>The mean of four numbers is 16. Three of the numbers are 12, 18 and 20. Find the fourth number.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Mean', 'Total = 16 × 4 = 64. Sum of known values = 50. Fourth number = 64 − 50 = 14.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '12', 0, 0),
(@question_id, '14', 1, 0),
(@question_id, '16', 0, 0),
(@question_id, '18', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 53
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 53</small></p><p><strong>Measures of Central Tendency and Range - Question 53</strong></p><p>A data set has values 11, 15, 18, 20 and 24. If 24 is replaced by 30, what is the new range?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Range', 'New range = 30 − 11 = 19.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '13', 0, 0),
(@question_id, '15', 0, 0),
(@question_id, '18', 0, 0),
(@question_id, '19', 1, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 54
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 54</small></p><p><strong>Measures of Central Tendency and Range - Question 54</strong></p><p>Which measure is best used to identify the most popular shoe size among students?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Data Interpretation', 'The most popular value is the value that occurs most often, which is the mode.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mean', 0, 0),
(@question_id, 'Median', 0, 0),
(@question_id, 'Mode', 1, 0),
(@question_id, 'Range', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 55
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 55</small></p><p><strong>Measures of Central Tendency and Range - Question 55</strong></p><p>The table shows the number of siblings of some students. Siblings: 0 1 2 3 Frequency: 3 5 4 2 Find the total number of students.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Medium', 'JSS2/JSS3', '', 'Frequency Table', 'Total number of students = 3 + 5 + 4 + 2 = 14.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '12', 0, 0),
(@question_id, '13', 0, 0),
(@question_id, '14', 1, 0),
(@question_id, '15', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 56
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 56</small></p><p><strong>Measures of Central Tendency and Range - Question 56</strong></p><p>The mean of 8 numbers is 12. If one number is changed from 6 to 22, what is the new mean?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Mean', 'Original total = 12 × 8 = 96. Increase = 22 − 6 = 16. New total = 112. New mean = 112 ÷ 8 = 14.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '13', 0, 0),
(@question_id, '14', 1, 0),
(@question_id, '15', 0, 0),
(@question_id, '16', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 57
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 57</small></p><p><strong>Measures of Central Tendency and Range - Question 57</strong></p><p>The median of 6, 8, x, 12 and 15 is 10. If the data are arranged in ascending order, find x.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Median', 'For five ordered values, the median is the third value. Therefore, x = 10.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '9', 0, 0),
(@question_id, '10', 1, 0),
(@question_id, '11', 0, 0),
(@question_id, '12', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 58
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 58</small></p><p><strong>Measures of Central Tendency and Range - Question 58</strong></p><p>The table shows the scores of students. Score: 1 2 3 4 5 Frequency: 2 3 4 3 2 Find the mean score.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Frequency Table', 'Total score = 1×2 + 2×3 + 3×4 + 4×3 + 5×2 = 42. Total frequency = 14. Mean = 42 ÷ 14 = 3.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2.5', 0, 0),
(@question_id, '3', 1, 0),
(@question_id, '3.5', 0, 0),
(@question_id, '4', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 59
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 59</small></p><p><strong>Measures of Central Tendency and Range - Question 59</strong></p><p>For the data 4, 6, 6, 8, 10, 12, find the median, mode and range respectively.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Mixed Measures', 'Median = (6 + 8) ÷ 2 = 7. Mode = 6. Range = 12 − 4 = 8.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '7, 6, 8', 1, 0),
(@question_id, '6, 6, 8', 0, 0),
(@question_id, '7, 8, 6', 0, 0),
(@question_id, '8, 6, 7', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 60
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 60</small></p><p><strong>Measures of Central Tendency and Range - Question 60</strong></p><p>A class has scores 20, 22, 23, 24, 25 and 80. Which statement is most correct?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Data Interpretation', 'The extreme value 80 affects the mean and range strongly, but the median remains more representative of the typical score.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The mean gives the best typical score because of 80.', 0, 0),
(@question_id, 'The median is less affected by the score 80.', 1, 0),
(@question_id, 'The mode must be 80.', 0, 0),
(@question_id, 'The range is not affected by 80.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 61
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 61</small></p><p><strong>Measures of Central Tendency and Range - Question 61</strong></p><p>The mean of 10 numbers is 18. If one of the numbers, 27, is omitted, the mean of the remaining numbers is 17. How many numbers remain after the omission?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Mean', 'Original total = 18 × 10 = 180. After removing 27, the new total is 153. Since one number was removed from 10 numbers, 9 numbers remain, and 153 ÷ 9 = 17.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '8', 0, 0),
(@question_id, '9', 1, 0),
(@question_id, '10', 0, 0),
(@question_id, '11', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 62
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 62</small></p><p><strong>Measures of Central Tendency and Range - Question 62</strong></p><p>The table shows the number of books read by students. Books: 1 2 3 4 5 Frequency: 2 4 6 3 1 Find the median number of books read.</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Frequency Table', 'Total frequency = 16. The 8th and 9th observations both fall in the value 3, so the median is 3.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2', 0, 0),
(@question_id, '2.5', 0, 0),
(@question_id, '3', 1, 0),
(@question_id, '4', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 63
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 63</small></p><p><strong>Measures of Central Tendency and Range - Question 63</strong></p><p>A data set has exactly two modes. What is such a data set called?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Mode', 'A data set with two modes is called bimodal.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Uniform', 0, 0),
(@question_id, 'Bimodal', 1, 0),
(@question_id, 'Trimodal', 0, 0),
(@question_id, 'Symmetrical', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 64
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 64</small></p><p><strong>Measures of Central Tendency and Range - Question 64</strong></p><p>The range of a data set is 24. If every value in the data set is increased by 7, what is the new range?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Range', 'Adding the same number to every observation does not change the range.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '17', 0, 0),
(@question_id, '24', 1, 0),
(@question_id, '31', 0, 0),
(@question_id, '38', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 65
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 65</small></p><p><strong>Measures of Central Tendency and Range - Question 65</strong></p><p>Two classes have the same mean examination score. Class A has a range of 8, while Class B has a range of 22. What can be concluded?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Data Interpretation', 'A larger range indicates greater variation in the scores.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Class A&#039;s scores are more spread out.', 0, 0),
(@question_id, 'Class B&#039;s scores are more consistent.', 0, 0),
(@question_id, 'Class B&#039;s scores are more spread out.', 1, 0),
(@question_id, 'Both classes have identical score distributions.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 66
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 66</small></p><p><strong>Measures of Central Tendency and Range - Question 66</strong></p><p>The mean of five numbers is 16. Four of the numbers are 11, 15, 18 and 20. What is the fifth number?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Mean', 'Total = 16 × 5 = 80. Sum of known numbers = 64. Fifth number = 80 − 64 = 16.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '14', 0, 0),
(@question_id, '15', 0, 0),
(@question_id, '16', 1, 0),
(@question_id, '17', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 67
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 67</small></p><p><strong>Measures of Central Tendency and Range - Question 67</strong></p><p>A student claims that adding the same number to every observation changes the range. Which statement is correct?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Error Detection', 'Since both the largest and smallest values increase by the same amount, their difference remains unchanged.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The student is correct because the largest value changes.', 0, 0),
(@question_id, 'The student is correct because the smallest value changes.', 0, 0),
(@question_id, 'The student is incorrect because both the largest and smallest values increase equally.', 1, 0),
(@question_id, 'The range always becomes zero.', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 68
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 68</small></p><p><strong>Measures of Central Tendency and Range - Question 68</strong></p><p>The table shows students&#039; scores. Score: 2 4 6 8 Frequency: 1 3 5 1 Which score is the median?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Frequency Table', 'There are 10 observations. The 5th and 6th observations are both 6, so the median is 6.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '2', 0, 0),
(@question_id, '4', 0, 0),
(@question_id, '6', 1, 0),
(@question_id, '8', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 69
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 69</small></p><p><strong>Measures of Central Tendency and Range - Question 69</strong></p><p>For the data set 5, 7, 8, 8, 10, 13 and 20, which pair of measures is equal?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Mixed Measures', 'Median = 8 and mode = 8. Mean = 71 ÷ 7 ≈ 10.14 and range = 20 - 5 = 15. Therefore, the median and mode are equal.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mean and median', 0, 0),
(@question_id, 'Median and mode', 1, 0),
(@question_id, 'Mean and range', 0, 0),
(@question_id, 'Mode and range', 0, 0);

-- Measures of Central Tendency and Range Topic Bank - Item 70
SET @source_marker := 'Measures of Central Tendency and Range Topic Bank - Item 70';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @measures_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Measures of Central Tendency and Range Topic Bank - Item 70</small></p><p><strong>Measures of Central Tendency and Range - Question 70</strong></p><p>A school wants to know the shoe size most commonly worn by JSS3 students so that enough sports shoes can be ordered. Which measure should be used?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @measures_topic_id, 'Hard', 'JSS2/JSS3', '', 'Application', 'The mode identifies the most frequently occurring shoe size.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mean', 0, 0),
(@question_id, 'Median', 0, 0),
(@question_id, 'Mode', 1, 0),
(@question_id, 'Range', 0, 0);

COMMIT;

SELECT COUNT(*) AS imported_questions
FROM question_bank
WHERE source_type = 'topic'
  AND school_id = 0
  AND subject_id = @mathematics_subject_id
  AND topic_id = @measures_topic_id
  AND question LIKE '%Measures of Central Tendency and Range Topic Bank - Item%';

SELECT COUNT(*) AS imported_options
FROM question_bank_options
WHERE question_id IN (
    SELECT id
    FROM question_bank
    WHERE source_type = 'topic'
      AND school_id = 0
      AND subject_id = @mathematics_subject_id
      AND topic_id = @measures_topic_id
      AND question LIKE '%Measures of Central Tendency and Range Topic Bank - Item%'
);

SELECT COUNT(*) AS bad_option_groups
FROM (
    SELECT qb.id
    FROM question_bank qb
    LEFT JOIN question_bank_options qbo ON qbo.question_id = qb.id
    WHERE qb.source_type = 'topic'
      AND qb.school_id = 0
      AND qb.subject_id = @mathematics_subject_id
      AND qb.topic_id = @measures_topic_id
      AND qb.question LIKE '%Measures of Central Tendency and Range Topic Bank - Item%'
    GROUP BY qb.id
    HAVING COUNT(qbo.id) <> 4 OR SUM(qbo.answer = 1) <> 1
) invalid_groups;
