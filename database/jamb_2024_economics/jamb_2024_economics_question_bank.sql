-- JAMB 2024 Economics objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2024_economics/jamb_2024_economics_import_manifest.json for exact per-item source URLs).
-- Expected payload: 80 questions and 320 options.
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

-- Reference data guard: resolve exam body + subject by NAME (never by
-- hardcoded id), creating the exam body if missing. Abort loudly otherwise.
INSERT INTO exam_bodies (name, description)
SELECT 'JAMB', 'Joint Admissions and Matriculation Board'
WHERE NOT EXISTS (SELECT 1 FROM exam_bodies WHERE name = 'JAMB');

SET @exam_body_id := (SELECT id FROM exam_bodies WHERE name = 'JAMB' ORDER BY id ASC LIMIT 1);
SET @subject_id := (SELECT id FROM subjects WHERE subject = 'Economics' ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_jamb_2024_economics_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2024_economics_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Economics subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2024_economics_refs();
DROP PROCEDURE ss360_require_jamb_2024_economics_refs;

START TRANSACTION;

-- JAMB 2024 Economics - Item 1 - Question 1
SET @source_marker := 'JAMB 2024 Economics - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 1 - Question 1</small></p><p><strong>JAMB 2024 Economics - Question 1</strong></p><p>Which of the following is not emphasized in a product possibility curve?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Scarcity of resources', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Scarcity of resources' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Unemployment of labour', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Unemployment of labour' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Inefficiency in the use of resources', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Inefficiency in the use of resources' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Economic development', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Economic development' AND deleted = 0);

-- JAMB 2024 Economics - Item 2 - Question 2
SET @source_marker := 'JAMB 2024 Economics - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 2 - Question 2</small></p><p><strong>JAMB 2024 Economics - Question 2</strong></p><p>Which of the following NOT among the objectives of OPEC?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to stabilize the price of oil in the world market', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'to stabilize the price of oil in the world market' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to established petroleum refineries in all member state', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'to established petroleum refineries in all member state' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to stabilize the revenue from oil to producing countries', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'to stabilize the revenue from oil to producing countries' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to make sure that oil flows to all the consuming countries', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'to make sure that oil flows to all the consuming countries' AND deleted = 0);

-- JAMB 2024 Economics - Item 3 - Question 3
SET @source_marker := 'JAMB 2024 Economics - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 3 - Question 3</small></p><p><strong>JAMB 2024 Economics - Question 3</strong></p><p>A market situation with few sellers and many buyers is called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'duopoly', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'duopoly' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Omonopoly', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Omonopoly' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'perfect competition', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'perfect competition' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oligopoly', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oligopoly' AND deleted = 0);

-- JAMB 2024 Economics - Item 4 - Question 4
SET @source_marker := 'JAMB 2024 Economics - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 4 - Question 4</small></p><p><strong>JAMB 2024 Economics - Question 4</strong></p><p>MPC + MPS equals</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Zero', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Zero' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Multiplier', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Multiplier' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'One', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'One' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'APS', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'APS' AND deleted = 0);

-- JAMB 2024 Economics - Item 5 - Question 5
SET @source_marker := 'JAMB 2024 Economics - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 5 - Question 5</small></p><p><strong>JAMB 2024 Economics - Question 5</strong></p><p>Producers operating in a free market economy are more efficient as a result of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the existence of competition', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the existence of competition' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'government regulation of their activities', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'government regulation of their activities' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the very few number of participants', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the very few number of participants' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the commitment of the shareholders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the commitment of the shareholders' AND deleted = 0);

-- JAMB 2024 Economics - Item 6 - Question 6
SET @source_marker := 'JAMB 2024 Economics - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 6 - Question 6</small></p><p><strong>JAMB 2024 Economics - Question 6</strong></p><p>In income determination theory, acceleration principles shows that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'investment is the causes, while income is the effects', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'investment is the causes, while income is the effects' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'income and investment are both effects', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'income and investment are both effects' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'incomes is of on effect on investment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'incomes is of on effect on investment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'income and investment are both causes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'income and investment are both causes' AND deleted = 0);

-- JAMB 2024 Economics - Item 7 - Question 7
SET @source_marker := 'JAMB 2024 Economics - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 7 - Question 7</small></p><p><strong>JAMB 2024 Economics - Question 7</strong></p><p>The largest component of national income in developing countries consist of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wages and salaries', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'wages and salaries' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'profit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'profit' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'profit and rent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'profit and rent' AND deleted = 0);

-- JAMB 2024 Economics - Item 8 - Question 8
SET @source_marker := 'JAMB 2024 Economics - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 8 - Question 8</small></p><p><strong>JAMB 2024 Economics - Question 8</strong></p><p>Holding money to take care of contingencies is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a precautionary motive', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a precautionary motive' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a transactions motive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a transactions motive' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an expansionary motive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an expansionary motive' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a speculative motive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a speculative motive' AND deleted = 0);

-- JAMB 2024 Economics - Item 9 - Question 9
SET @source_marker := 'JAMB 2024 Economics - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 9 - Question 9</small></p><p><strong>JAMB 2024 Economics - Question 9</strong></p><p>In the long-run, a firm must shut down if its average revenue is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'greater than average cost', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'greater than average cost' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'equal to the average cost', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'equal to the average cost' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'equal to the minimum average revenue is', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'equal to the minimum average revenue is' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'less than average variable cost', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'less than average variable cost' AND deleted = 0);

