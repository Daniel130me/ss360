-- JAMB 2024 Commerce objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2024_commerce/jamb_2024_commerce_import_manifest.json for exact per-item source URLs).
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

DROP PROCEDURE IF EXISTS ss360_require_jamb_2024_commerce_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2024_commerce_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Commerce subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2024_commerce_refs();
DROP PROCEDURE ss360_require_jamb_2024_commerce_refs;

START TRANSACTION;

-- JAMB 2024 Commerce - Item 1 - Question 1
SET @source_marker := 'JAMB 2024 Commerce - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 1 - Question 1</small></p><p><strong>JAMB 2024 Commerce - Question 1</strong></p><p>Which of the following is NOT part of Pre-Sales Service/ice?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'granting of credit or hire purchase sales facilities', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'granting of credit or hire purchase sales facilities' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'assisting the prospective buyer to set up facilities for storage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'assisting the prospective buyer to set up facilities for storage' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dispatching of quotation and price list', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dispatching of quotation and price list' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'providing detailed information about goods to be purchased', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'providing detailed information about goods to be purchased' AND deleted = 0);

-- JAMB 2024 Commerce - Item 2 - Question 2
SET @source_marker := 'JAMB 2024 Commerce - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 2 - Question 2</small></p><p><strong>JAMB 2024 Commerce - Question 2</strong></p><p>Which of the following does a seller send in reply to a letter of inquiry?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quotation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'quotation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'credit note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'credit note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'debit note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'debit note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'delivery note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'delivery note' AND deleted = 0);

-- JAMB 2024 Commerce - Item 3 - Question 3
SET @source_marker := 'JAMB 2024 Commerce - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 3 - Question 3</small></p><p><strong>JAMB 2024 Commerce - Question 3</strong></p><p>The sum which the insured pays periodically to his insurance company is called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a commission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a commission' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an indemnity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an indemnity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a policy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a policy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a premium', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a premium' AND deleted = 0);

-- JAMB 2024 Commerce - Item 4 - Question 4
SET @source_marker := 'JAMB 2024 Commerce - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 4 - Question 4</small></p><p><strong>JAMB 2024 Commerce - Question 4</strong></p><p>The main objective of nationalization of industries is to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prevent existing firms from liquidation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'prevent existing firms from liquidation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Make more profit for the government', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Make more profit for the government' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prevent all aliens from taking part in the business activities of a country', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'prevent all aliens from taking part in the business activities of a country' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bring an Industry under state ownership and control', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bring an Industry under state ownership and control' AND deleted = 0);

-- JAMB 2024 Commerce - Item 5 - Question 5
SET @source_marker := 'JAMB 2024 Commerce - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 5 - Question 5</small></p><p><strong>JAMB 2024 Commerce - Question 5</strong></p><p>Closing stock is also known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stock at close', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'stock at close' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'balance brought forward', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'balance brought forward' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'opening inventory', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'opening inventory' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stock at beginning', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'stock at beginning' AND deleted = 0);

-- JAMB 2024 Commerce - Item 6 - Question 6
SET @source_marker := 'JAMB 2024 Commerce - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 6 - Question 6</small></p><p><strong>JAMB 2024 Commerce - Question 6</strong></p><p>The first Nigerian enterprises promotion decree was promulgated in</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1972', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1972' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1973', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1973' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1974', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1974' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1977', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1977' AND deleted = 0);

-- JAMB 2024 Commerce - Item 7 - Question 7
SET @source_marker := 'JAMB 2024 Commerce - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 7 - Question 7</small></p><p><strong>JAMB 2024 Commerce - Question 7</strong></p><p>An agreement that is enforceable in law is called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an offer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an offer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a decree', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a decree' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a contract', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a contract' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a declaration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a declaration' AND deleted = 0);

-- JAMB 2024 Commerce - Item 8 - Question 8
SET @source_marker := 'JAMB 2024 Commerce - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 8 - Question 8</small></p><p><strong>JAMB 2024 Commerce - Question 8</strong></p><p>A tax paid on goods manufactured and consumed in your country is called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'excise duty', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'excise duty' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'goods tax', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'goods tax' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'income tax', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'income tax' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'custom duty', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'custom duty' AND deleted = 0);

-- JAMB 2024 Commerce - Item 9 - Question 9
SET @source_marker := 'JAMB 2024 Commerce - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 9 - Question 9</small></p><p><strong>JAMB 2024 Commerce - Question 9</strong></p><p>Which of the following is NOT an aim of advertising?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inspiring public confidence in the goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inspiring public confidence in the goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'arousing the interest of the public', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'arousing the interest of the public' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reducing the cost of the goods produced', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reducing the cost of the goods produced' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'attracting the attention of the public', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'attracting the attention of the public' AND deleted = 0);

