-- JAMB 2025 Commerce objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2025_commerce/jamb_2025_commerce_import_manifest.json for exact per-item source URLs).
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
SET @subject_id := (SELECT id FROM subjects WHERE subject = 'Commerce' ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_jamb_2025_commerce_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2025_commerce_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Commerce subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2025_commerce_refs();
DROP PROCEDURE ss360_require_jamb_2025_commerce_refs;

START TRANSACTION;

-- JAMB 2025 Commerce - Item 1 - Question 1
SET @source_marker := 'JAMB 2025 Commerce - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 1 - Question 1</small></p><p><strong>JAMB 2025 Commerce - Question 1</strong></p><p>Goods are usually classified into</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'saleable and non saleable goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'saleable and non saleable goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inferior and superior goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inferior and superior goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'luxurious and essential goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'luxurious and essential goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'producer and consumer goods', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'producer and consumer goods' AND deleted = 0);

-- JAMB 2025 Commerce - Item 2 - Question 2
SET @source_marker := 'JAMB 2025 Commerce - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 2 - Question 2</small></p><p><strong>JAMB 2025 Commerce - Question 2</strong></p><p>The transfer of ownership of government business to individuals is</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'privatization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'privatization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commercialisation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commercialisation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deregulation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'deregulation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nationalization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nationalization' AND deleted = 0);

-- JAMB 2025 Commerce - Item 3 - Question 3
SET @source_marker := 'JAMB 2025 Commerce - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 3 - Question 3</small></p><p><strong>JAMB 2025 Commerce - Question 3</strong></p><p>The fees charged on postal order by the post office is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'premium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'premium' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'poundage', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'poundage' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'interest', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'interest' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'brokerage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'brokerage' AND deleted = 0);

-- JAMB 2025 Commerce - Item 4 - Question 4
SET @source_marker := 'JAMB 2025 Commerce - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 4 - Question 4</small></p><p><strong>JAMB 2025 Commerce - Question 4</strong></p><p>An open cheque is one</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Which can be cashed over the counter', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Which can be cashed over the counter' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Which has no name', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Which has no name' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Which has no specific amount written on it', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Which has no specific amount written on it' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'on which the amount is written only in figures', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'on which the amount is written only in figures' AND deleted = 0);

-- JAMB 2025 Commerce - Item 5 - Question 5
SET @source_marker := 'JAMB 2025 Commerce - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 5 - Question 5</small></p><p><strong>JAMB 2025 Commerce - Question 5</strong></p><p>Which of the following is sent by a supplier who does not want to sell on credit?</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Consular invoice', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Consular invoice' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Quotation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Quotation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Advice note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Advice note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Proforma invoice', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Proforma invoice' AND deleted = 0);

-- JAMB 2025 Commerce - Item 6 - Question 6
SET @source_marker := 'JAMB 2025 Commerce - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 6 - Question 6</small></p><p><strong>JAMB 2025 Commerce - Question 6</strong></p><p>Which of the following is not an aid to trade ?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Banking', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Banking' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Production', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Transport', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Transport' AND deleted = 0);

-- JAMB 2025 Commerce - Item 7 - Question 7
SET @source_marker := 'JAMB 2025 Commerce - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 7 - Question 7</small></p><p><strong>JAMB 2025 Commerce - Question 7</strong></p><p>Which of the following is a means of payment?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C.I.F', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C.I.F' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I.O.U', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I.O.U' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Postal order', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Postal order' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Promissory note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Promissory note' AND deleted = 0);

-- JAMB 2025 Commerce - Item 8 - Question 8
SET @source_marker := 'JAMB 2025 Commerce - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 8 - Question 8</small></p><p><strong>JAMB 2025 Commerce - Question 8</strong></p><p>Turnover of a business is the same as the</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'purchases of the business', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'purchases of the business' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'assets of the business', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'assets of the business' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sales of the business', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sales of the business' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'profit of the business', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'profit of the business' AND deleted = 0);

-- JAMB 2025 Commerce - Item 9 - Question 9
SET @source_marker := 'JAMB 2025 Commerce - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 9 - Question 9</small></p><p><strong>JAMB 2025 Commerce - Question 9</strong></p><p>The reduction of the value of a country&#39;s currency in relation to other country&#39;s currencies in</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fluctuation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fluctuation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inflation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inflation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'devaluation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'devaluation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deregulation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'deregulation' AND deleted = 0);

-- JAMB 2025 Commerce - Item 10 - Question 10
SET @source_marker := 'JAMB 2025 Commerce - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 10 - Question 10</small></p><p><strong>JAMB 2025 Commerce - Question 10</strong></p><p>An insurance principle that prevents a person from insuring what he does not stand to lose financially if the insured risk occurs is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'proximate cause', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'proximate cause' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'indemnity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'indemnity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'insurable interest', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'insurable interest' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'subrogation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'subrogation' AND deleted = 0);