-- JAMB 2024 Economics - Item 10 - Question 10
SET @source_marker := 'JAMB 2024 Economics - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 10 - Question 10</small></p><p><strong>JAMB 2024 Economics - Question 10</strong></p><p>The act of cultivating land and rearing of animal for man&#039;s use is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'forestry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'forestry' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'agriculture', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'agriculture' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mono culture', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mono culture' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'horticulture', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'horticulture' AND deleted = 0);

-- JAMB 2024 Economics - Item 11 - Question 11
SET @source_marker := 'JAMB 2024 Economics - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 11 - Question 11</small></p><p><strong>JAMB 2024 Economics - Question 11</strong></p><p>In the event of bankruptcy, owners of joint-stock companies lose</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'both company and private assets', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'both company and private assets' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'only the capital invested', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'only the capital invested' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'only their dividends', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'only their dividends' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'their private properties', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'their private properties' AND deleted = 0);

-- JAMB 2024 Economics - Item 12 - Question 12
SET @source_marker := 'JAMB 2024 Economics - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 12 - Question 12</small></p><p><strong>JAMB 2024 Economics - Question 12</strong></p><p>The main disadvantages of deflationary policies is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'full employment in the country', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'full employment in the country' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increasing cost of living', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increasing cost of living' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unemployment in the country', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unemployment in the country' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'improved standard of living', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'improved standard of living' AND deleted = 0);

-- JAMB 2024 Economics - Item 13 - Question 13
SET @source_marker := 'JAMB 2024 Economics - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 13 - Question 13</small></p><p><strong>JAMB 2024 Economics - Question 13</strong></p><p>If government in a fiscal year has its revenue receipts less than the expenditure, such country is having</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deficit budget', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'deficit budget' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favorable budget', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'favorable budget' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'balanced budget', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'balanced budget' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'surplus budget', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'surplus budget' AND deleted = 0);

-- JAMB 2024 Economics - Item 14 - Question 14
SET @source_marker := 'JAMB 2024 Economics - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 14 - Question 14</small></p><p><strong>JAMB 2024 Economics - Question 14</strong></p><p>A firm&#039;s average cost decreases in the long-run because of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increasing returns to scale', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increasing returns to scale' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'diminishing average returns', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'diminishing average returns' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decreasing average fixed cost', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decreasing average fixed cost' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decreasing marginal returns', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decreasing marginal returns' AND deleted = 0);

-- JAMB 2024 Economics - Item 15 - Question 15
SET @source_marker := 'JAMB 2024 Economics - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 15 - Question 15</small></p><p><strong>JAMB 2024 Economics - Question 15</strong></p><p>What is the median term in the distribution below; 14, 13 29,15,13,17,12.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '14' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '13', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '13' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '15' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12' AND deleted = 0);

-- JAMB 2024 Economics - Item 16 - Question 16
SET @source_marker := 'JAMB 2024 Economics - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 16 - Question 16</small></p><p><strong>JAMB 2024 Economics - Question 16</strong></p><p>The following are type of business organization EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'co-operative society', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'co-operative society' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'partnership', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'partnership' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Entrepreneurship', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Entrepreneurship' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'public corporation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'public corporation' AND deleted = 0);

-- JAMB 2024 Economics - Item 17 - Question 17
SET @source_marker := 'JAMB 2024 Economics - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 17 - Question 17</small></p><p><strong>JAMB 2024 Economics - Question 17</strong></p><p><img src=\"../uploads/question_bank/jamb_2024_economics/Q17_diagram.png\" alt=\"Diagram for JAMB 2024 Economics Question 17\" style=\"max-width:100%;height:auto;\"></p><p>From the diagram below, moving from point A to B and from B to c is due to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Economic depression', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Economic depression' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Unemployment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Unemployment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Economic growth', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Economic growth' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Opportunity cost', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Opportunity cost' AND deleted = 0);

-- JAMB 2024 Economics - Item 18 - Question 18
SET @source_marker := 'JAMB 2024 Economics - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 18 - Question 18</small></p><p><strong>JAMB 2024 Economics - Question 18</strong></p><p>The contribution of petroleum to the economy of Nigerian is most prominent in the area of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'revenue generation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'revenue generation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'infrastructural development', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'infrastructural development' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fuel provision', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fuel provision' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'employment generation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'employment generation' AND deleted = 0);

-- JAMB 2024 Economics - Item 19 - Question 19
SET @source_marker := 'JAMB 2024 Economics - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 19 - Question 19</small></p><p><strong>JAMB 2024 Economics - Question 19</strong></p><p>Which of the following is NOT a feature of capitalism?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Free enterprise', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Free enterprise' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'private ownership of property', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'private ownership of property' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'competition', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'competition' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'detailed economics planning', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'detailed economics planning' AND deleted = 0);