-- JAMB 2024 Commerce - Item 10 - Question 10
SET @source_marker := 'JAMB 2024 Commerce - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 10 - Question 10</small></p><p><strong>JAMB 2024 Commerce - Question 10</strong></p><p>Prospectus in relation to a public limited inability company means</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a document stating the types or shares', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a document stating the types or shares' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an invitation to the public to collect dividends', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an invitation to the public to collect dividends' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an invitation to the public to buy shares', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an invitation to the public to buy shares' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a document where the names of shareholders are written', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a document where the names of shareholders are written' AND deleted = 0);

-- JAMB 2024 Commerce - Item 11 - Question 11
SET @source_marker := 'JAMB 2024 Commerce - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 11 - Question 11</small></p><p><strong>JAMB 2024 Commerce - Question 11</strong></p><p>An allowance made to a customer for prompt payment is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bulk discount', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bulk discount' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commission' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cash discount', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cash discount' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'allowance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'allowance' AND deleted = 0);

-- JAMB 2024 Commerce - Item 12 - Question 12
SET @source_marker := 'JAMB 2024 Commerce - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 12 - Question 12</small></p><p><strong>JAMB 2024 Commerce - Question 12</strong></p><p>A person who runs a business on his own account is called a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'customer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'customer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sole trader', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sole trader' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'director', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'director' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'partner', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'partner' AND deleted = 0);

-- JAMB 2024 Commerce - Item 13 - Question 13
SET @source_marker := 'JAMB 2024 Commerce - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 13 - Question 13</small></p><p><strong>JAMB 2024 Commerce - Question 13</strong></p><p>All the following are principles of insurance EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'insurable interest', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'insurable interest' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'particular average', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'particular average' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'utmost good faith', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'utmost good faith' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'subrogation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'subrogation' AND deleted = 0);

-- JAMB 2024 Commerce - Item 14 - Question 14
SET @source_marker := 'JAMB 2024 Commerce - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 14 - Question 14</small></p><p><strong>JAMB 2024 Commerce - Question 14</strong></p><p>One of the following does NOT fit into the group.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'agriculture', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'agriculture' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carpentry', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'carpentry' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fishing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fishing' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mining', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mining' AND deleted = 0);

-- JAMB 2024 Commerce - Item 15 - Question 15
SET @source_marker := 'JAMB 2024 Commerce - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 15 - Question 15</small></p><p><strong>JAMB 2024 Commerce - Question 15</strong></p><p>A public limited liability company is owned by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'government', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'government' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shareholders', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'shareholders' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'general public', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'general public' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'debenture holders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'debenture holders' AND deleted = 0);

-- JAMB 2024 Commerce - Item 16 - Question 16
SET @source_marker := 'JAMB 2024 Commerce - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 16 - Question 16</small></p><p><strong>JAMB 2024 Commerce - Question 16</strong></p><p>An instruction to an agent abroad restricting him to buy from a named manufacturer is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pro forma invoice', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pro forma invoice' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an open indent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an open indent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a closed indent', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a closed indent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an order', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an order' AND deleted = 0);

-- JAMB 2024 Commerce - Item 17 - Question 17
SET @source_marker := 'JAMB 2024 Commerce - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 17 - Question 17</small></p><p><strong>JAMB 2024 Commerce - Question 17</strong></p><p>Which of the following can be used to establish an importer&#39;s title to goods?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cargo receipt', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cargo receipt' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'way bill', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'way bill' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bill of lading', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bill of lading' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'import license', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'import license' AND deleted = 0);

-- JAMB 2024 Commerce - Item 18 - Question 18
SET @source_marker := 'JAMB 2024 Commerce - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 18 - Question 18</small></p><p><strong>JAMB 2024 Commerce - Question 18</strong></p><p>Fishing is an example of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'direct services', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'direct services' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufacturing industry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufacturing industry' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'extractive industry', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'extractive industry' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'construction industry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'construction industry' AND deleted = 0);

-- JAMB 2024 Commerce - Item 19 - Question 19
SET @source_marker := 'JAMB 2024 Commerce - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 19 - Question 19</small></p><p><strong>JAMB 2024 Commerce - Question 19</strong></p><p>Which of the following CANNOT be sold through a vending machine?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shoes', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'shoes' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tickets', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tickets' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'snacks', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'snacks' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tea', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tea' AND deleted = 0);

-- JAMB 2024 Commerce - Item 20 - Question 20
SET @source_marker := 'JAMB 2024 Commerce - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 20 - Question 20</small></p><p><strong>JAMB 2024 Commerce - Question 20</strong></p><p>The rights of the consumers does NOT include</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the right to a healthy environment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the right to a healthy environment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the right to be informed', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the right to be informed' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the right to fix prices', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the right to fix prices' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the right to choose', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the right to choose' AND deleted = 0);