-- JAMB 2025 Commerce - Item 11 - Question 11
SET @source_marker := 'JAMB 2025 Commerce - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 11 - Question 11</small></p><p><strong>JAMB 2025 Commerce - Question 11</strong></p><p>The exchange of goods for goods in foreign trade is known as?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Smuggling', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Smuggling' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Visible trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Visible trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Entreport trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Entreport trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Counter trade', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Counter trade' AND deleted = 0);

-- JAMB 2025 Commerce - Item 12 - Question 12
SET @source_marker := 'JAMB 2025 Commerce - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 12 - Question 12</small></p><p><strong>JAMB 2025 Commerce - Question 12</strong></p><p>Small scale retailer continue to survive inspite of serious competition from large scale retailers because they</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'do not separate business money from personal money', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'do not separate business money from personal money' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'buy from many manufacturers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'buy from many manufacturers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Maintain personal relationship with customers', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Maintain personal relationship with customers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Stock only one line of goods in their stalls', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Stock only one line of goods in their stalls' AND deleted = 0);

-- JAMB 2025 Commerce - Item 13 - Question 13
SET @source_marker := 'JAMB 2025 Commerce - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 13 - Question 13</small></p><p><strong>JAMB 2025 Commerce - Question 13</strong></p><p>Which of the following is not a financial institution?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Insurance company', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Insurance company' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Stock exchange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Stock exchange' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Commodity board', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Commodity board' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Clearing house', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Clearing house' AND deleted = 0);

-- JAMB 2025 Commerce - Item 14 - Question 14
SET @source_marker := 'JAMB 2025 Commerce - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 14 - Question 14</small></p><p><strong>JAMB 2025 Commerce - Question 14</strong></p><p>Trade can be described as</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'distribution of goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'distribution of goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'purchase of goods and services', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'purchase of goods and services' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'buying and selling', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'buying and selling' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'production of goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'production of goods' AND deleted = 0);

-- JAMB 2025 Commerce - Item 15 - Question 15
SET @source_marker := 'JAMB 2025 Commerce - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 15 - Question 15</small></p><p><strong>JAMB 2025 Commerce - Question 15</strong></p><p>The job of the police in keeping law and order in the society is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a direct service', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a direct service' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a self service', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a self service' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a commercial services', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a commercial services' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an indirect service', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an indirect service' AND deleted = 0);

-- JAMB 2025 Commerce - Item 16 - Question 16
SET @source_marker := 'JAMB 2025 Commerce - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 16 - Question 16</small></p><p><strong>JAMB 2025 Commerce - Question 16</strong></p><p>When the buyer of an existing share is to receive the pending dividend, the price is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'at par', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'at par' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cum div', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cum div' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'at a discount', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'at a discount' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ex-div', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ex-div' AND deleted = 0);

-- JAMB 2025 Commerce - Item 17 - Question 17
SET @source_marker := 'JAMB 2025 Commerce - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 17 - Question 17</small></p><p><strong>JAMB 2025 Commerce - Question 17</strong></p><p>Musa entered into a contract to supply two cows to Aro. Before the agreed date of supply and without the knowledge of the two<br>\nparties, thieves stole the cows. This is an example of termination of contract by</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'default', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'default' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'performance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'performance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'breach', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'breach' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'frustration', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'frustration' AND deleted = 0);

-- JAMB 2025 Commerce - Item 18 - Question 18
SET @source_marker := 'JAMB 2025 Commerce - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 18 - Question 18</small></p><p><strong>JAMB 2025 Commerce - Question 18</strong></p><p>An agreement that is enforceable in law is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an offer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an offer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a consideration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a consideration' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an acceptance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an acceptance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a contract', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a contract' AND deleted = 0);

-- JAMB 2025 Commerce - Item 19 - Question 19
SET @source_marker := 'JAMB 2025 Commerce - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 19 - Question 19</small></p><p><strong>JAMB 2025 Commerce - Question 19</strong></p><p>When a public company receives the certificate of incorporation, this implies that</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the company''s assets exist separately from those of its members', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the company''s assets exist separately from those of its members' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it can no longer sue or be sued', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it can no longer sue or be sued' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the company''s finds it difficult to raise capital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the company''s finds it difficult to raise capital' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it can go ahead and start business', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it can go ahead and start business' AND deleted = 0);

-- JAMB 2025 Commerce - Item 20 - Question 20
SET @source_marker := 'JAMB 2025 Commerce - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 20 - Question 20</small></p><p><strong>JAMB 2025 Commerce - Question 20</strong></p><p>Which of the following types of insurance is taken against claims made by staff who get injured while at work?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Employers'' liability insurance', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Employers'' liability insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fidelity guarantee insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fidelity guarantee insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Consequential loss insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Consequential loss insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Products liability insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Products liability insurance' AND deleted = 0);