-- JAMB 2024 Economics - Item 20 - Question 20
SET @source_marker := 'JAMB 2024 Economics - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 20 - Question 20</small></p><p><strong>JAMB 2024 Economics - Question 20</strong></p><p>When an economy is having a balance of payment surplus the best alternative opened to it is to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'devalue its currency', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'devalue its currency' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'borrow from abroad', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'borrow from abroad' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'promote imports into the country', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'promote imports into the country' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase its foreign reserve', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase its foreign reserve' AND deleted = 0);

-- JAMB 2024 Economics - Item 21 - Question 21
SET @source_marker := 'JAMB 2024 Economics - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 21 - Question 21</small></p><p><strong>JAMB 2024 Economics - Question 21</strong></p><p>One of the function of united nation conference on trade and development (UNTAD) is to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transfer technology from developed to less developed countries', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'transfer technology from developed to less developed countries' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase share of less developed countries in world trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase share of less developed countries in world trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase impact of developed countries over less developed countries', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase impact of developed countries over less developed countries' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'make goods available in developed countries', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'make goods available in developed countries' AND deleted = 0);

-- JAMB 2024 Economics - Item 22 - Question 22
SET @source_marker := 'JAMB 2024 Economics - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 22 - Question 22</small></p><p><strong>JAMB 2024 Economics - Question 22</strong></p><p>Wholesalers play an important in the distribution of goods and services because they</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'are located very close to consumers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'are located very close to consumers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pass information on from retailers to consumers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pass information on from retailers to consumers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sell in small units to consumers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sell in small units to consumers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'finance both producers and retailers', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'finance both producers and retailers' AND deleted = 0);

-- JAMB 2024 Economics - Item 23 - Question 23
SET @source_marker := 'JAMB 2024 Economics - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 23 - Question 23</small></p><p><strong>JAMB 2024 Economics - Question 23</strong></p><p>Economics problems arise in all societies because</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the services of economists are not employed', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the services of economists are not employed' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'resource are not in adequate supply', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'resource are not in adequate supply' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'there is no proper planning', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'there is no proper planning' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'resources are mismanaged by leaders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'resources are mismanaged by leaders' AND deleted = 0);

-- JAMB 2024 Economics - Item 24 - Question 24
SET @source_marker := 'JAMB 2024 Economics - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 24 - Question 24</small></p><p><strong>JAMB 2024 Economics - Question 24</strong></p><p>A downward sloping demand curve means that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'price must be lowered to sell more', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'price must be lowered to sell more' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'total revenue declines as price is lowered', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'total revenue declines as price is lowered' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand falls as output increases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand falls as output increases' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand falls as output falls', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand falls as output falls' AND deleted = 0);

-- JAMB 2024 Economics - Item 25 - Question 25
SET @source_marker := 'JAMB 2024 Economics - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 25 - Question 25</small></p><p><strong>JAMB 2024 Economics - Question 25</strong></p><p>The bank established to finances project aimed at promoting economic and social development within the African continent is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'African bank for commerce and industry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'African bank for commerce and industry' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'economic bank for African', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'economic bank for African' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'recovery fund bank for Africa', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'recovery fund bank for Africa' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'African development bank', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'African development bank' AND deleted = 0);

-- JAMB 2024 Economics - Item 26 - Question 26
SET @source_marker := 'JAMB 2024 Economics - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 26 - Question 26</small></p><p><strong>JAMB 2024 Economics - Question 26</strong></p><p><img src=\"../uploads/question_bank/jamb_2024_economics/Q26_diagram.png\" alt=\"Diagram for JAMB 2024 Economics Question 26\" style=\"max-width:100%;height:auto;\"></p><p>The diagram belwo, shows the relationship between</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'minimum wage and unemployment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'minimum wage and unemployment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'equilibrium wage rate and philip curve', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'equilibrium wage rate and philip curve' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'W4 and W3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'W4 and W3' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wage rate and unemployment', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'wage rate and unemployment' AND deleted = 0);

-- JAMB 2024 Economics - Item 27 - Question 27
SET @source_marker := 'JAMB 2024 Economics - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 27 - Question 27</small></p><p><strong>JAMB 2024 Economics - Question 27</strong></p><p>Which of these is NOT associated with the problem of internal trade?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bargaining', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bargaining' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'market trade unions', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'market trade unions' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lack of specialization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lack of specialization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'natural barriers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'natural barriers' AND deleted = 0);

-- JAMB 2024 Economics - Item 28 - Question 28
SET @source_marker := 'JAMB 2024 Economics - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 28 - Question 28</small></p><p><strong>JAMB 2024 Economics - Question 28</strong></p><p>The middle value of an array figure arranged in descending order is referred to as the</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Variance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Variance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mean', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mean' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mode', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mode' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'median', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'median' AND deleted = 0);

-- JAMB 2024 Economics - Item 29 - Question 29
SET @source_marker := 'JAMB 2024 Economics - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 29 - Question 29</small></p><p><strong>JAMB 2024 Economics - Question 29</strong></p><p>An exceptional demand curve can result from</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase in price of raw materials', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase in price of raw materials' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'change in taste of consumer', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'change in taste of consumer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase in the size of the population', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase in the size of the population' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'expectation of future price increase', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'expectation of future price increase' AND deleted = 0);