-- JAMB 2024 Commerce - Item 21 - Question 21
SET @source_marker := 'JAMB 2024 Commerce - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 21 - Question 21</small></p><p><strong>JAMB 2024 Commerce - Question 21</strong></p><p>Banks issue cheque books to customers holding ___________ accounts.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'foreign', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'foreign' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'current', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'current' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deposit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'deposit' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fixed deposit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fixed deposit' AND deleted = 0);

-- JAMB 2024 Commerce - Item 22 - Question 22
SET @source_marker := 'JAMB 2024 Commerce - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 22 - Question 22</small></p><p><strong>JAMB 2024 Commerce - Question 22</strong></p><p>A bill of exchange sold for less than its face value before maturity is said to be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protested', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'protested' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cleared', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cleared' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dishonored', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dishonored' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'discounted', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'discounted' AND deleted = 0);

-- JAMB 2024 Commerce - Item 23 - Question 23
SET @source_marker := 'JAMB 2024 Commerce - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 23 - Question 23</small></p><p><strong>JAMB 2024 Commerce - Question 23</strong></p><p>A multiple shop has many stores which sell</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufactured goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufactured goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'locally produced goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'locally produced goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'perishable goods', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'perishable goods' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'similar goods', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'similar goods' AND deleted = 0);

-- JAMB 2024 Commerce - Item 24 - Question 24
SET @source_marker := 'JAMB 2024 Commerce - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 24 - Question 24</small></p><p><strong>JAMB 2024 Commerce - Question 24</strong></p><p>The relationship between a country&#39;s visible imports and exports in a trading year is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'balance of trade', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'balance of trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'counter trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'counter trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'international trade', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'international trade' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'balance of payment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'balance of payment' AND deleted = 0);

-- JAMB 2024 Commerce - Item 25 - Question 25
SET @source_marker := 'JAMB 2024 Commerce - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 25 - Question 25</small></p><p><strong>JAMB 2024 Commerce - Question 25</strong></p><p>Which of the following warehouse is generally found near a port?<br>\n&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'producer''s warehouse', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'producer''s warehouse' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bonded warehouse', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bonded warehouse' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'distributor''s warehouse', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'distributor''s warehouse' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufacturer''s warehouse', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufacturer''s warehouse' AND deleted = 0);

-- JAMB 2024 Commerce - Item 26 - Question 26
SET @source_marker := 'JAMB 2024 Commerce - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 26 - Question 26</small></p><p><strong>JAMB 2024 Commerce - Question 26</strong></p><p>The service rendered by NIPOST in which letters are addressed to any post office to await collection by the addressee is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'business reply service', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'business reply service' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cash on delivery service', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cash on delivery service' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'free post service', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'free post service' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'express mail service', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'express mail service' AND deleted = 0);

-- JAMB 2024 Commerce - Item 27 - Question 27
SET @source_marker := 'JAMB 2024 Commerce - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 27 - Question 27</small></p><p><strong>JAMB 2024 Commerce - Question 27</strong></p><p>Which area of law is NOT related to business?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'agency', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'agency' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hire purchase', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hire purchase' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'possession', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'possession' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contract', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'contract' AND deleted = 0);

-- JAMB 2024 Commerce - Item 28 - Question 28
SET @source_marker := 'JAMB 2024 Commerce - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 28 - Question 28</small></p><p><strong>JAMB 2024 Commerce - Question 28</strong></p><p>A holding company is one which holds shares in another company up to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '51%', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '51%' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '41%', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '41%' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '33%', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '33%' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '25%', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '25%' AND deleted = 0);

-- JAMB 2024 Commerce - Item 29 - Question 29
SET @source_marker := 'JAMB 2024 Commerce - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 29 - Question 29</small></p><p><strong>JAMB 2024 Commerce - Question 29</strong></p><p>The breaking down of work into different processes is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'production', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'production' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'division of labour', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'division of labour' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'specialization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'specialization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exchange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exchange' AND deleted = 0);

-- JAMB 2024 Commerce - Item 30 - Question 30
SET @source_marker := 'JAMB 2024 Commerce - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 30 - Question 30</small></p><p><strong>JAMB 2024 Commerce - Question 30</strong></p><p>Which of the following is NOT regarded as a welfare service in an organization?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'training', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'training' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'medical facilities', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'medical facilities' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transportation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'transportation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'recreational facilities', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'recreational facilities' AND deleted = 0);