-- JAMB 2025 Commerce - Item 21 - Question 21
SET @source_marker := 'JAMB 2025 Commerce - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 21 - Question 21</small></p><p><strong>JAMB 2025 Commerce - Question 21</strong></p><p>The principle that applies when Greene and Sunwar Insurance Companies jointly indemnified Fatou for the destruction of her<br>\nstorey building by fire is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contribution', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'contribution' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'subrogation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'subrogation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'proximate cause', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'proximate cause' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'insurable interest', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'insurable interest' AND deleted = 0);

-- JAMB 2025 Commerce - Item 22 - Question 22
SET @source_marker := 'JAMB 2025 Commerce - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 22 - Question 22</small></p><p><strong>JAMB 2025 Commerce - Question 22</strong></p><p>Which of the following is a source of capital to a sole proprietorship?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Issue of debenture', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Issue of debenture' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Issue of shares', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Issue of shares' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Loans from friends', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Loans from friends' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Admission of new member', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Admission of new member' AND deleted = 0);

-- JAMB 2025 Commerce - Item 23 - Question 23
SET @source_marker := 'JAMB 2025 Commerce - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 23 - Question 23</small></p><p><strong>JAMB 2025 Commerce - Question 23</strong></p><p>A contract to take possession of goods on installment</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trade-in-sale', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trade-in-sale' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hire purchase', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hire purchase' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'conditional sale', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'conditional sale' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'credit sale', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'credit sale' AND deleted = 0);

-- JAMB 2025 Commerce - Item 24 - Question 24
SET @source_marker := 'JAMB 2025 Commerce - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 24 - Question 24</small></p><p><strong>JAMB 2025 Commerce - Question 24</strong></p><p>Which of the following describes the reason for international trade?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Balance of payment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Balance of payment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Absolute cost advantage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Absolute cost advantage' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Balance of trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Balance of trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Comparative cost advantage', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Comparative cost advantage' AND deleted = 0);

-- JAMB 2025 Commerce - Item 25 - Question 25
SET @source_marker := 'JAMB 2025 Commerce - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 25 - Question 25</small></p><p><strong>JAMB 2025 Commerce - Question 25</strong></p><p>A new offer of contract that terminates the original offer is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an invalid offer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an invalid offer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a void contract', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a void contract' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a counter offer', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a counter offer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quasi contract', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'quasi contract' AND deleted = 0);

-- JAMB 2025 Commerce - Item 26 - Question 26
SET @source_marker := 'JAMB 2025 Commerce - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 26 - Question 26</small></p><p><strong>JAMB 2025 Commerce - Question 26</strong></p><p>Public enterprises are financed mainly by</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commercial banks', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commercial banks' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the shareholders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the shareholders' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the world bank', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the world bank' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'government grants', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'government grants' AND deleted = 0);

-- JAMB 2025 Commerce - Item 27 - Question 27
SET @source_marker := 'JAMB 2025 Commerce - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 27 - Question 27</small></p><p><strong>JAMB 2025 Commerce - Question 27</strong></p><p>Which of the following is most appropriate for a &quot;Cash with Order&quot; terms of sale?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Debit note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Debit note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Consignment note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Consignment note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Credit note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Credit note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Proforma invoice', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Proforma invoice' AND deleted = 0);

-- JAMB 2025 Commerce - Item 28 - Question 28
SET @source_marker := 'JAMB 2025 Commerce - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 28 - Question 28</small></p><p><strong>JAMB 2025 Commerce - Question 28</strong></p><p>Unlimited liability in business implies that the</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'risk of the owner is limited only to the amount invested', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'risk of the owner is limited only to the amount invested' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'property of the owners should not be used to secure loans', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'property of the owners should not be used to secure loans' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'owners private property can be used to settle the business debts', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'owners private property can be used to settle the business debts' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'debts are paid with subventions', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'debts are paid with subventions' AND deleted = 0);

-- JAMB 2025 Commerce - Item 29 - Question 29
SET @source_marker := 'JAMB 2025 Commerce - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 29 - Question 29</small></p><p><strong>JAMB 2025 Commerce - Question 29</strong></p><p>The charge paid by a speculator for non-settlement of his account within the specified period is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'backwardation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'backwardation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'brokerage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'brokerage' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commission' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contango', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'contango' AND deleted = 0);

-- JAMB 2025 Commerce - Item 30 - Question 30
SET @source_marker := 'JAMB 2025 Commerce - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 30 - Question 30</small></p><p><strong>JAMB 2025 Commerce - Question 30</strong></p><p>The net profit is calculated as</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sales less purchases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sales less purchases' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gross profit less expenses', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gross profit less expenses' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gross profit less purchases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gross profit less purchases' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sales less expenses', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sales less expenses' AND deleted = 0);

-- JAMB 2025 Commerce - Item 31 - Question 31
SET @source_marker := 'JAMB 2025 Commerce - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 31 - Question 31</small></p><p><strong>JAMB 2025 Commerce - Question 31</strong></p><p>Which of the following functions of the wholesaler helps to stabilize prices</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Provision of credit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Provision of credit' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Advice to retailers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Advice to retailers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Warehousing', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Warehousing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Financing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Financing' AND deleted = 0);