-- JAMB 2024 Economics - Item 30 - Question 30
SET @source_marker := 'JAMB 2024 Economics - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 30 - Question 30</small></p><p><strong>JAMB 2024 Economics - Question 30</strong></p><p>If the prices of a commodity increases from N8.00 to N10.00 and the demand decreases from 100 to 80 respectively, wha is the price elasticity of demand for the commodity?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.8', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.8' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.5' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.5' AND deleted = 0);

-- JAMB 2024 Economics - Item 31 - Question 31
SET @source_marker := 'JAMB 2024 Economics - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 31 - Question 31</small></p><p><strong>JAMB 2024 Economics - Question 31</strong></p><p>A producer who can only influence the price of his product but canNOT determine the quantity to be sold is referred to<br>\r\nas</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'duopoly', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'duopoly' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'monopolist', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'monopolist' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'monopsonist', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'monopsonist' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oligopoly', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oligopoly' AND deleted = 0);

-- JAMB 2024 Economics - Item 32 - Question 32
SET @source_marker := 'JAMB 2024 Economics - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 32 - Question 32</small></p><p><strong>JAMB 2024 Economics - Question 32</strong></p><p>Which of the following is NOT a factor that brings about changes in demand?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the price of the good or service', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the price of the good or service' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a change in real income', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a change in real income' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'government policy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'government policy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase in population', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase in population' AND deleted = 0);

-- JAMB 2024 Economics - Item 33 - Question 33
SET @source_marker := 'JAMB 2024 Economics - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 33 - Question 33</small></p><p><strong>JAMB 2024 Economics - Question 33</strong></p><p>A price floor is usually fixed</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'above the equilibrium and causes surpluses', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'above the equilibrium and causes surpluses' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'below the equilibrium and causes surpluses', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'below the equilibrium and causes surpluses' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'above the equilibrium and causes shortage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'above the equilibrium and causes shortage' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'at the equilibrium and causes no shortage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'at the equilibrium and causes no shortage' AND deleted = 0);

-- JAMB 2024 Economics - Item 34 - Question 34
SET @source_marker := 'JAMB 2024 Economics - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 34 - Question 34</small></p><p><strong>JAMB 2024 Economics - Question 34</strong></p><p>If the price of commodity X rises and consumers shift to commodity Y, then commodities X and Y are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inferior goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inferior goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'substitutes', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'substitutes' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'complements', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'complements' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bought together', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bought together' AND deleted = 0);

-- JAMB 2024 Economics - Item 35 - Question 35
SET @source_marker := 'JAMB 2024 Economics - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 35 - Question 35</small></p><p><strong>JAMB 2024 Economics - Question 35</strong></p><p>The willingness of an individual backed up with purchasing power at a given time is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'effective demand', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'effective demand' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'desire', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'desire' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'utility', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'utility' AND deleted = 0);

-- JAMB 2024 Economics - Item 36 - Question 36
SET @source_marker := 'JAMB 2024 Economics - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 36 - Question 36</small></p><p><strong>JAMB 2024 Economics - Question 36</strong></p><p>The formular used by the Expenditure approach to calculate National income is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Y=C+I+X-M-G', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Y=C+I+X-M-G' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Y=C+I+G+X-M', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Y=C+I+G+X-M' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Y=C+X-M-I+G', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Y=C+X-M-I+G' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Y=C-I+X-M+G', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Y=C-I+X-M+G' AND deleted = 0);

-- JAMB 2024 Economics - Item 37 - Question 37
SET @source_marker := 'JAMB 2024 Economics - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 37 - Question 37</small></p><p><strong>JAMB 2024 Economics - Question 37</strong></p><p>If the marginal utility of commodity is equal to its price, then</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the market is not in equilibrium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the market is not in equilibrium' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'more of the commodity can be consumed', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'more of the commodity can be consumed' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'total utility is also equal to its price', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'total utility is also equal to its price' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the consumer is in equilibrium', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the consumer is in equilibrium' AND deleted = 0);

-- JAMB 2024 Economics - Item 38 - Question 38
SET @source_marker := 'JAMB 2024 Economics - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 38 - Question 38</small></p><p><strong>JAMB 2024 Economics - Question 38</strong></p><p><img src=\"../uploads/question_bank/jamb_2024_economics/Q38_diagram.png\" alt=\"Diagram for JAMB 2024 Economics Question 38\" style=\"max-width:100%;height:auto;\"></p><p>From the diagram below, the equilibrium wage rate is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'L3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'L3' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'L2', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'L2' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'W2', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'W2' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'W1', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'W1' AND deleted = 0);

-- JAMB 2024 Economics - Item 39 - Question 39
SET @source_marker := 'JAMB 2024 Economics - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 39 - Question 39</small></p><p><strong>JAMB 2024 Economics - Question 39</strong></p><p>When combination of two goods which a consumer derive equal satisfaction is plotted on a graph, the graph is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'opportunity curve', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'opportunity curve' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'utility curve', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'utility curve' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand curve', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand curve' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'indifference curve', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'indifference curve' AND deleted = 0);

-- JAMB 2024 Economics - Item 40 - Question 40
SET @source_marker := 'JAMB 2024 Economics - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 40 - Question 40</small></p><p><strong>JAMB 2024 Economics - Question 40</strong></p><p>The comparison of the standard of living between Nigeria and Ghana is best down through the use of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gross National incomes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gross National incomes' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'per capita income', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'per capita income' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Net National income', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Net National income' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Net disposable income', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Net disposable income' AND deleted = 0);