-- JAMB 2024 Commerce - Item 31 - Question 31
SET @source_marker := 'JAMB 2024 Commerce - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 31 - Question 31</small></p><p><strong>JAMB 2024 Commerce - Question 31</strong></p><p>The policy designed to accelerate the greater participation of Nigerians in the ownership and management of business enterprises in Nigeria is called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nationalisation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nationalisation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'indigenity', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'indigenity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commercialization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commercialization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'industrialization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'industrialization' AND deleted = 0);

-- JAMB 2024 Commerce - Item 32 - Question 32
SET @source_marker := 'JAMB 2024 Commerce - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 32 - Question 32</small></p><p><strong>JAMB 2024 Commerce - Question 32</strong></p><p>Which of these is used in calculating working capital?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'furniture and fittings', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'furniture and fittings' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stock of raw material', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'stock of raw material' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'machinery', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'machinery' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'office equipment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'office equipment' AND deleted = 0);

-- JAMB 2024 Commerce - Item 33 - Question 33
SET @source_marker := 'JAMB 2024 Commerce - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 33 - Question 33</small></p><p><strong>JAMB 2024 Commerce - Question 33</strong></p><p>Obi received a cheque for #1000 from Mr. Ade and this cheque was stolen. He must</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inform Mr. Ade to tell his bank to stop payment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inform Mr. Ade to tell his bank to stop payment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inform his bank to stop payment', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inform his bank to stop payment' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'simply ask Mr. Ade for another cheque', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'simply ask Mr. Ade for another cheque' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tell his bank to add the amount to his bank balance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tell his bank to add the amount to his bank balance' AND deleted = 0);

-- JAMB 2024 Commerce - Item 34 - Question 34
SET @source_marker := 'JAMB 2024 Commerce - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 34 - Question 34</small></p><p><strong>JAMB 2024 Commerce - Question 34</strong></p><p>A contract in which all parties to the contract have carried out their obligation is said to be terminated by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'performance', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'performance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'breach of contract', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'breach of contract' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'operation of the law', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'operation of the law' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'frustration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'frustration' AND deleted = 0);

-- JAMB 2024 Commerce - Item 35 - Question 35
SET @source_marker := 'JAMB 2024 Commerce - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 35 - Question 35</small></p><p><strong>JAMB 2024 Commerce - Question 35</strong></p><p>The deliberate throwing of some goods into the sea to prevent the ship from sinking is an example of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'constructive total loss', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'constructive total loss' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an actual total loss', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an actual total loss' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a general average loss', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a general average loss' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a partial loss', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a partial loss' AND deleted = 0);

-- JAMB 2024 Commerce - Item 36 - Question 36
SET @source_marker := 'JAMB 2024 Commerce - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 36 - Question 36</small></p><p><strong>JAMB 2024 Commerce - Question 36</strong></p><p>Which of the following is NOT part of the marketing mix?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'place', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'place' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'promotion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'promotion' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'price', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'price' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personnel', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personnel' AND deleted = 0);

-- JAMB 2024 Commerce - Item 37 - Question 37
SET @source_marker := 'JAMB 2024 Commerce - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 37 - Question 37</small></p><p><strong>JAMB 2024 Commerce - Question 37</strong></p><p>Shares are said to be sold at a discount when they are sold</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'below par', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'below par' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'to the public', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'to the public' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'at par', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'at par' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'above par', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'above par' AND deleted = 0);

-- JAMB 2024 Commerce - Item 38 - Question 38
SET @source_marker := 'JAMB 2024 Commerce - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 38 - Question 38</small></p><p><strong>JAMB 2024 Commerce - Question 38</strong></p><p>When the price quoted includes all the cost to the actual destination, that is, from the seller&#39;s warehouse to the buyer&#39;s warehouse. it is called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'loco price', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'loco price' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'franco', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'franco' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carriage paid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'carriage paid' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cash on delivery', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cash on delivery' AND deleted = 0);

-- JAMB 2024 Commerce - Item 39 - Question 39
SET @source_marker := 'JAMB 2024 Commerce - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 39 - Question 39</small></p><p><strong>JAMB 2024 Commerce - Question 39</strong></p><p>The body charged with the responsibility monitoring the quality of goods supplied is the</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufacturers'' association', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufacturers'' association' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chamber of commerce', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'chamber of commerce' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nigerian standards organization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nigerian standards organization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consumers'' association', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consumers'' association' AND deleted = 0);

-- JAMB 2024 Commerce - Item 40 - Question 40
SET @source_marker := 'JAMB 2024 Commerce - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 40 - Question 40</small></p><p><strong>JAMB 2024 Commerce - Question 40</strong></p><p>The difference between the higher prices and the lower prices quoted for shares and stocks at the stock exchange is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commission' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'brokerage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'brokerage' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'interest', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'interest' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'jobbers turn', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'jobbers turn' AND deleted = 0);