-- JAMB 2025 Commerce - Item 32 - Question 32
SET @source_marker := 'JAMB 2025 Commerce - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 32 - Question 32</small></p><p><strong>JAMB 2025 Commerce - Question 32</strong></p><p>Which of the following does not belong to the group?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Posters', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Posters' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Free samples', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Free samples' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hoarding of goods', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hoarding of goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Window display', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Window display' AND deleted = 0);

-- JAMB 2025 Commerce - Item 33 - Question 33
SET @source_marker := 'JAMB 2025 Commerce - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 33 - Question 33</small></p><p><strong>JAMB 2025 Commerce - Question 33</strong></p><p>The expert who calculates premium for an insurance company is?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A broker', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A broker' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'An assessor', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'An assessor' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'An actuary', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'An actuary' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'An underwriter', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'An underwriter' AND deleted = 0);

-- JAMB 2025 Commerce - Item 34 - Question 34
SET @source_marker := 'JAMB 2025 Commerce - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 34 - Question 34</small></p><p><strong>JAMB 2025 Commerce - Question 34</strong></p><p>Taxes imposed on locally made goods are known as</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ad valorem duties', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ad valorem duties' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'excise duties', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'excise duties' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'import duties', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'import duties' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'export drawback', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'export drawback' AND deleted = 0);

-- JAMB 2025 Commerce - Item 35 - Question 35
SET @source_marker := 'JAMB 2025 Commerce - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 35 - Question 35</small></p><p><strong>JAMB 2025 Commerce - Question 35</strong></p><p>In&nbsp;which of the following organizations are members entitled to one vote, irrespective of the number of shares held?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Partnership', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Partnership' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Co-operative society', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Co-operative society' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Limited company', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Limited company' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Public corporation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Public corporation' AND deleted = 0);

-- JAMB 2025 Commerce - Item 36 - Question 36
SET @source_marker := 'JAMB 2025 Commerce - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 36 - Question 36</small></p><p><strong>JAMB 2025 Commerce - Question 36</strong></p><p>The difference between a country&#39;s imports and exports of goods in a particular year is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'balance of trade', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'balance of trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'balance of payment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'balance of payment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'terms of trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'terms of trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'terms of payment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'terms of payment' AND deleted = 0);

-- JAMB 2025 Commerce - Item 37 - Question 37
SET @source_marker := 'JAMB 2025 Commerce - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 37 - Question 37</small></p><p><strong>JAMB 2025 Commerce - Question 37</strong></p><p>Examples of current assets are</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trade debtors, trade creditors and cash', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trade debtors, trade creditors and cash' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cash and trade creditors', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cash and trade creditors' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trade creditors and trade debtors', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trade creditors and trade debtors' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cash and trade debtors', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cash and trade debtors' AND deleted = 0);

-- JAMB 2025 Commerce - Item 38 - Question 38
SET @source_marker := 'JAMB 2025 Commerce - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 38 - Question 38</small></p><p><strong>JAMB 2025 Commerce - Question 38</strong></p><p>Use the following information below to answer the question<br>\nOjo bought a bicycle for ₦20,000, and repaired it at a cost of ₦5,000. He then sold the bicycle for ₦30,000<br>\nWhat was his net profit?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦5,000', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦5,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦15,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦15,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦35,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦35,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦25,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦25,000' AND deleted = 0);

-- JAMB 2025 Commerce - Item 39 - Question 39
SET @source_marker := 'JAMB 2025 Commerce - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 39 - Question 39</small></p><p><strong>JAMB 2025 Commerce - Question 39</strong></p><p>Use the following information below to answer the question<br>\nOjo bought a bicycle for ₦20,000, and repaired it at a cost of ₦5,000. He then sold the bicycle for ₦30,000<br>\nWhat is the percentage of expenses over cost?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '25%', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '25%' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '17%', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '17%' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '33%', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '33%' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '50%', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '50%' AND deleted = 0);

-- JAMB 2025 Commerce - Item 40 - Question 40
SET @source_marker := 'JAMB 2025 Commerce - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 40 - Question 40</small></p><p><strong>JAMB 2025 Commerce - Question 40</strong></p><p>Use the following information below to answer the question<br>\nOjo bought a bicycle for #20,000, and repaired it at a cost of #5,000. He then sold the bicycle for ₦30,000<br>\nWhat is the cost of goods sold?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦20,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦20,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦30,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦30,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦15,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦15,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '₦25,000', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '₦25,000' AND deleted = 0);

-- JAMB 2025 Commerce - Item 41 - Question 41
SET @source_marker := 'JAMB 2025 Commerce - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 41 - Question 41</small></p><p><strong>JAMB 2025 Commerce - Question 41</strong></p><p>A worker who processes garri is engaged in</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exchange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exchange' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'extracting', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'extracting' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'constructing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'constructing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufacturing', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufacturing' AND deleted = 0);