-- JAMB 2024 Economics - Item 41 - Question 41
SET @source_marker := 'JAMB 2024 Economics - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 41 - Question 41</small></p><p><strong>JAMB 2024 Economics - Question 41</strong></p><p>The formular (N + 1)/2 is used to determine the</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'median', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'median' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mean', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mean' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'standard deviation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'standard deviation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mode', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mode' AND deleted = 0);

-- JAMB 2024 Economics - Item 42 - Question 42
SET @source_marker := 'JAMB 2024 Economics - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 42 - Question 42</small></p><p><strong>JAMB 2024 Economics - Question 42</strong></p><p>If the standard deviation of a set of numbers is 3.6, what is the variance?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12.96', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12.96' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12.69', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12.69' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12.9', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12.9' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12.98', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12.98' AND deleted = 0);

-- JAMB 2024 Economics - Item 43 - Question 43
SET @source_marker := 'JAMB 2024 Economics - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 43 - Question 43</small></p><p><strong>JAMB 2024 Economics - Question 43</strong></p><p>The following will occur when maximum price is fixed below the free market price EXCEPT that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'black market will be encouraged', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'black market will be encouraged' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'excess demand will occur', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'excess demand will occur' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'excess supply will occur', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'excess supply will occur' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rationing of commodities will occur', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rationing of commodities will occur' AND deleted = 0);

-- JAMB 2024 Economics - Item 44 - Question 44
SET @source_marker := 'JAMB 2024 Economics - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 44 - Question 44</small></p><p><strong>JAMB 2024 Economics - Question 44</strong></p><p>If the population of a school is 600 and 60% are In JSS, how many students are in SSS?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '244', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '244' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '240', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '240' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '224', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '224' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '204', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '204' AND deleted = 0);

-- JAMB 2024 Economics - Item 45 - Question 45
SET @source_marker := 'JAMB 2024 Economics - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 45 - Question 45</small></p><p><strong>JAMB 2024 Economics - Question 45</strong></p><p>The revolution of Cassava from ordinary food crop to export crop will lead to<br>\r\n </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase in production of other crops', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase in production of other crops' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase in the prices of cassava products', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase in the prices of cassava products' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decrease in production of local starch', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decrease in production of local starch' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decrease In production of cassava', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decrease In production of cassava' AND deleted = 0);

-- JAMB 2024 Economics - Item 46 - Question 46
SET @source_marker := 'JAMB 2024 Economics - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 46 - Question 46</small></p><p><strong>JAMB 2024 Economics - Question 46</strong></p><p>When the total product starts falling, then the marginal product is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increasing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increasing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'maximum', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'maximum' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'zero', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'zero' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'negative', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'negative' AND deleted = 0);

-- JAMB 2024 Economics - Item 47 - Question 47
SET @source_marker := 'JAMB 2024 Economics - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 47 - Question 47</small></p><p><strong>JAMB 2024 Economics - Question 47</strong></p><p>The following are the objectives of agricultural policies in Nigeria EXCEPT</p>\r\n\r\n<p>A. provision of food<br>\r\nB. provision of agricultural raw materials to industrial sectors<br>\r\nC. increasing prices of agricultural Inputs<br>\r\nD. creation of rural employment</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'provision of agricultural raw materials to industrial sectors', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'provision of agricultural raw materials to industrial sectors' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'creation of rural employment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'creation of rural employment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'provision of food', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'provision of food' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increasing prices of agricultural Inputs', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increasing prices of agricultural Inputs' AND deleted = 0);

-- JAMB 2024 Economics - Item 48 - Question 48
SET @source_marker := 'JAMB 2024 Economics - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 48 - Question 48</small></p><p><strong>JAMB 2024 Economics - Question 48</strong></p><p>The following can be used to improve a country&#039;s balance of payment EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'anti-dumping policies', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'anti-dumping policies' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'granting subsidies to export producers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'granting subsidies to export producers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decreasing taxation on personal income', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decreasing taxation on personal income' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increasing import duties', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increasing import duties' AND deleted = 0);

-- JAMB 2024 Economics - Item 49 - Question 49
SET @source_marker := 'JAMB 2024 Economics - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 49 - Question 49</small></p><p><strong>JAMB 2024 Economics - Question 49</strong></p><p>In the equation Q = a - bp + e; Q and P are ... Variables respectively.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'independent and dependent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'independent and dependent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dependent and independent', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dependent and independent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'independent and constant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'independent and constant' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'error term and independent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'error term and independent' AND deleted = 0);

-- JAMB 2024 Economics - Item 50 - Question 50
SET @source_marker := 'JAMB 2024 Economics - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 50 - Question 50</small></p><p><strong>JAMB 2024 Economics - Question 50</strong></p><p>Which of the following is NOT an objective of Economic planning?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Equitable allocation of resources', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Equitable allocation of resources' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Widening the income gap', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Widening the income gap' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Achieving economic growth', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Achieving economic growth' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Creating employment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Creating employment' AND deleted = 0);