-- JAMB 2024 Commerce - Item 41 - Question 41
SET @source_marker := 'JAMB 2024 Commerce - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 41 - Question 41</small></p><p><strong>JAMB 2024 Commerce - Question 41</strong></p><p>Stock exchange quoted the shares of ABC Plc at #0.75K for #1.25K per share. This means the shares were sold at a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'par value', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'par value' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'premium', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'premium' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gain', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gain' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'loss', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'loss' AND deleted = 0);

-- JAMB 2024 Commerce - Item 42 - Question 42
SET @source_marker := 'JAMB 2024 Commerce - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 42 - Question 42</small></p><p><strong>JAMB 2024 Commerce - Question 42</strong></p><p>The components of a balance of payments account are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'capital, current and fixed deposit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'capital, current and fixed deposit' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'current, capital and monetary movement', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'current, capital and monetary movement' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'capital, savings and fixed deposit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'capital, savings and fixed deposit' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'current, savings and monetary movement', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'current, savings and monetary movement' AND deleted = 0);

-- JAMB 2024 Commerce - Item 43 - Question 43
SET @source_marker := 'JAMB 2024 Commerce - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 43 - Question 43</small></p><p><strong>JAMB 2024 Commerce - Question 43</strong></p><p>Ships that pick up cargo from any port and travels anytime are called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ferries', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ferries' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tankers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tankers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tramps', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tramps' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'steamers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'steamers' AND deleted = 0);

-- JAMB 2024 Commerce - Item 44 - Question 44
SET @source_marker := 'JAMB 2024 Commerce - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 44 - Question 44</small></p><p><strong>JAMB 2024 Commerce - Question 44</strong></p><p>Which of the following advertising media preselects its readership through the nature of its content?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Magazine', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Magazine' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Billboard', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Billboard' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hand bill', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hand bill' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Newspaper', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Newspaper' AND deleted = 0);

-- JAMB 2024 Commerce - Item 45 - Question 45
SET @source_marker := 'JAMB 2024 Commerce - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 45 - Question 45</small></p><p><strong>JAMB 2024 Commerce - Question 45</strong></p><p>Branding is the assigning of trade marks to goods for the purpose of......... by the public.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'demand', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'demand' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'replacement', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'replacement' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stabilization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'stabilization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'identification', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'identification' AND deleted = 0);

-- JAMB 2024 Commerce - Item 46 - Question 46
SET @source_marker := 'JAMB 2024 Commerce - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 46 - Question 46</small></p><p><strong>JAMB 2024 Commerce - Question 46</strong></p><p>Which of the following services is NOT rendered by NITEL?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Data Transmission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Data Transmission' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Recorded Delivery', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Recorded Delivery' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Satellite', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Satellite' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Telex', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Telex' AND deleted = 0);

-- JAMB 2024 Commerce - Item 47 - Question 47
SET @source_marker := 'JAMB 2024 Commerce - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 47 - Question 47</small></p><p><strong>JAMB 2024 Commerce - Question 47</strong></p><p>The act of being on one job for expertise is called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'separation of power', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'separation of power' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'immobility', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'immobility' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'independence', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'independence' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'specialization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'specialization' AND deleted = 0);

-- JAMB 2024 Commerce - Item 48 - Question 48
SET @source_marker := 'JAMB 2024 Commerce - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 48 - Question 48</small></p><p><strong>JAMB 2024 Commerce - Question 48</strong></p><p>Which type of advertisement induces consumer to purchase the goods he does not need?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Specific', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Specific' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Informative', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Informative' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Persuasive', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Persuasive' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Descriptive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Descriptive' AND deleted = 0);

-- JAMB 2024 Commerce - Item 49 - Question 49
SET @source_marker := 'JAMB 2024 Commerce - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 49 - Question 49</small></p><p><strong>JAMB 2024 Commerce - Question 49</strong></p><p>Tariff can be defined as a compulsory levy on</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'import and export', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'import and export' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'foreign exchange earnings', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'foreign exchange earnings' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'imported goods only', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'imported goods only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'foreigners working in Nigeria', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'foreigners working in Nigeria' AND deleted = 0);

-- JAMB 2024 Commerce - Item 50 - Question 50
SET @source_marker := 'JAMB 2024 Commerce - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 50 - Question 50</small></p><p><strong>JAMB 2024 Commerce - Question 50</strong></p><p>Which of the following is NOT a credit instrument?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bill of Exchange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bill of Exchange' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bank Notes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bank Notes' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cheques', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cheques' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bill of Lading', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bill of Lading' AND deleted = 0);