-- JAMB 2025 Commerce - Item 42 - Question 42
SET @source_marker := 'JAMB 2025 Commerce - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 42 - Question 42</small></p><p><strong>JAMB 2025 Commerce - Question 42</strong></p><p>The charge paid to a ship owner for the unused part of a ship is known as</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'penalty', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'penalty' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dead freight', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dead freight' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dock dues', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dock dues' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demurrage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demurrage' AND deleted = 0);

-- JAMB 2025 Commerce - Item 43 - Question 43
SET @source_marker := 'JAMB 2025 Commerce - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 43 - Question 43</small></p><p><strong>JAMB 2025 Commerce - Question 43</strong></p><p>A trader&#39;s turnover was D36,000. Purchases was D28,000. The opening stock was D2,000 and the closing stock D3,000. The average<br>\nstock is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'D3,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'D3,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'D2,500', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'D2,500' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'D5,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'D5,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'D2,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'D2,000' AND deleted = 0);

-- JAMB 2025 Commerce - Item 44 - Question 44
SET @source_marker := 'JAMB 2025 Commerce - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 44 - Question 44</small></p><p><strong>JAMB 2025 Commerce - Question 44</strong></p><p>Which of the following is the clearing house for all the banks in the country?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The Nigerian Industrial Development Bank', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The Nigerian Industrial Development Bank' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The Central Bank of Nigeria', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The Central Bank of Nigeria' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The Nigerian Bank for Commerce and Industry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The Nigerian Bank for Commerce and Industry' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The Federal Mortgage Bank of Nigeria', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The Federal Mortgage Bank of Nigeria' AND deleted = 0);

-- JAMB 2025 Commerce - Item 45 - Question 45
SET @source_marker := 'JAMB 2025 Commerce - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 45 - Question 45</small></p><p><strong>JAMB 2025 Commerce - Question 45</strong></p><p>An insurance policy that covers the body of the ship only is called</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Voyage insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Voyage insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Haulage insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Haulage insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hull insurance', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hull insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cargo insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cargo insurance' AND deleted = 0);

-- JAMB 2025 Commerce - Item 46 - Question 46
SET @source_marker := 'JAMB 2025 Commerce - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 46 - Question 46</small></p><p><strong>JAMB 2025 Commerce - Question 46</strong></p><p>Encouraging a high quality of member&#39;s products through the circulation of research information is a function of</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Consumers'' Association', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Consumers'' Association' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Manufacturers Association', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Manufacturers Association' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Employers'' Association', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Employers'' Association' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trade Union', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trade Union' AND deleted = 0);

-- JAMB 2025 Commerce - Item 47 - Question 47
SET @source_marker := 'JAMB 2025 Commerce - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 47 - Question 47</small></p><p><strong>JAMB 2025 Commerce - Question 47</strong></p><p>Which of the following carries specialized goods?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ferry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ferry' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Liner', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Liner' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tanker', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tanker' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tramp', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tramp' AND deleted = 0);

-- JAMB 2025 Commerce - Item 48 - Question 48
SET @source_marker := 'JAMB 2025 Commerce - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 48 - Question 48</small></p><p><strong>JAMB 2025 Commerce - Question 48</strong></p><p>The transfer of risks already undertaken from one insurance company to another is?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Re-insurance', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Re-insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Under insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Under insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Over-insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Over-insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Group insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Group insurance' AND deleted = 0);

-- JAMB 2025 Commerce - Item 49 - Question 49
SET @source_marker := 'JAMB 2025 Commerce - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 49 - Question 49</small></p><p><strong>JAMB 2025 Commerce - Question 49</strong></p><p>All activities involved in the distribution and exchange of goods and services are referred to as</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'market survey', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'market survey' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'advertising', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'advertising' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commerce', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commerce' AND deleted = 0);

-- JAMB 2025 Commerce - Item 50 - Question 50
SET @source_marker := 'JAMB 2025 Commerce - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 50 - Question 50</small></p><p><strong>JAMB 2025 Commerce - Question 50</strong></p><p>The process of making goods attractive and easy to handle is&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'labelling', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'labelling' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'branding', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'branding' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'packaging', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'packaging' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'merchandising', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'merchandising' AND deleted = 0);

-- JAMB 2025 Commerce - Item 51 - Question 51
SET @source_marker := 'JAMB 2025 Commerce - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 51 - Question 51</small></p><p><strong>JAMB 2025 Commerce - Question 51</strong></p><p>The selling of articles from place to place on foot is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'barter', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'barter' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'itinerant trading', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'itinerant trading' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mail order', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mail order' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'self service', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'self service' AND deleted = 0);