-- JAMB 2024 Economics - Item 51 - Question 51
SET @source_marker := 'JAMB 2024 Economics - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 51 - Question 51</small></p><p><strong>JAMB 2024 Economics - Question 51</strong></p><p>The following determine the level of consumption EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'level of income', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'level of income' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the rate of taxes paid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the rate of taxes paid' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'savings', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'savings' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the political climate', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the political climate' AND deleted = 0);

-- JAMB 2024 Economics - Item 52 - Question 52
SET @source_marker := 'JAMB 2024 Economics - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 52 - Question 52</small></p><p><strong>JAMB 2024 Economics - Question 52</strong></p><p>The following are problems of development planning in Nigeria EXCEPT<br>\r\n </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inadequate capital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inadequate capital' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'under-population', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'under-population' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inadequate statistical data', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inadequate statistical data' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'poor implementation of economic planning', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'poor implementation of economic planning' AND deleted = 0);

-- JAMB 2024 Economics - Item 53 - Question 53
SET @source_marker := 'JAMB 2024 Economics - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 53 - Question 53</small></p><p><strong>JAMB 2024 Economics - Question 53</strong></p><p>The system of farming which involves the use of a large hectare of land planted with economic crops is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'peasant farming', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'peasant farming' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tree planting', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tree planting' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'plantation farming', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'plantation farming' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mechanized farming', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mechanized farming' AND deleted = 0);

-- JAMB 2024 Economics - Item 54 - Question 54
SET @source_marker := 'JAMB 2024 Economics - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 54 - Question 54</small></p><p><strong>JAMB 2024 Economics - Question 54</strong></p><p>At the equilibrium price,</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand equates supply', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand equates supply' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'price is equal to demand only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'price is equal to demand only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand is less than supply', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand is less than supply' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand is greater than supply', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand is greater than supply' AND deleted = 0);

-- JAMB 2024 Economics - Item 55 - Question 55
SET @source_marker := 'JAMB 2024 Economics - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 55 - Question 55</small></p><p><strong>JAMB 2024 Economics - Question 55</strong></p><p>Which of the following is a disadvantage of localization of industries?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Creating structural unemployment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Creating structural unemployment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Reducing cost of production', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Reducing cost of production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Encouraging the growth of skilled labour', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Encouraging the growth of skilled labour' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Encouraging subsidiary industries', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Encouraging subsidiary industries' AND deleted = 0);

-- JAMB 2024 Economics - Item 56 - Question 56
SET @source_marker := 'JAMB 2024 Economics - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 56 - Question 56</small></p><p><strong>JAMB 2024 Economics - Question 56</strong></p><p>Stock exchange market deals with</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sales of second hand securities', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sales of second hand securities' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sales of foreign exchange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sales of foreign exchange' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exchange of stock fish for stock', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exchange of stock fish for stock' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exchange of treasury bills', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exchange of treasury bills' AND deleted = 0);

-- JAMB 2024 Economics - Item 57 - Question 57
SET @source_marker := 'JAMB 2024 Economics - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 57 - Question 57</small></p><p><strong>JAMB 2024 Economics - Question 57</strong></p><p>Which of the following is NOT a major role of OPEC in production, and marketing of petroleum?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Stabilizing oil prices putting a production ceiling', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Stabilizing oil prices putting a production ceiling' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Refining of petroleum products in member countries', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Refining of petroleum products in member countries' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Raising the revenue of member countries from oil through price increase', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Raising the revenue of member countries from oil through price increase' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ensuring efficient and regular supply of oil to the two market', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ensuring efficient and regular supply of oil to the two market' AND deleted = 0);

-- JAMB 2024 Economics - Item 58 - Question 58
SET @source_marker := 'JAMB 2024 Economics - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 58 - Question 58</small></p><p><strong>JAMB 2024 Economics - Question 58</strong></p><p>The satisfaction derived from the consumption of a commodity is referred to as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consumption', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consumption' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'production', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'utility', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'utility' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand' AND deleted = 0);

-- JAMB 2024 Economics - Item 59 - Question 59
SET @source_marker := 'JAMB 2024 Economics - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 59 - Question 59</small></p><p><strong>JAMB 2024 Economics - Question 59</strong></p><p>An industry engaged in the extraction of raw materials and its conversion into semi-finished goods is called industry.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mining', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mining' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufacturing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufacturing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'processing', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'processing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'conversion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'conversion' AND deleted = 0);

-- JAMB 2024 Economics - Item 60 - Question 60
SET @source_marker := 'JAMB 2024 Economics - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 60 - Question 60</small></p><p><strong>JAMB 2024 Economics - Question 60</strong></p><p>An industry operating in a perfect competitive market situation will maximum profit when</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'DD &lt; SS', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'DD &lt; SS' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MC &gt; AC', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MC &gt; AC' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MC = MR', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MC = MR' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MC &lt; AR', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MC &lt; AR' AND deleted = 0);

-- JAMB 2024 Economics - Item 61 - Question 61
SET @source_marker := 'JAMB 2024 Economics - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 61 - Question 61</small></p><p><strong>JAMB 2024 Economics - Question 61</strong></p><p>Which of the following is NOT a function of marketing boards in Nigeria?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Grading of farm produce', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Grading of farm produce' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Importation of farm produce', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Importation of farm produce' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fixing of prices for farm produce', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fixing of prices for farm produce' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Marketing of farm produce', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Marketing of farm produce' AND deleted = 0);