-- JAMB 2024 Commerce - Item 51 - Question 51
SET @source_marker := 'JAMB 2024 Commerce - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 51 - Question 51</small></p><p><strong>JAMB 2024 Commerce - Question 51</strong></p><p>Transfer of ownership of goods sold under Hire Purchase System takes place when</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'two instalment have been', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'two instalment have been' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a quarter of the total price is', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a quarter of the total price is' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'half of the total price is paid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'half of the total price is paid' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the final instalment is paid', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the final instalment is paid' AND deleted = 0);

-- JAMB 2024 Commerce - Item 52 - Question 52
SET @source_marker := 'JAMB 2024 Commerce - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 52 - Question 52</small></p><p><strong>JAMB 2024 Commerce - Question 52</strong></p><p>The document which gives complete information about the goods sold is the</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'invoice', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'invoice' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'order form', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'order form' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'delivery note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'delivery note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bill of exchange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bill of exchange' AND deleted = 0);

-- JAMB 2024 Commerce - Item 53 - Question 53
SET @source_marker := 'JAMB 2024 Commerce - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 53 - Question 53</small></p><p><strong>JAMB 2024 Commerce - Question 53</strong></p><p>A typical example of an event covered by an Assurance Policy is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'accident', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'accident' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'death', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'death' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'burglary', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'burglary' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fire', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fire' AND deleted = 0);

-- JAMB 2024 Commerce - Item 54 - Question 54
SET @source_marker := 'JAMB 2024 Commerce - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 54 - Question 54</small></p><p><strong>JAMB 2024 Commerce - Question 54</strong></p><p>The functions of public corporations include the following EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'providing essential services to the public', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'providing essential services to the public' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'maximizing profits for the board members', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'maximizing profits for the board members' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'providing even development', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'providing even development' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'providing employment opportunities', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'providing employment opportunities' AND deleted = 0);

-- JAMB 2024 Commerce - Item 55 - Question 55
SET @source_marker := 'JAMB 2024 Commerce - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 55 - Question 55</small></p><p><strong>JAMB 2024 Commerce - Question 55</strong></p><p>Which of the following forms part of a company&#39;s Article of Association?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nature and object of the business', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nature and object of the business' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Registered office', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Registered office' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Goodwill and status of shareholders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Goodwill and status of shareholders' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Name of the company', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Name of the company' AND deleted = 0);

-- JAMB 2024 Commerce - Item 56 - Question 56
SET @source_marker := 'JAMB 2024 Commerce - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 56 - Question 56</small></p><p><strong>JAMB 2024 Commerce - Question 56</strong></p><p>A wholesaler who acts as an agent on behalf of the owner of the goods in buying or selling for a commission proportionate to the value of the transaction is called a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commissioned agent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commissioned agent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'del-credere agent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'del-credere agent' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'factor', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'factor' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'speculator', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'speculator' AND deleted = 0);

-- JAMB 2024 Commerce - Item 57 - Question 57
SET @source_marker := 'JAMB 2024 Commerce - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 57 - Question 57</small></p><p><strong>JAMB 2024 Commerce - Question 57</strong></p><p>The coming together of two or more firms with each of them losing its identity is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'holding', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'holding' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consortium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consortium' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cartel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cartel' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'amalgamation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'amalgamation' AND deleted = 0);

-- JAMB 2024 Commerce - Item 58 - Question 58
SET @source_marker := 'JAMB 2024 Commerce - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 58 - Question 58</small></p><p><strong>JAMB 2024 Commerce - Question 58</strong></p><p>Use the information below to answer this question.<br>\nAisha sold her wristwatch to Halima for #2,000.00 and she paid. The sum of #2,000.00 is the</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'entitlement', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'entitlement' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'consideration', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'consideration' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'money', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'money' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fees', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fees' AND deleted = 0);

-- JAMB 2024 Commerce - Item 59 - Question 59
SET @source_marker := 'JAMB 2024 Commerce - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 59 - Question 59</small></p><p><strong>JAMB 2024 Commerce - Question 59</strong></p><p>The term &quot;consumer sovereignty&quot; means that the consumer is a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'promoter', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'promoter' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'king', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'king' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manager', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manager' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'director', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'director' AND deleted = 0);

-- JAMB 2024 Commerce - Item 60 - Question 60
SET @source_marker := 'JAMB 2024 Commerce - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 60 - Question 60</small></p><p><strong>JAMB 2024 Commerce - Question 60</strong></p><p>The activities concerned with changing of raw materials into finished products belong to __occupation.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commercial', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commercial' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'extractive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'extractive' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'constructive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'constructive' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufacturing', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufacturing' AND deleted = 0);