-- JAMB 2025 Commerce - Item 52 - Question 52
SET @source_marker := 'JAMB 2025 Commerce - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 52 - Question 52</small></p><p><strong>JAMB 2025 Commerce - Question 52</strong></p><p>A company which acquires more than 50% voting shares of another company is called?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a consortium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a consortium' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a cartel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a cartel' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a holding company', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a holding company' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a trust', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a trust' AND deleted = 0);

-- JAMB 2025 Commerce - Item 53 - Question 53
SET @source_marker := 'JAMB 2025 Commerce - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 53 - Question 53</small></p><p><strong>JAMB 2025 Commerce - Question 53</strong></p><p>Mr&nbsp;ojo borrowed N54,000 from a commercial bank and deposited his life insurance certificate with the bank. The certificate<br>\ndeposited serves as</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a current asset', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a current asset' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a collateral security', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a collateral security' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an interest charged', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an interest charged' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a loan repayment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a loan repayment' AND deleted = 0);

-- JAMB 2025 Commerce - Item 54 - Question 54
SET @source_marker := 'JAMB 2025 Commerce - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 54 - Question 54</small></p><p><strong>JAMB 2025 Commerce - Question 54</strong></p><p>Which of the following legislation aims primarily at protection of consumers?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trade Description Act', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trade Description Act' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Partnership Act', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Partnership Act' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Law of Contract', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Law of Contract' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Company''s Act', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Company''s Act' AND deleted = 0);

-- JAMB 2025 Commerce - Item 55 - Question 55
SET @source_marker := 'JAMB 2025 Commerce - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 55 - Question 55</small></p><p><strong>JAMB 2025 Commerce - Question 55</strong></p><p>A disadvantage of commercialization to consumers is that</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'customers do not have value for their money', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'customers do not have value for their money' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it reduces loyalty of workers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it reduces loyalty of workers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it promotes inefficiency', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it promotes inefficiency' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prices of products increase', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'prices of products increase' AND deleted = 0);

-- JAMB 2025 Commerce - Item 56 - Question 56
SET @source_marker := 'JAMB 2025 Commerce - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 56 - Question 56</small></p><p><strong>JAMB 2025 Commerce - Question 56</strong></p><p>The process of placing the right people in the right position is an organization is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'directing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'directing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'motivating', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'motivating' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'planning', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'planning' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'staffing', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'staffing' AND deleted = 0);

-- JAMB 2025 Commerce - Item 57 - Question 57
SET @source_marker := 'JAMB 2025 Commerce - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 57 - Question 57</small></p><p><strong>JAMB 2025 Commerce - Question 57</strong></p><p>Commercial activities among West African countries are greatly hindered by</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nationalization decree', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nationalization decree' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'good road network', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'good road network' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lack of an acceptable medium of exchange', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lack of an acceptable medium of exchange' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'too many commercial banks', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'too many commercial banks' AND deleted = 0);

-- JAMB 2025 Commerce - Item 58 - Question 58
SET @source_marker := 'JAMB 2025 Commerce - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 58 - Question 58</small></p><p><strong>JAMB 2025 Commerce - Question 58</strong></p><p>Which of the following is not a principle of insurance?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Insurable risk', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Insurable risk' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Insurable interest', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Insurable interest' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Indemnity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Indemnity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Subrogation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Subrogation' AND deleted = 0);

-- JAMB 2025 Commerce - Item 59 - Question 59
SET @source_marker := 'JAMB 2025 Commerce - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 59 - Question 59</small></p><p><strong>JAMB 2025 Commerce - Question 59</strong></p><p>Use the information below to answer questions below</p>\n\n&lt;table&gt;\n\t&lt;tbody&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;&nbsp;&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;#</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Sales</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>50,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Debtors</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>10,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Cash in hand</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>5,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Opening stock</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>30,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Creditors</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>8,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Purchases</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>16,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Overdraft</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>12,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t\t&lt;tr&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>Closing stock</p>\n\t\t\t&lt;/td&gt;\n\t\t\t&lt;td&gt;\n\t\t\t<p>10,000.00</p>\n\t\t\t&lt;/td&gt;\n\t\t&lt;/tr&gt;\n\t&lt;/tbody&gt;\n&lt;/table&gt;\n\n<p>Calculate the working capital</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '#35,000.00', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '#35,000.00' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '#14,000.00', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '#14,000.00' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '#5,000.00', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '#5,000.00' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '#20,000.00', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '#20,000.00' AND deleted = 0);

-- JAMB 2025 Commerce - Item 60 - Question 60
SET @source_marker := 'JAMB 2025 Commerce - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 60 - Question 60</small></p><p><strong>JAMB 2025 Commerce - Question 60</strong></p><p>Labour and entrepreneur are examples of</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'primary production', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'primary production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'direct services', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'direct services' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'factors of production', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'factors of production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'division of labour', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'division of labour' AND deleted = 0);