-- JAMB 2024 Economics - Item 62 - Question 62
SET @source_marker := 'JAMB 2024 Economics - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 62 - Question 62</small></p><p><strong>JAMB 2024 Economics - Question 62</strong></p><p>Persistent fall In the general price level is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deflation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'deflation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'devaluation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'devaluation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'general price Increase', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'general price Increase' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inflation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inflation' AND deleted = 0);

-- JAMB 2024 Economics - Item 63 - Question 63
SET @source_marker := 'JAMB 2024 Economics - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 63 - Question 63</small></p><p><strong>JAMB 2024 Economics - Question 63</strong></p><p>Which of the following will NOT bring about an increase in Labour force?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Decrease in death rate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Decrease in death rate' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Better medical services', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Better medical services' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Immigration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Immigration' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Emigration', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Emigration' AND deleted = 0);

-- JAMB 2024 Economics - Item 64 - Question 64
SET @source_marker := 'JAMB 2024 Economics - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 64 - Question 64</small></p><p><strong>JAMB 2024 Economics - Question 64</strong></p><p><img src=\"../uploads/question_bank/jamb_2024_economics/Q64_diagram.png\" alt=\"Diagram for JAMB 2024 Economics Question 64\" style=\"max-width:100%;height:auto;\"></p><p>The diagram below represent</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Business cycle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Business cycle' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'National income', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'National income' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Inflationary gap', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Inflationary gap' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Circular flow of income', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Circular flow of income' AND deleted = 0);

-- JAMB 2024 Economics - Item 65 - Question 65
SET @source_marker := 'JAMB 2024 Economics - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 65 - Question 65</small></p><p><strong>JAMB 2024 Economics - Question 65</strong></p><p><img src=\"../uploads/question_bank/jamb_2024_economics/Q65_diagram.png\" alt=\"Diagram for JAMB 2024 Economics Question 65\" style=\"max-width:100%;height:auto;\"></p><p>What add funds to the circular flow?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Expenditure approach', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Expenditure approach' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'withdrawal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'withdrawal' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'leakages', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'leakages' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'injection', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'injection' AND deleted = 0);

-- JAMB 2024 Economics - Item 66 - Question 66
SET @source_marker := 'JAMB 2024 Economics - Item 66 - Question 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 66 - Question 66</small></p><p><strong>JAMB 2024 Economics - Question 66</strong></p><p>Economic problem arises as a result of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'money cost', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'money cost' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'opportunity cost', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'opportunity cost' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'choice', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'choice' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'scarcity', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'scarcity' AND deleted = 0);

-- JAMB 2024 Economics - Item 67 - Question 67
SET @source_marker := 'JAMB 2024 Economics - Item 67 - Question 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 67 - Question 67</small></p><p><strong>JAMB 2024 Economics - Question 67</strong></p><p>The following are rewards for factors of production EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'profit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'profit' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'interest', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'interest' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'subsidy', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'subsidy' AND deleted = 0);

-- JAMB 2024 Economics - Item 68 - Question 68
SET @source_marker := 'JAMB 2024 Economics - Item 68 - Question 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 68 - Question 68</small></p><p><strong>JAMB 2024 Economics - Question 68</strong></p><p>When an increase in the price of a commodity lead to a fall In the demand for another, the demand for the two commodities are said to be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'competitive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'competitive' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'joint', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'joint' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'composite', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'composite' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'derived', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'derived' AND deleted = 0);

-- JAMB 2024 Economics - Item 69 - Question 69
SET @source_marker := 'JAMB 2024 Economics - Item 69 - Question 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 69 - Question 69</small></p><p><strong>JAMB 2024 Economics - Question 69</strong></p><p>Which of the following is NOT a function of the IMF?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Providing financial aid to members experiencing balance of payment difficulties', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Providing financial aid to members experiencing balance of payment difficulties' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Promoting international monetary cooperation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Promoting international monetary cooperation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Exchange rate stabilization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Exchange rate stabilization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'assisting member countries in printing and issuing their currency', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'assisting member countries in printing and issuing their currency' AND deleted = 0);

-- JAMB 2024 Economics - Item 70 - Question 70
SET @source_marker := 'JAMB 2024 Economics - Item 70 - Question 70';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 70 - Question 70</small></p><p><strong>JAMB 2024 Economics - Question 70</strong></p><p>Which of the following is NOT included in-measuring the National income through the income approach?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'profit earned by NITEL plc', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'profit earned by NITEL plc' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Profit earned by Nigerian bottling company plc', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Profit earned by Nigerian bottling company plc' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Income earned by a bricklayer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Income earned by a bricklayer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Allowance given to an aged mother by a civil servant', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Allowance given to an aged mother by a civil servant' AND deleted = 0);

-- JAMB 2024 Economics - Item 71 - Question 71
SET @source_marker := 'JAMB 2024 Economics - Item 71 - Question 71';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 71 - Question 71</small></p><p><strong>JAMB 2024 Economics - Question 71</strong></p><p>If two bags of rice were sold for #1,250 a month ago and two weeks later, the same amount was used to procure one bag. This simply means that the value of money is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'constant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'constant' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fluctuating', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fluctuating' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increasing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increasing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decreasing', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decreasing' AND deleted = 0);