-- JAMB 2024 Commerce - Item 61 - Question 61
SET @source_marker := 'JAMB 2024 Commerce - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 61 - Question 61</small></p><p><strong>JAMB 2024 Commerce - Question 61</strong></p><p>The following are functions of marketing EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'packaging', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'packaging' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'distribution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'distribution' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'insurance', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'insurance' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'advertising', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'advertising' AND deleted = 0);

-- JAMB 2024 Commerce - Item 62 - Question 62
SET @source_marker := 'JAMB 2024 Commerce - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 62 - Question 62</small></p><p><strong>JAMB 2024 Commerce - Question 62</strong></p><p>The documents sent by the suppliers of good to a prospective buyer, informing him of what to pay if he buys the good is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'credit note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'credit note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'advice note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'advice note' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'invoice', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'invoice' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'debt note', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'debt note' AND deleted = 0);

-- JAMB 2024 Commerce - Item 63 - Question 63
SET @source_marker := 'JAMB 2024 Commerce - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 63 - Question 63</small></p><p><strong>JAMB 2024 Commerce - Question 63</strong></p><p>Departmental store, supermarket and chain store are examples of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'small scale retailers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'small scale retailers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'medium scale producers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'medium scale producers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'large scale retailers', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'large scale retailers' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'large scale whole-salers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'large scale whole-salers' AND deleted = 0);

-- JAMB 2024 Commerce - Item 64 - Question 64
SET @source_marker := 'JAMB 2024 Commerce - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 64 - Question 64</small></p><p><strong>JAMB 2024 Commerce - Question 64</strong></p><p>The rules and regulations guiding the conduct of business transactions are known as law</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'criminal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'criminal' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'common', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'common' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'contract', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'contract' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'commercial', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'commercial' AND deleted = 0);

-- JAMB 2024 Commerce - Item 65 - Question 65
SET @source_marker := 'JAMB 2024 Commerce - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 65 - Question 65</small></p><p><strong>JAMB 2024 Commerce - Question 65</strong></p><p>The principle of insurance which ensures that an individual is restored to his former position after suffering a loss is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'utmost good faith', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'utmost good faith' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'insurable interest', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'insurable interest' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'indemnity', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'indemnity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'subrogation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'subrogation' AND deleted = 0);

-- JAMB 2024 Commerce - Item 66 - Question 66
SET @source_marker := 'JAMB 2024 Commerce - Item 66 - Question 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 66 - Question 66</small></p><p><strong>JAMB 2024 Commerce - Question 66</strong></p><p>The aid to trade which enables producer and consumer to transact business without physical contact is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tourism', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tourism' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'communication', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'communication' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'advertising', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'advertising' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'insurance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'insurance' AND deleted = 0);

-- JAMB 2024 Commerce - Item 67 - Question 67
SET @source_marker := 'JAMB 2024 Commerce - Item 67 - Question 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 67 - Question 67</small></p><p><strong>JAMB 2024 Commerce - Question 67</strong></p><p>The association that encourages savings for the benefit of its members is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Consumer association', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Consumer association' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Credit and thrift co-operative society', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Credit and thrift co-operative society' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Consumer co-operative society', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Consumer co-operative society' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Producer co-operative society', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Producer co-operative society' AND deleted = 0);

-- JAMB 2024 Commerce - Item 68 - Question 68
SET @source_marker := 'JAMB 2024 Commerce - Item 68 - Question 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 68 - Question 68</small></p><p><strong>JAMB 2024 Commerce - Question 68</strong></p><p>Bonded warehouse is controlled and supervised by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'customs', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'customs' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'navy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'navy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'immigration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'immigration' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'police', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'police' AND deleted = 0);

-- JAMB 2024 Commerce - Item 69 - Question 69
SET @source_marker := 'JAMB 2024 Commerce - Item 69 - Question 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 69 - Question 69</small></p><p><strong>JAMB 2024 Commerce - Question 69</strong></p><p>The advertising medium which uses electric current in bulbs is referred to as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'posters', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'posters' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'television', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'television' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neon signs', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'neon signs' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bill boards', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bill boards' AND deleted = 0);

-- JAMB 2024 Commerce - Item 70 - Question 70
SET @source_marker := 'JAMB 2024 Commerce - Item 70 - Question 70';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 70 - Question 70</small></p><p><strong>JAMB 2024 Commerce - Question 70</strong></p><p>Which of these is NOT a governments legislation to protect the consumer?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Foods and drugs', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Foods and drugs' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Weight and measure', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Weight and measure' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Privatization and commercialization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Privatization and commercialization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trade description', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trade description' AND deleted = 0);

-- JAMB 2024 Commerce - Item 71 - Question 71
SET @source_marker := 'JAMB 2024 Commerce - Item 71 - Question 71';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 71 - Question 71</small></p><p><strong>JAMB 2024 Commerce - Question 71</strong></p><p>A ship which has no fixed schedule and travels wherever it can find cargoes to carry is a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'liner', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'liner' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tanker', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tanker' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tramp', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tramp' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ferry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ferry' AND deleted = 0);