-- JAMB 2025 Commerce - Item 61 - Question 61
SET @source_marker := 'JAMB 2025 Commerce - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 61 - Question 61</small></p><p><strong>JAMB 2025 Commerce - Question 61</strong></p><p>An organization of producers of similar products, which controls output with the intention to fix price is a</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cartel', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cartel' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trust', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trust' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'syndicate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'syndicate' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consortium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consortium' AND deleted = 0);

-- JAMB 2025 Commerce - Item 62 - Question 62
SET @source_marker := 'JAMB 2025 Commerce - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 62 - Question 62</small></p><p><strong>JAMB 2025 Commerce - Question 62</strong></p><p>A source of capital to a public company which attracts a fixed rate of interest is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an ordinary share', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an ordinary share' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a debenture', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a debenture' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a subvention', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a subvention' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an overdraft', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an overdraft' AND deleted = 0);

-- JAMB 2025 Commerce - Item 63 - Question 63
SET @source_marker := 'JAMB 2025 Commerce - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 63 - Question 63</small></p><p><strong>JAMB 2025 Commerce - Question 63</strong></p><p>The duty of an agent of necessity to a principal is based on?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Negotiation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Negotiation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trust', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trust' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ability', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ability' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mutual agreement', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mutual agreement' AND deleted = 0);

-- JAMB 2025 Commerce - Item 64 - Question 64
SET @source_marker := 'JAMB 2025 Commerce - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 64 - Question 64</small></p><p><strong>JAMB 2025 Commerce - Question 64</strong></p><p>A false statement made by one party with an intention of inducing the other party to enter into a contract with him is known as</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consensus ad idem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consensus ad idem' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'legal capacity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'legal capacity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consideration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consideration' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'misrepresentation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'misrepresentation' AND deleted = 0);

-- JAMB 2025 Commerce - Item 65 - Question 65
SET @source_marker := 'JAMB 2025 Commerce - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 65 - Question 65</small></p><p><strong>JAMB 2025 Commerce - Question 65</strong></p><p>The difference between the cost price and selling price of an article is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rebate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rebate' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mark-up', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mark-up' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'discount', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'discount' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commission' AND deleted = 0);

-- JAMB 2025 Commerce - Item 66 - Question 66
SET @source_marker := 'JAMB 2025 Commerce - Item 66 - Question 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 66 - Question 66</small></p><p><strong>JAMB 2025 Commerce - Question 66</strong></p><p>One of the functions of the ports authority is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enforcing law and order in harbors', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'enforcing law and order in harbors' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'checking the activities of smugglers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'checking the activities of smugglers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'collecting import duties', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'collecting import duties' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'providing warehousing services', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'providing warehousing services' AND deleted = 0);

-- JAMB 2025 Commerce - Item 67 - Question 67
SET @source_marker := 'JAMB 2025 Commerce - Item 67 - Question 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 67 - Question 67</small></p><p><strong>JAMB 2025 Commerce - Question 67</strong></p><p>A limited company has an authorized capital of 20,000,000 shares. If each share capital cost 50k and the company sold 12,000,000<br>\nshares. Its issued capital is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N16,000,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N16,000,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N4,000,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N4,000,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N10,000,000', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N10,000,000' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N6,000,000', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N6,000,000' AND deleted = 0);

-- JAMB 2025 Commerce - Item 68 - Question 68
SET @source_marker := 'JAMB 2025 Commerce - Item 68 - Question 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 68 - Question 68</small></p><p><strong>JAMB 2025 Commerce - Question 68</strong></p><p>A diagram showing the positions of the structure of a company is</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'organizational chart', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'organizational chart' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'flow chart', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'flow chart' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'span of control', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'span of control' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'vertical integration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'vertical integration' AND deleted = 0);

-- JAMB 2025 Commerce - Item 69 - Question 69
SET @source_marker := 'JAMB 2025 Commerce - Item 69 - Question 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 69 - Question 69</small></p><p><strong>JAMB 2025 Commerce - Question 69</strong></p><p>Span of control is defined as the</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'authority of the supervisor', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'authority of the supervisor' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'number of subordinates reporting directly to a supervisor', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'number of subordinates reporting directly to a supervisor' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'qualification possessed by the supervisor', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'qualification possessed by the supervisor' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'number of staff in the organization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'number of staff in the organization' AND deleted = 0);

-- JAMB 2025 Commerce - Item 70 - Question 70
SET @source_marker := 'JAMB 2025 Commerce - Item 70 - Question 70';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 70 - Question 70</small></p><p><strong>JAMB 2025 Commerce - Question 70</strong></p><p>The production of goods in anticipation of demand is possible because of the existence of?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Advertising', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Advertising' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Branding', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Branding' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Packaging', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Packaging' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Warehousing', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Warehousing' AND deleted = 0);