-- JAMB 2024 Economics - Item 72 - Question 72
SET @source_marker := 'JAMB 2024 Economics - Item 72 - Question 72';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 72 - Question 72</small></p><p><strong>JAMB 2024 Economics - Question 72</strong></p><p>The demand for factors of production is said to be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'joint', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'joint' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'complementary', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'complementary' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'derived', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'derived' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'composite', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'composite' AND deleted = 0);

-- JAMB 2024 Economics - Item 73 - Question 73
SET @source_marker := 'JAMB 2024 Economics - Item 73 - Question 73';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 73 - Question 73</small></p><p><strong>JAMB 2024 Economics - Question 73</strong></p><p>The trade-off between two commodities along the Production Possibility Curve (PPC) shows</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transferable output', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'transferable output' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unattainable combination', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unattainable combination' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'scarcity principle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'scarcity principle' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'opportunity cost principle', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'opportunity cost principle' AND deleted = 0);

-- JAMB 2024 Economics - Item 74 - Question 74
SET @source_marker := 'JAMB 2024 Economics - Item 74 - Question 74';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 74 - Question 74</small></p><p><strong>JAMB 2024 Economics - Question 74</strong></p><p>A major characteristics of a firm operating at a long-run equilibrium position is that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'average variable cost is fixed', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'average variable cost is fixed' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'all costs can be varied', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'all costs can be varied' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'only variable cost changes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'only variable cost changes' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fixed cost can not be changed', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fixed cost can not be changed' AND deleted = 0);

-- JAMB 2024 Economics - Item 75 - Question 75
SET @source_marker := 'JAMB 2024 Economics - Item 75 - Question 75';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 75 - Question 75</small></p><p><strong>JAMB 2024 Economics - Question 75</strong></p><p>An economy in which decision of what to produce is taken partly by private individuals and state is referred to as Economy.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'communist', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'communist' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mixed', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mixed' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'socialist', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'socialist' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'capitalist', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'capitalist' AND deleted = 0);

-- JAMB 2024 Economics - Item 76 - Question 76
SET @source_marker := 'JAMB 2024 Economics - Item 76 - Question 76';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 76 - Question 76</small></p><p><strong>JAMB 2024 Economics - Question 76</strong></p><p>Which of the following is NOT associated with minimum price legislation?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wastages of resources', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'wastages of resources' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'excess supply', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'excess supply' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'excess demand', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'excess demand' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unemployment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unemployment' AND deleted = 0);

-- JAMB 2024 Economics - Item 77 - Question 77
SET @source_marker := 'JAMB 2024 Economics - Item 77 - Question 77';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 77 - Question 77</small></p><p><strong>JAMB 2024 Economics - Question 77</strong></p><p>Which of the following is the correct order in the chain of distribution?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Consumer -&gt; Distributor → Retailer → Producer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Consumer -&gt; Distributor → Retailer → Producer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Producer → Wholesaler → Retailer → Consumer', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Producer → Wholesaler → Retailer → Consumer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Retailer → Consumer → Producer → Wholesaler', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Retailer → Consumer → Producer → Wholesaler' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Producer → Consumer → Retailer → Wholesaler', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Producer → Consumer → Retailer → Wholesaler' AND deleted = 0);

-- JAMB 2024 Economics - Item 78 - Question 78
SET @source_marker := 'JAMB 2024 Economics - Item 78 - Question 78';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 78 - Question 78</small></p><p><strong>JAMB 2024 Economics - Question 78</strong></p><p>The problem of &quot;how to produce&quot; in any economy is solved by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'combining capital and labour intensive methods of production', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'combining capital and labour intensive methods of production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'adopting the least cost method of production', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'adopting the least cost method of production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'using capital intensive method of production', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'using capital intensive method of production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'employing the services of a manager', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'employing the services of a manager' AND deleted = 0);

-- JAMB 2024 Economics - Item 79 - Question 79
SET @source_marker := 'JAMB 2024 Economics - Item 79 - Question 79';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 79 - Question 79</small></p><p><strong>JAMB 2024 Economics - Question 79</strong></p><p>Under perfect competition, a profit maximizing firm will hire labour up to the point where the last unit of labor adds</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'less to TR as to TC', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'less to TR as to TC' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'as much to TR as to TC', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'as much to TR as to TC' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'more to TC than to TR', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'more to TC than to TR' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'less to TC than to TR', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'less to TC than to TR' AND deleted = 0);

-- JAMB 2024 Economics - Item 80 - Question 80
SET @source_marker := 'JAMB 2024 Economics - Item 80 - Question 80';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Economics - Item 80 - Question 80</small></p><p><strong>JAMB 2024 Economics - Question 80</strong></p><p>The use of tax and expenditure policy to regulate the economy is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'monetary policy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'monetary policy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'physical measures', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'physical measures' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deregulation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'deregulation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fiscal policy', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fiscal policy' AND deleted = 0);
COMMIT;

SELECT
    COUNT(*) AS jamb_2024_economics_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2024
  AND question LIKE '%JAMB 2024 Economics - Item%';