-- JAMB 2024 Commerce - Item 72 - Question 72
SET @source_marker := 'JAMB 2024 Commerce - Item 72 - Question 72';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 72 - Question 72</small></p><p><strong>JAMB 2024 Commerce - Question 72</strong></p><p>The Nigeria Enterprises promotion Decree brought about policy</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nationalization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nationalization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'industrialization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'industrialization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'indigenization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'indigenization' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'privatization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'privatization' AND deleted = 0);

-- JAMB 2024 Commerce - Item 73 - Question 73
SET @source_marker := 'JAMB 2024 Commerce - Item 73 - Question 73';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 73 - Question 73</small></p><p><strong>JAMB 2024 Commerce - Question 73</strong></p><p>In the event of winding up of a company, who among the following is paid last?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Preference Shareholders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Preference Shareholders' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ordinary shareholders', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ordinary shareholders' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cumulative preference shareholders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cumulative preference shareholders' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Debenture holders', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Debenture holders' AND deleted = 0);

-- JAMB 2024 Commerce - Item 74 - Question 74
SET @source_marker := 'JAMB 2024 Commerce - Item 74 - Question 74';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 74 - Question 74</small></p><p><strong>JAMB 2024 Commerce - Question 74</strong></p><p>Gross profit can be calculated as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sales minus purchases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sales minus purchases' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sales minus cost of good sold', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sales minus cost of good sold' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cost of goods available for sales minus sale', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cost of goods available for sales minus sale' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cost of good sold minus cost of goods available for sale', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cost of good sold minus cost of goods available for sale' AND deleted = 0);

-- JAMB 2024 Commerce - Item 75 - Question 75
SET @source_marker := 'JAMB 2024 Commerce - Item 75 - Question 75';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 75 - Question 75</small></p><p><strong>JAMB 2024 Commerce - Question 75</strong></p><p>One of the easiest means of transporting petroleum product is by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pipeline', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pipeline' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'air', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'air' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'road', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'road' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rail', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rail' AND deleted = 0);

-- JAMB 2024 Commerce - Item 76 - Question 76
SET @source_marker := 'JAMB 2024 Commerce - Item 76 - Question 76';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 76 - Question 76</small></p><p><strong>JAMB 2024 Commerce - Question 76</strong></p><p>A dealer who buys securities at low prices in anticipation of reselling them at higher prices is called a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'jobber', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'jobber' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bull', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bull' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'broker', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'broker' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bear', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bear' AND deleted = 0);

-- JAMB 2024 Commerce - Item 77 - Question 77
SET @source_marker := 'JAMB 2024 Commerce - Item 77 - Question 77';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 77 - Question 77</small></p><p><strong>JAMB 2024 Commerce - Question 77</strong></p><p>The term &quot;caveat emptor&quot; implies that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'goods have been transferred to the buyer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'goods have been transferred to the buyer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'let the buyer beware', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'let the buyer beware' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'let the seller beware', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'let the seller beware' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'goods are still with the seller', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'goods are still with the seller' AND deleted = 0);

-- JAMB 2024 Commerce - Item 78 - Question 78
SET @source_marker := 'JAMB 2024 Commerce - Item 78 - Question 78';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 78 - Question 78</small></p><p><strong>JAMB 2024 Commerce - Question 78</strong></p><p>Which of the following types of insurance is usually excluded from the principle of indemnity?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fire', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fire' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fidelity Guarantee', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fidelity Guarantee' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Marine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Marine' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Life', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Life' AND deleted = 0);

-- JAMB 2024 Commerce - Item 79 - Question 79
SET @source_marker := 'JAMB 2024 Commerce - Item 79 - Question 79';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 79 - Question 79</small></p><p><strong>JAMB 2024 Commerce - Question 79</strong></p><p>A type of partnership in which all partners have unlimited liability and jointly manage the business is known as partnership.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ordinary', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ordinary' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nominal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nominal' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unlimited', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unlimited' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Limited', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Limited' AND deleted = 0);

-- JAMB 2024 Commerce - Item 80 - Question 80
SET @source_marker := 'JAMB 2024 Commerce - Item 80 - Question 80';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Commerce - Item 80 - Question 80</small></p><p><strong>JAMB 2024 Commerce - Question 80</strong></p><p>An agent held responsible for non-payment of goods bought by the customer he introduced to his principal is called agent</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'general', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'general' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'special', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'special' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sales', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sales' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'del-credere', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'del-credere' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS jamb_2024_commerce_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2024
  AND question LIKE '%JAMB 2024 Commerce - Item%';