-- JAMB 2025 Commerce - Item 71 - Question 71
SET @source_marker := 'JAMB 2025 Commerce - Item 71 - Question 71';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 71 - Question 71</small></p><p><strong>JAMB 2025 Commerce - Question 71</strong></p><p>Which of the following is not pre-sale service?</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Repair and maintenance work', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Repair and maintenance work' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Setting up facilities for storing the product to be bought', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Setting up facilities for storing the product to be bought' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Demonstrating the use and performance of the product to be sold', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Demonstrating the use and performance of the product to be sold' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Providing detailed information about the goods to be purchased', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Providing detailed information about the goods to be purchased' AND deleted = 0);

-- JAMB 2025 Commerce - Item 72 - Question 72
SET @source_marker := 'JAMB 2025 Commerce - Item 72 - Question 72';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 72 - Question 72</small></p><p><strong>JAMB 2025 Commerce - Question 72</strong></p><p>The mode of transport that conveys goods at low cost per unit is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rail', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rail' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'air', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'air' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'road', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'road' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pipeline', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pipeline' AND deleted = 0);

-- JAMB 2025 Commerce - Item 73 - Question 73
SET @source_marker := 'JAMB 2025 Commerce - Item 73 - Question 73';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 73 - Question 73</small></p><p><strong>JAMB 2025 Commerce - Question 73</strong></p><p>All activities geared towards the distribution and exchange of goods and services is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commerce', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commerce' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'market survey', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'market survey' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personal selling', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personal selling' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trade' AND deleted = 0);

-- JAMB 2025 Commerce - Item 74 - Question 74
SET @source_marker := 'JAMB 2025 Commerce - Item 74 - Question 74';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 74 - Question 74</small></p><p><strong>JAMB 2025 Commerce - Question 74</strong></p><p>An example of in invisible item of trade is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'textile', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'textile' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'machinery', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'machinery' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oil', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oil' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shipping', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'shipping' AND deleted = 0);

-- JAMB 2025 Commerce - Item 75 - Question 75
SET @source_marker := 'JAMB 2025 Commerce - Item 75 - Question 75';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 75 - Question 75</small></p><p><strong>JAMB 2025 Commerce - Question 75</strong></p><p>The saying that the &#39;consumer is always right&#39; describes the doctrine of</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consumer protection', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consumer protection' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'proximate cause', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'proximate cause' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consumer sovereignty', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consumer sovereignty' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'caveat emptor', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'caveat emptor' AND deleted = 0);

-- JAMB 2025 Commerce - Item 76 - Question 76
SET @source_marker := 'JAMB 2025 Commerce - Item 76 - Question 76';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 76 - Question 76</small></p><p><strong>JAMB 2025 Commerce - Question 76</strong></p><p>The part of issued share capital that the company has asked the subscribers to pay for</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nominal capital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nominal capital' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'paid-up capital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'paid-up capital' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'authorized capital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'authorized capital' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'called-up capital', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'called-up capital' AND deleted = 0);

-- JAMB 2025 Commerce - Item 77 - Question 77
SET @source_marker := 'JAMB 2025 Commerce - Item 77 - Question 77';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 77 - Question 77</small></p><p><strong>JAMB 2025 Commerce - Question 77</strong></p><p>A put option in the stock exchange is an option</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to buy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'to buy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'not to sell', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'not to sell' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'not to buy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'not to buy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to sell', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'to sell' AND deleted = 0);

-- JAMB 2025 Commerce - Item 78 - Question 78
SET @source_marker := 'JAMB 2025 Commerce - Item 78 - Question 78';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 78 - Question 78</small></p><p><strong>JAMB 2025 Commerce - Question 78</strong></p><p>The grading of products to satisfy different buyers is referred to as?</p>\n\n<p>&nbsp;</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Product differentiation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Product differentiation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Product line', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Product line' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Product concept', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Product concept' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Product mix', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Product mix' AND deleted = 0);

-- JAMB 2025 Commerce - Item 79 - Question 79
SET @source_marker := 'JAMB 2025 Commerce - Item 79 - Question 79';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 79 - Question 79</small></p><p><strong>JAMB 2025 Commerce - Question 79</strong></p><p>The purpose for which the Central Bank sells securities is to</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reduce the interest rate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reduce the interest rate' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase the interest rate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase the interest rate' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase cash in the economy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase cash in the economy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reduce cash in the economy', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reduce cash in the economy' AND deleted = 0);

-- JAMB 2025 Commerce - Item 80 - Question 80
SET @source_marker := 'JAMB 2025 Commerce - Item 80 - Question 80';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Commerce - Item 80 - Question 80</small></p><p><strong>JAMB 2025 Commerce - Question 80</strong></p><p>The document issued by the registrar of companies to permit a public limited company to commence business is</p>\n\n<p>&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Memorandum of Association', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Memorandum of Association' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Article of Association', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Article of Association' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trading certificate', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trading certificate' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Certificate of Incorporation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Certificate of Incorporation' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS jamb_2025_commerce_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2025
  AND question LIKE '%JAMB 2025 Commerce - Item%';
