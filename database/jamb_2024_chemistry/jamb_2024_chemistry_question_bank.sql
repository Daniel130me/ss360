-- JAMB 2024 Chemistry objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2024_chemistry/jamb_2024_chemistry_import_manifest.json for exact per-item source URLs).
-- Expected payload: 138 questions and 552 options.
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
INSERT INTO exam_bodies (name, description)
SELECT 'JAMB', 'Joint Admissions and Matriculation Board'
WHERE NOT EXISTS (SELECT 1 FROM exam_bodies WHERE name = 'JAMB');

SET @exam_body_id := (SELECT id FROM exam_bodies WHERE name = 'JAMB' ORDER BY id ASC LIMIT 1);
SET @subject_id := (SELECT id FROM subjects WHERE subject = 'Chemistry' ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_jamb_2024_chemistry_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2024_chemistry_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chemistry subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2024_chemistry_refs();
DROP PROCEDURE ss360_require_jamb_2024_chemistry_refs;

START TRANSACTION;

-- JAMB 2024 Chemistry - Item 1 - Question 1
SET @source_marker := 'JAMB 2024 Chemistry - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 1 - Question 1</small></p><p><strong>JAMB 2024 Chemistry - Question 1</strong></p><p>At a given temperature and pressure, a gas X diffuses twice as fast as gas Y. It follows that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gas Y is two times as heavy as Gas X', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Gas Y is two times as heavy as Gas X' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gas Y is four times as heavy as Gas X', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Gas Y is four times as heavy as Gas X' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gas Y is monoatomic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Gas Y is monoatomic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gas X is diatomic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Gas X is diatomic' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 2 - Question 2
SET @source_marker := 'JAMB 2024 Chemistry - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 2 - Question 2</small></p><p><strong>JAMB 2024 Chemistry - Question 2</strong></p><p>The number of molecules of helium gas contained in 11.5g of the gas is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{23}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{23}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{22}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{22}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{21}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.73 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{21}"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 3 - Question 3
SET @source_marker := 'JAMB 2024 Chemistry - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 3 - Question 3</small></p><p><strong>JAMB 2024 Chemistry - Question 3</strong></p><p>The constituents of Alnico are Aluminium, Nickel and </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mg', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mg' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Co', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Co' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mn', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mn' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cu', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cu' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 4 - Question 4
SET @source_marker := 'JAMB 2024 Chemistry - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 4 - Question 4</small></p><p><strong>JAMB 2024 Chemistry - Question 4</strong></p><p>Silver and Gold are metals found as free uncombined elements in the earth&#039;s crust, which makes them to be referred to as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'corrosive metals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'corrosive metals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reactive metals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reactive metals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'natural metals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'natural metals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'noble metals', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'noble metals' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 5 - Question 5
SET @source_marker := 'JAMB 2024 Chemistry - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 5 - Question 5</small></p><p><strong>JAMB 2024 Chemistry - Question 5</strong></p><p>In the extraction of Aluminium, the silica impurity is removed by </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'electrolysis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'electrolysis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'filtration', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'filtration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reaction with H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reaction with H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'precipitation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'precipitation' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 6 - Question 6
SET @source_marker := 'JAMB 2024 Chemistry - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 6 - Question 6</small></p><p><strong>JAMB 2024 Chemistry - Question 6</strong></p><p>When Calcium ethynide is decomposed by water, the gas produced is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 7 - Question 7
SET @source_marker := 'JAMB 2024 Chemistry - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 7 - Question 7</small></p><p><strong>JAMB 2024 Chemistry - Question 7</strong></p><p>The constituent of petroleum fraction used in surfacing road is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'petrol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'petrol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'diesel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'diesel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lubricating oil', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lubricating oil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bitumen', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bitumen' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 8 - Question 8
SET @source_marker := 'JAMB 2024 Chemistry - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 8 - Question 8</small></p><p><strong>JAMB 2024 Chemistry - Question 8</strong></p><p>During the fractional distillation of crude oil, the fraction that distills at 200 - 250<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span> C is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bitumen', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bitumen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'diesel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'diesel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'kerosene', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'kerosene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'petrol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'petrol' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 9 - Question 9
SET @source_marker := 'JAMB 2024 Chemistry - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 9 - Question 9</small></p><p><strong>JAMB 2024 Chemistry - Question 9</strong></p><p>A liquid hydrocarbon obtained from fractional distillation of coal tar that is used in the pharmaceutical industry is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'xylene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'xylene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'benzene', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'benzene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hexane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hexane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Toluene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Toluene' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 10 - Question 10
SET @source_marker := 'JAMB 2024 Chemistry - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 10 - Question 10</small></p><p><strong>JAMB 2024 Chemistry - Question 10</strong></p><p>An organic compound contains 53.1% Carbon, 6.2% Hydrogen, 12.4% Nitrogen, and 28.3% Oxygen by mass. What is the molecular formula of the compound if its vapour density is 56.5?   [ C =12, H = 1, N = 14, O = 16]. </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span>NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 11 - Question 11
SET @source_marker := 'JAMB 2024 Chemistry - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 11 - Question 11</small></p><p><strong>JAMB 2024 Chemistry - Question 11</strong></p><p>The empirical formula of an organic liquid hydrocarbon is XY. If the relative molar masses of X and Y are 72 and 6 respectively, it&#039;s vapour density is likely to be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '33', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '33' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '66', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '66' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '39', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '39' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '78', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '78' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 12 - Question 12
SET @source_marker := 'JAMB 2024 Chemistry - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 12 - Question 12</small></p><p><strong>JAMB 2024 Chemistry - Question 12</strong></p><p>Biuret test is a chemical test used for detecting the presence of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carbohydrates', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'carbohydrates' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'proteins', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'proteins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'amines', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'amines' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoates', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoates' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 13 - Question 13
SET @source_marker := 'JAMB 2024 Chemistry - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 13 - Question 13</small></p><p><strong>JAMB 2024 Chemistry - Question 13</strong></p><p>A gas when mixed with oxygen, it produces a very hot and early controllable flame. What is the name of the flame and where is it used?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Acetylene flame; miners&#039; lamb', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Acetylene flame; miners&#039; lamb' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oxy-ethylene ; hunters&#039; torch', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oxy-ethylene ; hunters&#039; torch' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oxy-ethylene flame; miners&#039; lamb', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oxy-ethylene flame; miners&#039; lamb' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oxy-ethylene flame ; cutting and welding metals', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oxy-ethylene flame ; cutting and welding metals' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 14 - Question 14
SET @source_marker := 'JAMB 2024 Chemistry - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 14 - Question 14</small></p><p><strong>JAMB 2024 Chemistry - Question 14</strong></p><p>The number of geometrical isomers of butene are </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 15 - Question 15
SET @source_marker := 'JAMB 2024 Chemistry - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 15 - Question 15</small></p><p><strong>JAMB 2024 Chemistry - Question 15</strong></p><p>How many isomers has the organic compound represented by the formula C<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_8"></span>O ?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 16 - Question 16
SET @source_marker := 'JAMB 2024 Chemistry - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 16 - Question 16</small></p><p><strong>JAMB 2024 Chemistry - Question 16</strong></p><p>When a few drops of Millon reagents is added to egg-white solution in a test tube, the white precipitate changes to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'orange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'orange' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'brick red', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'brick red' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reddish brown', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reddish brown' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'blue', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'blue' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 17 - Question 17
SET @source_marker := 'JAMB 2024 Chemistry - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 17 - Question 17</small></p><p><strong>JAMB 2024 Chemistry - Question 17</strong></p><p>If the solubility of KNO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> at 30<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span>C is 3.10 mol/dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> a solution containing 303g/dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> KNO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> is likely to be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'saturated', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'saturated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unsaturated', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unsaturated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'supersaturated', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'supersaturated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'at saturation point', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'at saturation point' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 18 - Question 18
SET @source_marker := 'JAMB 2024 Chemistry - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 18 - Question 18</small></p><p><strong>JAMB 2024 Chemistry - Question 18</strong></p><p>127g of sodium chloride was dissolved in 1.0dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> of distilled water at 25<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span>C . Determine the solubility in moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^{-3}"></span> of sodium chloride at that temperature. [Na = 23, Cl = 35.5] </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.2', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.1', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.1' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 19 - Question 19
SET @source_marker := 'JAMB 2024 Chemistry - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 19 - Question 19</small></p><p><strong>JAMB 2024 Chemistry - Question 19</strong></p><p>The quantity of electricity required to deposit 180g of Ag from a molten silver trioxonitrate(V) is</p>

<p>[Ag = 108]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.08F', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.08F' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.30F', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.30F' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.67F', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.67F' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.80F', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.80F' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 20 - Question 20
SET @source_marker := 'JAMB 2024 Chemistry - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 20 - Question 20</small></p><p><strong>JAMB 2024 Chemistry - Question 20</strong></p><p>What would be the order of the electrolytic cell in an industry intending the production of silver plated spoons?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cathode is the spoon; anode is a silver rod; electrolyte is a soluble silver salt', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cathode is the spoon; anode is a silver rod; electrolyte is a soluble silver salt' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cathode is a silver rod; anode is the spoon; electrolyte is a soluble silver salt', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cathode is a silver rod; anode is the spoon; electrolyte is a soluble silver salt' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cathode is the spoon; anode is any rod; electrolyte is a soluble silver salt', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cathode is the spoon; anode is any rod; electrolyte is a soluble silver salt' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cathode is any rod; anode is the spoon; electrolyte is a soluble salt', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cathode is any rod; anode is the spoon; electrolyte is a soluble salt' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 21 - Question 21
SET @source_marker := 'JAMB 2024 Chemistry - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 21 - Question 21</small></p><p><strong>JAMB 2024 Chemistry - Question 21</strong></p><p><img src="../uploads/question_bank/jamb_2024_chemistry/Q21_diagram.png" alt="Diagram for JAMB 2024 Chemistry Question 21" style="max-width:100%;height:auto;"></p><p>The table above shows the formulae of some ions. In which of these compounds is the formula not correct?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Aluminiumtetraoxosulphate(VI), Al<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>(SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Aluminiumtetraoxosulphate(VI), Al<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>(SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Calciumtrioxonitrate(V), Ca(NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Calciumtrioxonitrate(V), Ca(NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Iron(III)bromide, Fe<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>Br', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Iron(III)bromide, Fe<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>Br' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Potassiumsulphide, K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>S', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Potassiumsulphide, K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>S' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 22 - Question 22
SET @source_marker := 'JAMB 2024 Chemistry - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 22 - Question 22</small></p><p><strong>JAMB 2024 Chemistry - Question 22</strong></p><p>The pH of a 0.001 mol dm<span contenteditable="false" class="math-editor-rendered" data-latex="^{-3}"></span> of  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> is </p>

<p>[Log<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>2 = 0.3]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.7', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.7' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.0' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 23 - Question 23
SET @source_marker := 'JAMB 2024 Chemistry - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 23 - Question 23</small></p><p><strong>JAMB 2024 Chemistry - Question 23</strong></p><p>Strong acids can be distinguished from weak acids by any of the following methods, EXCEPT</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Conductivity measurement', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Conductivity measurement' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The use of litmus paper', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The use of litmus paper' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Measurement of pH', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Measurement of pH' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Measurement of heat of reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Measurement of heat of reaction' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 24 - Question 24
SET @source_marker := 'JAMB 2024 Chemistry - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 24 - Question 24</small></p><p><strong>JAMB 2024 Chemistry - Question 24</strong></p><p>The chemical formula for potassiumhexacyanoferrate(II) is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '[Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>]<span contenteditable="false" class="math-editor-rendered" data-latex="^{4-}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '[Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>]<span contenteditable="false" class="math-editor-rendered" data-latex="^{4-}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'K<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'K<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'K<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'K<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 25 - Question 25
SET @source_marker := 'JAMB 2024 Chemistry - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 25 - Question 25</small></p><p><strong>JAMB 2024 Chemistry - Question 25</strong></p><p>For chemical reaction to be spontaneous, ∆G must be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'positive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'positive' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'negative', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'negative' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'zero', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'zero' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'equal to the enthalpy change', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'equal to the enthalpy change' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 26 - Question 26
SET @source_marker := 'JAMB 2024 Chemistry - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 26 - Question 26</small></p><p><strong>JAMB 2024 Chemistry - Question 26</strong></p><p>How many moles of CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> are produced when ethanol is burnt with 6g of oxygen</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.125', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.125' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.250', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.250' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.375', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.375' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.750', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.750' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 27 - Question 27
SET @source_marker := 'JAMB 2024 Chemistry - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 27 - Question 27</small></p><p><strong>JAMB 2024 Chemistry - Question 27</strong></p><p>Which of these is the most preferred separation technique for the isolation of solutes where the purity of the constituent is of utmost importance?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sieving', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sieving' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Distillation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Distillation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'recrystallization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'recrystallization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Precipitation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Precipitation' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 28 - Question 28
SET @source_marker := 'JAMB 2024 Chemistry - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 28 - Question 28</small></p><p><strong>JAMB 2024 Chemistry - Question 28</strong></p><p><img src="../uploads/question_bank/jamb_2024_chemistry/Q28_diagram.png" alt="Diagram for JAMB 2024 Chemistry Question 28" style="max-width:100%;height:auto;"></p><p>In the graph above, y represents </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'endothermic reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'endothermic reaction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'activation energy', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'activation energy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exothermic reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exothermic reaction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ionization energy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ionization energy' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 29 - Question 29
SET @source_marker := 'JAMB 2024 Chemistry - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 29 - Question 29</small></p><p><strong>JAMB 2024 Chemistry - Question 29</strong></p><p>The ions responsible for permanent hardness in water are sulphates of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fe<span contenteditable="false" class="math-editor-rendered" data-latex="^{3+}"></span> and Mg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fe<span contenteditable="false" class="math-editor-rendered" data-latex="^{3+}"></span> and Mg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ca<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> and Mg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ca<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> and Mg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fe<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> and Fe<span contenteditable="false" class="math-editor-rendered" data-latex="^{3+}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fe<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> and Fe<span contenteditable="false" class="math-editor-rendered" data-latex="^{3+}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Na<span contenteditable="false" class="math-editor-rendered" data-latex="^{+}"></span> and Ca<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Na<span contenteditable="false" class="math-editor-rendered" data-latex="^{+}"></span> and Ca<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 30 - Question 30
SET @source_marker := 'JAMB 2024 Chemistry - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 30 - Question 30</small></p><p><strong>JAMB 2024 Chemistry - Question 30</strong></p><p>One of the following is not a water pollutant?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Inorganic fertilizers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Inorganic fertilizers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Warm water affluent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Warm water affluent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oxygen gas', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oxygen gas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Biodegradable waste', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Biodegradable waste' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 31 - Question 31
SET @source_marker := 'JAMB 2024 Chemistry - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 31 - Question 31</small></p><p><strong>JAMB 2024 Chemistry - Question 31</strong></p><p>CuO<span contenteditable="false" class="math-editor-rendered" data-latex="_s"></span>   +  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>(<span contenteditable="false" class="math-editor-rendered" data-latex="_g"></span>)  ⇌ Cu<span contenteditable="false" class="math-editor-rendered" data-latex="_s"></span>   +  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O(<span contenteditable="false" class="math-editor-rendered" data-latex="_g"></span>)</p>

<p>In the equation above, the effect of increased pressure on the equilibrium position is that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the equilibrium is shifted to the left', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the equilibrium is shifted to the left' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the equilibrium is shifted to the right', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the equilibrium is shifted to the right' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'there is no effect', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'there is no effect' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'more H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(g"></span>) is produced', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'more H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(g"></span>) is produced' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 32 - Question 32
SET @source_marker := 'JAMB 2024 Chemistry - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 32 - Question 32</small></p><p><strong>JAMB 2024 Chemistry - Question 32</strong></p><p>What method is suitable for the separation of gases present in air?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Catalytic cracking of liquid air', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Catalytic cracking of liquid air' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fractional distillation of liquid air', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fractional distillation of liquid air' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Thermal decomposition of air', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Thermal decomposition of air' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Catalytic decomposition of air', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Catalytic decomposition of air' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 33 - Question 33
SET @source_marker := 'JAMB 2024 Chemistry - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 33 - Question 33</small></p><p><strong>JAMB 2024 Chemistry - Question 33</strong></p><p>The principle which states that no two electrons in the same orbitals of an atom have same value for all four quantum numbers is the</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Aufbau principle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Aufbau principle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hund&#039;s rule', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hund&#039;s rule' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pauli Exclusion principle', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pauli Exclusion principle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Dilution principle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Dilution principle' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 34 - Question 34
SET @source_marker := 'JAMB 2024 Chemistry - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 34 - Question 34</small></p><p><strong>JAMB 2024 Chemistry - Question 34</strong></p><p>How much of 5g of radioactive element whose half life is 50days remains after 200days?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.50 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.50 g' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.25 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.25 g' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.63 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.63 g' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.31 g', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.31 g' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 35 - Question 35
SET @source_marker := 'JAMB 2024 Chemistry - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 35 - Question 35</small></p><p><strong>JAMB 2024 Chemistry - Question 35</strong></p><p>The group VIII elements are the inert gases because they </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have lone pair of electrons on their valence shells', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'have lone pair of electrons on their valence shells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'all have completely filled valence shells', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'all have completely filled valence shells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'are all solids', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'are all solids' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'are all polyatomic molecules', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'are all polyatomic molecules' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 36 - Question 36
SET @source_marker := 'JAMB 2024 Chemistry - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 36 - Question 36</small></p><p><strong>JAMB 2024 Chemistry - Question 36</strong></p><p>Na<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>X  ⇌  2Na<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>  +  X<span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span></p>

<p>The bond between Na and X is likely to be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'covalent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'covalent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dative', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dative' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ionic', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ionic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metallic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metallic' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 37 - Question 37
SET @source_marker := 'JAMB 2024 Chemistry - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 37 - Question 37</small></p><p><strong>JAMB 2024 Chemistry - Question 37</strong></p><p>The highest isotope of hydrogen is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Deuterium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Deuterium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'protium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tritium', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tritium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'positron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'positron' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 38 - Question 38
SET @source_marker := 'JAMB 2024 Chemistry - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 38 - Question 38</small></p><p><strong>JAMB 2024 Chemistry - Question 38</strong></p><p>When Sulphur(IV)oxide is passed into solution of acidified tetraoxomanganate(VII), the colour changes from </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'blue to green', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'blue to green' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pink to yellow', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pink to yellow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'purple to colourless', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'purple to colourless' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Orange to green', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Orange to green' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 39 - Question 39
SET @source_marker := 'JAMB 2024 Chemistry - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 39 - Question 39</small></p><p><strong>JAMB 2024 Chemistry - Question 39</strong></p><p>Water gas obtained from the gasification of coke is made up of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nitrogen and Carbon(II) oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nitrogen and Carbon(II) oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nitrogen and Hydrogen', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nitrogen and Hydrogen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hydrogen and Carbon(II) oxide', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hydrogen and Carbon(II) oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Carbon(II)oxide and Carbon(IV)oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Carbon(II)oxide and Carbon(IV)oxide' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 40 - Question 40
SET @source_marker := 'JAMB 2024 Chemistry - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 40 - Question 40</small></p><p><strong>JAMB 2024 Chemistry - Question 40</strong></p><p>Sulphur(IV)oxide can be used as a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'coating agent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'coating agent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dehydrating agent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dehydrating agent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'refrigerant', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'refrigerant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'drying agent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'drying agent' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 41 - Question 41
SET @source_marker := 'JAMB 2024 Chemistry - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 41 - Question 41</small></p><p><strong>JAMB 2024 Chemistry - Question 41</strong></p><p>The molecular formular of a hydrocarbon with an empirical formula of CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>  and a molar mass of 30 is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 42 - Question 42
SET @source_marker := 'JAMB 2024 Chemistry - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 42 - Question 42</small></p><p><strong>JAMB 2024 Chemistry - Question 42</strong></p><p>The difference in molecular mass between an alkene and alkyne with six carbon per mole is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '14' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 43 - Question 43
SET @source_marker := 'JAMB 2024 Chemistry - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 43 - Question 43</small></p><p><strong>JAMB 2024 Chemistry - Question 43</strong></p><table>
	<tbody>
		<tr>
			<td><strong>COMPOUND</strong></td>
			<td><strong>S</strong></td>
			<td><strong>T</strong></td>
			<td><strong>U</strong></td>
			<td><strong>V</strong></td>
			<td><strong>W</strong></td>
		</tr>
		<tr>
			<td><strong>FORMULA</strong></td>
			<td><strong>ROR&#039;</strong></td>
			<td><strong>RCOOH&#039;</strong></td>
			<td><strong>RCOR&#039;</strong></td>
			<td><strong>ROH&#039;</strong></td>
			<td><strong>RCOOR&#039;</strong></td>
		</tr>
	</tbody>
</table>

<p>From the table above, which of these two compounds can form functional group isomers?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'S and T', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'S and T' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'T and U', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'T and U' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'S and V', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'S and V' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'T and V', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'T and V' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 44 - Question 44
SET @source_marker := 'JAMB 2024 Chemistry - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 44 - Question 44</small></p><p><strong>JAMB 2024 Chemistry - Question 44</strong></p><p>Fats and oils are esters of fatty organic acids combined with a trihydric alkanol commonly referred to as </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ethanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ethanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'glycol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'glycol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'glycerol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'glycerol' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 45 - Question 45
SET @source_marker := 'JAMB 2024 Chemistry - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 45 - Question 45</small></p><p><strong>JAMB 2024 Chemistry - Question 45</strong></p><p>Determine the half-life of a first order reaction with constant 4.5 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-3}"></span> sec<span contenteditable="false" class="math-editor-rendered" data-latex="^{-1}"></span>.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '154 s', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '154 s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15.4 s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '15.4 s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1540 s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1540 s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.54 s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.54 s' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 46 - Question 46
SET @source_marker := 'JAMB 2024 Chemistry - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 46 - Question 46</small></p><p><strong>JAMB 2024 Chemistry - Question 46</strong></p><p>Alkanoates are naturally found in</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lipids', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lipids' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'vitamins', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'vitamins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'proteins', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'proteins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rubbers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rubbers' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 47 - Question 47
SET @source_marker := 'JAMB 2024 Chemistry - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 47 - Question 47</small></p><p><strong>JAMB 2024 Chemistry - Question 47</strong></p><p>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>-CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>-OH and CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>-O-CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span></p>

<p>The relationship between the two compounds above, is that they are </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'allotropes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'allotropes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'isotopes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'isotopes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'isomers', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'isomers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'isobars', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'isobars' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 48 - Question 48
SET @source_marker := 'JAMB 2024 Chemistry - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 48 - Question 48</small></p><p><strong>JAMB 2024 Chemistry - Question 48</strong></p><p>The composition of alloy permalloy is iron and</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'copper', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'copper' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nickel', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nickel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lead', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lead' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'magnesium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'magnesium' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 49 - Question 49
SET @source_marker := 'JAMB 2024 Chemistry - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 49 - Question 49</small></p><p><strong>JAMB 2024 Chemistry - Question 49</strong></p><p>Aqueous solution of sodium hydroxide can be used to test for the presence of : I. Ca<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> ,   II. Zn<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> ,  III. Cu<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and III', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I and III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I, II and III', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I, II and III' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and II only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I and II only' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 50 - Question 50
SET @source_marker := 'JAMB 2024 Chemistry - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 50 - Question 50</small></p><p><strong>JAMB 2024 Chemistry - Question 50</strong></p><p><img src="../uploads/question_bank/jamb_2024_chemistry/Q50_diagram.png" alt="Diagram for JAMB 2024 Chemistry Question 50" style="max-width:100%;height:auto;"></p><p>The IUPAC nomenclature of the compound above is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propan-1-ol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propan-1-ol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'butan-1-ol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'butan-1-ol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-methyl propan-1-ol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-methyl propan-1-ol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-methyl propan-2-ol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-methyl propan-2-ol' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 51 - Question 51
SET @source_marker := 'JAMB 2024 Chemistry - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 51 - Question 51</small></p><p><strong>JAMB 2024 Chemistry - Question 51</strong></p><p>What is formed when metal reacts with acid to liberate gas?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Salt', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Salt' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Base', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Base' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Liquid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Liquid' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 52 - Question 52
SET @source_marker := 'JAMB 2024 Chemistry - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 52 - Question 52</small></p><p><strong>JAMB 2024 Chemistry - Question 52</strong></p><p>Concentrated sodium chloride solution is electrolyzed using mercury cathode and graphite anode. The products at the anode and the cathode respectively are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen and chlorine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogen and chlorine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chlorine and hydrogen', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'chlorine and hydrogen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chlorine and sodium', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'chlorine and sodium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sodium and chlorine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sodium and chlorine' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 53 - Question 53
SET @source_marker := 'JAMB 2024 Chemistry - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 53 - Question 53</small></p><p><strong>JAMB 2024 Chemistry - Question 53</strong></p><p>A factor that does not affect the rate of a chemical reaction is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'surface area', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'surface area' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'temperature', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'volume', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'volume' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'catalyst', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'catalyst' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 54 - Question 54
SET @source_marker := 'JAMB 2024 Chemistry - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 54 - Question 54</small></p><p><strong>JAMB 2024 Chemistry - Question 54</strong></p><p>In contact process, the catalyst used in the conversion of sulphur(IV)oxide to sulphur(VI) oxide is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nickel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nickel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'platinum', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'platinum' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'vanadium(V)oxide', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'vanadium(V)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'magnesium(IV)oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'magnesium(IV)oxide' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 55 - Question 55
SET @source_marker := 'JAMB 2024 Chemistry - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 55 - Question 55</small></p><p><strong>JAMB 2024 Chemistry - Question 55</strong></p><p>The element which can combine with oxygen to form an acid anhydride of the form XO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'phosphorus', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'phosphorus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Chlorine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Chlorine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fluorine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fluorine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sulphur', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sulphur' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 56 - Question 56
SET @source_marker := 'JAMB 2024 Chemistry - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 56 - Question 56</small></p><p><strong>JAMB 2024 Chemistry - Question 56</strong></p><p>Rust on the surface of a metal sheet contains</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrated iron(II)oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrated iron(II)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrated iron(III)oxide', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrated iron(III)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'iron(III)hydroxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'iron(III)hydroxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'iron(III) trioxocarbonate(IV)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'iron(III) trioxocarbonate(IV)' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 57 - Question 57
SET @source_marker := 'JAMB 2024 Chemistry - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 57 - Question 57</small></p><p><strong>JAMB 2024 Chemistry - Question 57</strong></p><p>A gas that turns lime water milky is likely to be from</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trioxocarbonate(IV)', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trioxocarbonate(IV)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Chloride', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Chloride' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trioxonitrate(V)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trioxonitrate(V)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tetraoxosulphate(VI)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tetraoxosulphate(VI)' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 58 - Question 58
SET @source_marker := 'JAMB 2024 Chemistry - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 58 - Question 58</small></p><p><strong>JAMB 2024 Chemistry - Question 58</strong></p><p>When n = 3, the quantum number of an element is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '9', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '9' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '18' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '21', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '21' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 59 - Question 59
SET @source_marker := 'JAMB 2024 Chemistry - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 59 - Question 59</small></p><p><strong>JAMB 2024 Chemistry - Question 59</strong></p><p>The salt formed when strong acid reacts with strong base is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'normal', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'normal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'double', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'double' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'complex', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'complex' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'basic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'basic' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 60 - Question 60
SET @source_marker := 'JAMB 2024 Chemistry - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 60 - Question 60</small></p><p><strong>JAMB 2024 Chemistry - Question 60</strong></p><p>The shape of the molecule of Carbon(IV) oxide is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tetrahedral', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tetrahedral' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pyramidal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pyramidal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'plannar', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'plannar' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'linear', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'linear' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 61 - Question 61
SET @source_marker := 'JAMB 2024 Chemistry - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 61 - Question 61</small></p><p><strong>JAMB 2024 Chemistry - Question 61</strong></p><p><span contenteditable="false" class="math-editor-rendered" data-latex="^{238}_{92}"></span>U  + <span contenteditable="false" class="math-editor-rendered" data-latex="^1_0"></span>n → <span contenteditable="false" class="math-editor-rendered" data-latex="^{239}_{92}"></span>U </p>

<p>The process above produces </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'atomic mutation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'atomic mutation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a radioactive isotope', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a radioactive isotope' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'other neutrons', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'other neutrons' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'radiations', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'radiations' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 62 - Question 62
SET @source_marker := 'JAMB 2024 Chemistry - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 62 - Question 62</small></p><p><strong>JAMB 2024 Chemistry - Question 62</strong></p><p>Calculate the mass of Magnesium that will be liberated from its salt by the same quantity of electricity that liberated 16.0 g of Silver.</p>

<p>[Mg = 24.0, Ag = 108 ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.65 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.65 g' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.56 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.56 g' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.87 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.87 g' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.78 g', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.78 g' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 63 - Question 63
SET @source_marker := 'JAMB 2024 Chemistry - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 63 - Question 63</small></p><p><strong>JAMB 2024 Chemistry - Question 63</strong></p><p>Which of the following is an air pollutant?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="(_g"></span>)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="(_g"></span>)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'O<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'O<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 64 - Question 64
SET @source_marker := 'JAMB 2024 Chemistry - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 64 - Question 64</small></p><p><strong>JAMB 2024 Chemistry - Question 64</strong></p><p>The volume in cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> of a 0.12 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^{-3}"></span> HCl required to completely neutralize a 20cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> of 0.20 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^{-3}"></span> of NaOH is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12.00', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12.00' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.0012', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.0012' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '33.33', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '33.33' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.40', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.40' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 65 - Question 65
SET @source_marker := 'JAMB 2024 Chemistry - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 65 - Question 65</small></p><p><strong>JAMB 2024 Chemistry - Question 65</strong></p><p>Fog is a colloid in which</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'liquid particles is dispersed in a gas medium', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'liquid particles is dispersed in a gas medium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gas particles dispersed in a liquid medium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gas particles dispersed in a liquid medium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'solid particles dispersed in a gas medium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'solid particles dispersed in a gas medium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gas particles dispersed in a solid medium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gas particles dispersed in a solid medium' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 66 - Question 66
SET @source_marker := 'JAMB 2024 Chemistry - Item 66 - Question 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 66 - Question 66</small></p><p><strong>JAMB 2024 Chemistry - Question 66</strong></p><p>Determine the empirical formula of an oxide of sulphur containing 60% of oxygen </p>

<p>[S = 32, O = 16 ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'SO', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'SO' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 67 - Question 67
SET @source_marker := 'JAMB 2024 Chemistry - Item 67 - Question 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 67 - Question 67</small></p><p><strong>JAMB 2024 Chemistry - Question 67</strong></p><p>The scientist that performed the experiment on discharged tubes that led to the discovery of the cathode rays as a sub-atomic particle is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'J.J Thomson', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'J.J Thomson' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Robert Millikan', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Robert Millikan' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ernest Rutherford', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ernest Rutherford' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Niels Bohr', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Niels Bohr' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 68 - Question 68
SET @source_marker := 'JAMB 2024 Chemistry - Item 68 - Question 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 68 - Question 68</small></p><p><strong>JAMB 2024 Chemistry - Question 68</strong></p><p>In the treatment of water for municipal supply, chlorine is used to </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prevent tooth decay', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'prevent tooth decay' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'prevent goitre', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'prevent goitre' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'kill germs', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'kill germs' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'remove colour or odour', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'remove colour or odour' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 69 - Question 69
SET @source_marker := 'JAMB 2024 Chemistry - Item 69 - Question 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 69 - Question 69</small></p><p><strong>JAMB 2024 Chemistry - Question 69</strong></p><p>The combustion of candle under limited supply of air forms</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water and CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'water and CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water and CO', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'water and CO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'soot and CO', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'soot and CO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'soot and CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'soot and CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 70 - Question 70
SET @source_marker := 'JAMB 2024 Chemistry - Item 70 - Question 70';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 70 - Question 70</small></p><p><strong>JAMB 2024 Chemistry - Question 70</strong></p><p>A major effect of oil pollution in coastal water is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'destruction of aquatic life', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'destruction of aquatic life' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrification of the water body', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nitrification of the water body' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'detoxification of water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'detoxification of water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disinfection of the water body', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'disinfection of the water body' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 71 - Question 71
SET @source_marker := 'JAMB 2024 Chemistry - Item 71 - Question 71';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 71 - Question 71</small></p><p><strong>JAMB 2024 Chemistry - Question 71</strong></p><p>The substance that reacts with sodium to form alkali and changes white anhydrous copper(II) tetraoxosulphate (VI) to blue is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'base', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'base' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'solvent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'solvent' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 72 - Question 72
SET @source_marker := 'JAMB 2024 Chemistry - Item 72 - Question 72';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 72 - Question 72</small></p><p><strong>JAMB 2024 Chemistry - Question 72</strong></p><p><span contenteditable="false" class="math-editor-rendered" data-latex="^{14}_7"></span>N  + X → <span contenteditable="false" class="math-editor-rendered" data-latex="^{14}_6"></span>C  +  <span contenteditable="false" class="math-editor-rendered" data-latex="^1_1"></span>P</p>

<p>In the reaction above, X is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a proton', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a proton' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an alpha particle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an alpha particle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a beta particle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a beta particle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a neutron', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a neutron' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 73 - Question 73
SET @source_marker := 'JAMB 2024 Chemistry - Item 73 - Question 73';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 73 - Question 73</small></p><p><strong>JAMB 2024 Chemistry - Question 73</strong></p><p>An example of a substance that does not change directly from solid to gas when heated is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Cl<span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Cl<span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CaCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CaCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'S<span contenteditable="false" class="math-editor-rendered" data-latex="_8"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'S<span contenteditable="false" class="math-editor-rendered" data-latex="_8"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 74 - Question 74
SET @source_marker := 'JAMB 2024 Chemistry - Item 74 - Question 74';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 74 - Question 74</small></p><p><strong>JAMB 2024 Chemistry - Question 74</strong></p><p>When a specie undergoes oxidation, its</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxidation number increases', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxidation number increases' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxidation number decreases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxidation number decreases' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxidation number remains constant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxidation number remains constant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'acts as oxidizing agent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'acts as oxidizing agent' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 75 - Question 75
SET @source_marker := 'JAMB 2024 Chemistry - Item 75 - Question 75';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 75 - Question 75</small></p><p><strong>JAMB 2024 Chemistry - Question 75</strong></p><p>Hydrochloric acid is regarded as a strong acid because it</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ionizes partially', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ionizes partially' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ionizes completely', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ionizes completely' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is a mineral acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'is a mineral acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reacts with a base', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reacts with a base' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 76 - Question 76
SET @source_marker := 'JAMB 2024 Chemistry - Item 76 - Question 76';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 76 - Question 76</small></p><p><strong>JAMB 2024 Chemistry - Question 76</strong></p><p>The IUPAC nomenclature of the complex K<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Fe(CN)<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span> is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'potassium hexacyanoferrate(II)', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'potassium hexacyanoferrate(II)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'potassium hexacyanoferrate(III)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'potassium hexacyanoferrate(III)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'potassium hexacyanoferrate(IV)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'potassium hexacyanoferrate(IV)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'potassium hexacyanoferrate(VI)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'potassium hexacyanoferrate(VI)' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 77 - Question 77
SET @source_marker := 'JAMB 2024 Chemistry - Item 77 - Question 77';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 77 - Question 77</small></p><p><strong>JAMB 2024 Chemistry - Question 77</strong></p><p>An example of an amphoteric oxide is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'P<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'P<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Al<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Al<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CuO', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CuO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 78 - Question 78
SET @source_marker := 'JAMB 2024 Chemistry - Item 78 - Question 78';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 78 - Question 78</small></p><p><strong>JAMB 2024 Chemistry - Question 78</strong></p><p>The term that is not associated with petroleum industry is ?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cracking', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cracking' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Saponification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Saponification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Polymerization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Polymerization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fermentation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fermentation' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 79 - Question 79
SET @source_marker := 'JAMB 2024 Chemistry - Item 79 - Question 79';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 79 - Question 79</small></p><p><strong>JAMB 2024 Chemistry - Question 79</strong></p><p>Kerosene is used as solvent for </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Paints', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Paints' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sulphur', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sulphur' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gums', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Gums' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fats', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fats' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 80 - Question 80
SET @source_marker := 'JAMB 2024 Chemistry - Item 80 - Question 80';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 80 - Question 80</small></p><p><strong>JAMB 2024 Chemistry - Question 80</strong></p><p>A typical chemical reaction will be spontaneous if </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enthalpy change is negative', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'enthalpy change is negative' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'free energy change is greater than one', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'free energy change is greater than one' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'entropy change is zero', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'entropy change is zero' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enthalpy and free energy change are equal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'enthalpy and free energy change are equal' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 81 - Question 81
SET @source_marker := 'JAMB 2024 Chemistry - Item 81 - Question 81';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 81 - Question 81</small></p><p><strong>JAMB 2024 Chemistry - Question 81</strong></p><p>The indicator used in a titration between strong acid and weak base is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methyl orange', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methyl orange' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'phenolphthalein', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'phenolphthalein' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bromothymol blue', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bromothymol blue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methyl red', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methyl red' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 82 - Question 82
SET @source_marker := 'JAMB 2024 Chemistry - Item 82 - Question 82';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 82 - Question 82</small></p><p><strong>JAMB 2024 Chemistry - Question 82</strong></p><p>Nitrogen obtained from air is not absolutely pure because it contains the following except</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxygen', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxygen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carbon (IV)oxide', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'carbon (IV)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inert gases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inert gases' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water vapour', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'water vapour' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 83 - Question 83
SET @source_marker := 'JAMB 2024 Chemistry - Item 83 - Question 83';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 83 - Question 83</small></p><p><strong>JAMB 2024 Chemistry - Question 83</strong></p><p>Solubility curve is a plot of solubility against </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'temperature', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pressure', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pressure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'volume', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'volume' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'concentrate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'concentrate' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 84 - Question 84
SET @source_marker := 'JAMB 2024 Chemistry - Item 84 - Question 84';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 84 - Question 84</small></p><p><strong>JAMB 2024 Chemistry - Question 84</strong></p><p>If 11.0g of a gas occupies 5.6 dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> at s.t.p., calculate its vapour density (1 mole of a gas occupies 22.4 dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>).</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '22', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '22' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '44', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '44' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '66', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '66' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '88', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '88' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 85 - Question 85
SET @source_marker := 'JAMB 2024 Chemistry - Item 85 - Question 85';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 85 - Question 85</small></p><p><strong>JAMB 2024 Chemistry - Question 85</strong></p><p>The Van der waals forces of attraction operates between</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'atoms', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'atoms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cations', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cations' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'molecules', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'molecules' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'anions', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'anions' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 86 - Question 86
SET @source_marker := 'JAMB 2024 Chemistry - Item 86 - Question 86';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 86 - Question 86</small></p><p><strong>JAMB 2024 Chemistry - Question 86</strong></p><p>The electronic configuration of an atom of Nitrogen is 1s<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span> 2s<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span> 2p<span contenteditable="false" class="math-editor-rendered" data-latex="^1_x"></span> 2p<span contenteditable="false" class="math-editor-rendered" data-latex="^1_y"></span> 2p<span contenteditable="false" class="math-editor-rendered" data-latex="^1_z"></span> because the atom is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'in an excited state', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'in an excited state' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'undergoing energy changes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'undergoing energy changes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unstable and ready to combine with another', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unstable and ready to combine with another' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'simply obeying rules governing electron configuration', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'simply obeying rules governing electron configuration' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 87 - Question 87
SET @source_marker := 'JAMB 2024 Chemistry - Item 87 - Question 87';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 87 - Question 87</small></p><p><strong>JAMB 2024 Chemistry - Question 87</strong></p><p>The reaction of hydrogen and chlorine to produce hydrogen chloride gas is explosive in </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'diffused light', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'diffused light' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sunlight', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sunlight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'infrared light', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'infrared light' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Raman light', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Raman light' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 88 - Question 88
SET @source_marker := 'JAMB 2024 Chemistry - Item 88 - Question 88';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 88 - Question 88</small></p><p><strong>JAMB 2024 Chemistry - Question 88</strong></p><p>The term strong and weak acids is used to indicate the </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'number of H<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span> released by an acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'number of H<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span> released by an acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'number of OH<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span> released by an acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'number of OH<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span> released by an acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'extent of ionization of an acid', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'extent of ionization of an acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'strength of its action on substance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'strength of its action on substance' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 89 - Question 89
SET @source_marker := 'JAMB 2024 Chemistry - Item 89 - Question 89';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 89 - Question 89</small></p><p><strong>JAMB 2024 Chemistry - Question 89</strong></p><p>The main constituent of water-glass is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'calcium trioxosilicate(IV)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'calcium trioxosilicate(IV)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'calcium trioxosulphate(IV)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'calcium trioxosulphate(IV)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sodium trioxosulphate(IV)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sodium trioxosulphate(IV)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sodium trioxosilicate(IV)', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sodium trioxosilicate(IV)' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 90 - Question 90
SET @source_marker := 'JAMB 2024 Chemistry - Item 90 - Question 90';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 90 - Question 90</small></p><p><strong>JAMB 2024 Chemistry - Question 90</strong></p><p>Which of the following represents an order of increasing reactivity?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Au &lt; Cu &lt; Sn &lt; Fe &lt; Ca', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Au &lt; Cu &lt; Sn &lt; Fe &lt; Ca' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ca &lt; Fe &lt; Sn &lt; Cu &lt; Au', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ca &lt; Fe &lt; Sn &lt; Cu &lt; Au' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Au &lt; Cu &lt; Fe &lt; Sn &lt; Ca', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Au &lt; Cu &lt; Fe &lt; Sn &lt; Ca' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ca &lt; Sn &lt; Fe &lt; Cu &lt; Au', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ca &lt; Sn &lt; Fe &lt; Cu &lt; Au' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 91 - Question 91
SET @source_marker := 'JAMB 2024 Chemistry - Item 91 - Question 91';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 91 - Question 91</small></p><p><strong>JAMB 2024 Chemistry - Question 91</strong></p><p>An oxide of nitrogen that can rekindle a glowing splint is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrogen(I)oxide', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nitrogen(I)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrogen(II)oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nitrogen(II)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrogen(IV)oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nitrogen(IV)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dinitrogen tetraoxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dinitrogen tetraoxide' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 92 - Question 92
SET @source_marker := 'JAMB 2024 Chemistry - Item 92 - Question 92';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 92 - Question 92</small></p><p><strong>JAMB 2024 Chemistry - Question 92</strong></p><p>In a chemical reaction, surface area of reactants can affect</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CaCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> + 2HCl →  CaCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> + H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O +  CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CaCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> + 2HCl →  CaCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> + H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O +  CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MgCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> + H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> → MgSO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> + 2HCl', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MgCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> + H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> → MgSO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> + 2HCl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> + Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> →  2HCl', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> + Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> →  2HCl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NaOH  + HCl  →  NaCl  +  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NaOH  + HCl  →  NaCl  +  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 93 - Question 93
SET @source_marker := 'JAMB 2024 Chemistry - Item 93 - Question 93';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 93 - Question 93</small></p><p><strong>JAMB 2024 Chemistry - Question 93</strong></p><p>C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{4(g)}"></span>  +  3O<span contenteditable="false" class="math-editor-rendered" data-latex="_{2(g)}"></span> → 2CO<span contenteditable="false" class="math-editor-rendered" data-latex="_{2(g)}"></span>  +  2H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_{(g)}"></span></p>

<p>The above equation represents the combustion of ethene.If 10cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> of ethene is burnt in 50cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> of oxygen, what would be the volume of oxygen that would remain at the end of the reaction?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '20cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '20cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '40cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '40cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '60cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '60cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '50cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '50cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 94 - Question 94
SET @source_marker := 'JAMB 2024 Chemistry - Item 94 - Question 94';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 94 - Question 94</small></p><p><strong>JAMB 2024 Chemistry - Question 94</strong></p><p>The hybridization scheme in ethyne is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sp', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sp' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sp<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sp<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sp<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>d', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sp<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>d' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sp<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sp<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>s' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 95 - Question 95
SET @source_marker := 'JAMB 2024 Chemistry - Item 95 - Question 95';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 95 - Question 95</small></p><p><strong>JAMB 2024 Chemistry - Question 95</strong></p><p>An organic compound with general formula RCOR&#039; is an</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanone', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanone' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoic acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoic acid' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 96 - Question 96
SET @source_marker := 'JAMB 2024 Chemistry - Item 96 - Question 96';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 96 - Question 96</small></p><p><strong>JAMB 2024 Chemistry - Question 96</strong></p><p>The amount of Faraday required to discharge 4.5 moles of Al<span contenteditable="false" class="math-editor-rendered" data-latex="^{3+}"></span> is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '13.5', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '13.5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.5' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 97 - Question 97
SET @source_marker := 'JAMB 2024 Chemistry - Item 97 - Question 97';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 97 - Question 97</small></p><p><strong>JAMB 2024 Chemistry - Question 97</strong></p><p>The reaction between alkanoic acids and alkanols in the presence of an acid catalyst is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'saponification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'saponification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dehydration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dehydration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'esterification', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'esterification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrolysis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrolysis' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 98 - Question 98
SET @source_marker := 'JAMB 2024 Chemistry - Item 98 - Question 98';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 98 - Question 98</small></p><p><strong>JAMB 2024 Chemistry - Question 98</strong></p><p>C<span contenteditable="false" class="math-editor-rendered" data-latex="_x"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_y"></span>O + 5O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>  →  4CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>  +  4H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O</p>

<p>C<span contenteditable="false" class="math-editor-rendered" data-latex="_x"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_y"></span>O in the equation is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>O' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>O' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>O', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>O' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 99 - Question 99
SET @source_marker := 'JAMB 2024 Chemistry - Item 99 - Question 99';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 99 - Question 99</small></p><p><strong>JAMB 2024 Chemistry - Question 99</strong></p><p>Alkylation of benzene is catalyzed by </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'palladium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'palladium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nickel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nickel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sunlight', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sunlight' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aluminium chloride', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aluminium chloride' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 100 - Question 100
SET @source_marker := 'JAMB 2024 Chemistry - Item 100 - Question 100';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 100 - Question 100</small></p><p><strong>JAMB 2024 Chemistry - Question 100</strong></p><p>Benzene formed nitrobenzene at temperature of 60<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span>C when it reacts with mixture of concentrated trioxonitrate(V) acid and concentrated </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'phosphoric acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'phosphoric acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrochloric acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrochloric acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tetraoxosulphate(VI) acid', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tetraoxosulphate(VI) acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen iodide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogen iodide' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 101 - Question 101
SET @source_marker := 'JAMB 2024 Chemistry - Item 101 - Question 101';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 101 - Question 101</small></p><p><strong>JAMB 2024 Chemistry - Question 101</strong></p><p>The general molecular formula C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n-2}"></span> represents that of an</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkyne', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkyne' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanal' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 102 - Question 102
SET @source_marker := 'JAMB 2024 Chemistry - Item 102 - Question 102';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 102 - Question 102</small></p><p><strong>JAMB 2024 Chemistry - Question 102</strong></p><p>What accounts for the low melting and boiling points of covalent molecules?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They have weak intermolecular forces.', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They have weak intermolecular forces.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They are three-dimensional structures.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They are three-dimensional structures.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They have definite shapes.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They have definite shapes.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They possess shared electron pairs', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They possess shared electron pairs' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 103 - Question 103
SET @source_marker := 'JAMB 2024 Chemistry - Item 103 - Question 103';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 103 - Question 103</small></p><p><strong>JAMB 2024 Chemistry - Question 103</strong></p><p>After breathing in a test tube that contains acidified K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>Cr<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span>, a man noticed the change in the colour of K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>Cr<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span> from orange to green. This suggests the presence of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanone', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanone' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoic acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoic acid' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 104 - Question 104
SET @source_marker := 'JAMB 2024 Chemistry - Item 104 - Question 104';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 104 - Question 104</small></p><p><strong>JAMB 2024 Chemistry - Question 104</strong></p><p>Hydrochloric acid is not suitable in the preparation of ethanoic acid because it</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is too acidic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'is too acidic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is too volatile', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'is too volatile' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'can attack cork and rubber used as containers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'can attack cork and rubber used as containers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'turns blue litmus red', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'turns blue litmus red' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 105 - Question 105
SET @source_marker := 'JAMB 2024 Chemistry - Item 105 - Question 105';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 105 - Question 105</small></p><p><strong>JAMB 2024 Chemistry - Question 105</strong></p><p>A radioactive element of mass 1g has half-life of 2 minutes, what fraction of the substance would have disintegrated after 10 minutes?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1/4', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1/4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1/8', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1/8' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1/16', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1/16' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1/32', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1/32' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 106 - Question 106
SET @source_marker := 'JAMB 2024 Chemistry - Item 106 - Question 106';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 106 - Question 106</small></p><p><strong>JAMB 2024 Chemistry - Question 106</strong></p><p>Hydrogen chloride gas and ammonia can be used to demonstrate the fountain experiment because they are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'light', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'light' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'volatile', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'volatile' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'very soluble in water', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'very soluble in water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'heavy gases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'heavy gases' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 107 - Question 107
SET @source_marker := 'JAMB 2024 Chemistry - Item 107 - Question 107';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 107 - Question 107</small></p><p><strong>JAMB 2024 Chemistry - Question 107</strong></p><p>In the conductance of aqueous CuSO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> solution, the current carriers are the</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mobile electrons', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mobile electrons' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metallic ions', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metallic ions' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrated ions', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrated ions' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrated electrons', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrated electrons' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 108 - Question 108
SET @source_marker := 'JAMB 2024 Chemistry - Item 108 - Question 108';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 108 - Question 108</small></p><p><strong>JAMB 2024 Chemistry - Question 108</strong></p><p>A type of isomerism that ClCH=CHCl can exhibit is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chain', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'chain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'positional', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'positional' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'functional group', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'functional group' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'optical', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'optical' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 109 - Question 109
SET @source_marker := 'JAMB 2024 Chemistry - Item 109 - Question 109';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 109 - Question 109</small></p><p><strong>JAMB 2024 Chemistry - Question 109</strong></p><p>The basicity of tetraoxophosphate(V) acid is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 110 - Question 110
SET @source_marker := 'JAMB 2024 Chemistry - Item 110 - Question 110';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 110 - Question 110</small></p><p><strong>JAMB 2024 Chemistry - Question 110</strong></p><p>Which of the following is used in forming slag in the blast furnace for the extraction of iron?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ca(CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> )<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ca(CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> )<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ca(OH)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ca(OH)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CaCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CaCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CaO', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CaO' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 111 - Question 111
SET @source_marker := 'JAMB 2024 Chemistry - Item 111 - Question 111';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 111 - Question 111</small></p><p><strong>JAMB 2024 Chemistry - Question 111</strong></p><p>Calculate the number of moles of Copper that will be deposited, if 2 Faraday of electricity is passed through the copper during the electrolysis of copper(II)tetraoxosulphate(VI) </p>

<p>[1F = 96500C ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.5 mole', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.5 mole' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.0 mole', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.0 mole' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.0 moles', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.0 moles' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.0 moles', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.0 moles' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 112 - Question 112
SET @source_marker := 'JAMB 2024 Chemistry - Item 112 - Question 112';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 112 - Question 112</small></p><p><strong>JAMB 2024 Chemistry - Question 112</strong></p><p>The volume occupied by 1 mole of an ideal gas at a temperature of 13<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span>C and a pressure of 1.58 atm is </p>

<p>[ R = 0.082 atm dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> K<span contenteditable="false" class="math-editor-rendered" data-latex="^{-1}"></span>mol<span contenteditable="false" class="math-editor-rendered" data-latex="^{-1}"></span> ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14.84 dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '14.84 dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14.84 cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '14.84 cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.64 dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.64 dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.64 cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.64 cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 113 - Question 113
SET @source_marker := 'JAMB 2024 Chemistry - Item 113 - Question 113';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 113 - Question 113</small></p><p><strong>JAMB 2024 Chemistry - Question 113</strong></p><p>If a salt weighs 2g and upon exposure to the atmosphere weighs 1.5g, this is as a result of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hygroscopy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hygroscopy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'effervescence', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'effervescence' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'efflorescence', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'efflorescence' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'deliquescence', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'deliquescence' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 114 - Question 114
SET @source_marker := 'JAMB 2024 Chemistry - Item 114 - Question 114';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 114 - Question 114</small></p><p><strong>JAMB 2024 Chemistry - Question 114</strong></p><p>The compound of Copper used as a fungicide is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CuCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CuCO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cu(NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cu(NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CuSO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CuSO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CuCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CuCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 115 - Question 115
SET @source_marker := 'JAMB 2024 Chemistry - Item 115 - Question 115';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 115 - Question 115</small></p><p><strong>JAMB 2024 Chemistry - Question 115</strong></p><p>The percentage of hydrogen in the sixth member of the class of the aliphatic alkanes is  [H =1, C =12 ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '41.34', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '41.34' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '59.54', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '59.54' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16.28', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16.28' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '83.72', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '83.72' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 116 - Question 116
SET @source_marker := 'JAMB 2024 Chemistry - Item 116 - Question 116';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 116 - Question 116</small></p><p><strong>JAMB 2024 Chemistry - Question 116</strong></p><p>The law which states that a pure chemical compound, no matter how it is made, will be made up of the same elements contained in the same proportion by mass is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'law of conservation of masses', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'law of conservation of masses' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'law of definite proportion', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'law of definite proportion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'law of multiple proportion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'law of multiple proportion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'law of reciprocal proportion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'law of reciprocal proportion' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 117 - Question 117
SET @source_marker := 'JAMB 2024 Chemistry - Item 117 - Question 117';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 117 - Question 117</small></p><p><strong>JAMB 2024 Chemistry - Question 117</strong></p><p>The stability of atomic nucleus is determined by ratio of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Neutron/electron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Neutron/electron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Neutron/proton', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Neutron/proton' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'positron/neutron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'positron/neutron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'electron/proton', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'electron/proton' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 118 - Question 118
SET @source_marker := 'JAMB 2024 Chemistry - Item 118 - Question 118';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 118 - Question 118</small></p><p><strong>JAMB 2024 Chemistry - Question 118</strong></p><p>25.0g of potassium chloride were dissolved in 80g of distilled water at 30<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span>C. Calculate the solubility of the solute in mol dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>. [K =39, Cl = 35.5]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.9 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.9 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.6 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.6 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.0 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.0 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.2 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.2 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 119 - Question 119
SET @source_marker := 'JAMB 2024 Chemistry - Item 119 - Question 119';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 119 - Question 119</small></p><p><strong>JAMB 2024 Chemistry - Question 119</strong></p><p>An example of a physical change is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'slaking of lime', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'slaking of lime' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'liquefaction of liquids', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'liquefaction of liquids' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dissolution of limestone in acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dissolution of limestone in acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rusting of iron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rusting of iron' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 120 - Question 120
SET @source_marker := 'JAMB 2024 Chemistry - Item 120 - Question 120';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 120 - Question 120</small></p><p><strong>JAMB 2024 Chemistry - Question 120</strong></p><p>The product formed when ethyne is passed through a hot tube containing finely divided iron is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'polymeric', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'polymeric' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'saturated', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'saturated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrated', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrated' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aromatic', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aromatic' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 121 - Question 121
SET @source_marker := 'JAMB 2024 Chemistry - Item 121 - Question 121';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 121 - Question 121</small></p><p><strong>JAMB 2024 Chemistry - Question 121</strong></p><p>H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>S<span contenteditable="false" class="math-editor-rendered" data-latex="_{(g)}"></span>  +  Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="_{(g)}"></span> → 2HCl<span contenteditable="false" class="math-editor-rendered" data-latex="_{(g)}"></span> + S<span contenteditable="false" class="math-editor-rendered" data-latex="_{(s)}"></span></p>

<p>What is the change in oxidation state of sulphur from reactant to product?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-3 to -1', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-3 to -1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-3 to 1', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-3 to 1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-2 to 0', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-2 to 0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '-1 to 0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '-1 to 0' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 122 - Question 122
SET @source_marker := 'JAMB 2024 Chemistry - Item 122 - Question 122';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 122 - Question 122</small></p><p><strong>JAMB 2024 Chemistry - Question 122</strong></p><p>If a stable neutral atom has a mass number of 31, the number of electrons and neutrons respectively are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15 and 16', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '15 and 16' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16 and 31', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16 and 31' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15 and 31', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '15 and 31' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16 and 15', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16 and 15' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 123 - Question 123
SET @source_marker := 'JAMB 2024 Chemistry - Item 123 - Question 123';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 123 - Question 123</small></p><p><strong>JAMB 2024 Chemistry - Question 123</strong></p><p>Scandium is not regarded as a transition metal because its ion has </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'no electron in the d-orbital', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'no electron in the d-orbital' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a partially filled d-orbitals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a partially filled d-orbitals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a completely filled 4S orbital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a completely filled 4S orbital' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a partially filled 4S orbital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a partially filled 4S orbital' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 124 - Question 124
SET @source_marker := 'JAMB 2024 Chemistry - Item 124 - Question 124';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 124 - Question 124</small></p><p><strong>JAMB 2024 Chemistry - Question 124</strong></p><p>An example of highly unsaturated hydrocarbon is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 125 - Question 125
SET @source_marker := 'JAMB 2024 Chemistry - Item 125 - Question 125';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 125 - Question 125</small></p><p><strong>JAMB 2024 Chemistry - Question 125</strong></p><p>Biodegradable pollutants are not safe in water systems because they can cause</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'air pollution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'air pollution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'soil degradation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'soil degradation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ill health', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ill health' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'greenhouse effect', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'greenhouse effect' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 126 - Question 126
SET @source_marker := 'JAMB 2024 Chemistry - Item 126 - Question 126';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 126 - Question 126</small></p><p><strong>JAMB 2024 Chemistry - Question 126</strong></p><p>An example of a compound that is acidic in solution is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>PO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>PO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Cl', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Cl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Na<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Na<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MgCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MgCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 127 - Question 127
SET @source_marker := 'JAMB 2024 Chemistry - Item 127 - Question 127';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 127 - Question 127</small></p><p><strong>JAMB 2024 Chemistry - Question 127</strong></p><p>The amount of water a substance chemically combined with is called water of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dehydration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dehydration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'solution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'solution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'crystallization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'crystallization' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 128 - Question 128
SET @source_marker := 'JAMB 2024 Chemistry - Item 128 - Question 128';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 128 - Question 128</small></p><p><strong>JAMB 2024 Chemistry - Question 128</strong></p><p>Heat of solution involves two steps that is accompanied by heat change. The energies involved in this steps are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lattice energy and hydration energy', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lattice energy and hydration energy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lattice energy and ionic energy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lattice energy and ionic energy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Heat energy and lattice energy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Heat energy and lattice energy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydration energy and heat energy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydration energy and heat energy' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 129 - Question 129
SET @source_marker := 'JAMB 2024 Chemistry - Item 129 - Question 129';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 129 - Question 129</small></p><p><strong>JAMB 2024 Chemistry - Question 129</strong></p><p><img src="../uploads/question_bank/jamb_2024_chemistry/Q129_diagram.png" alt="Diagram for JAMB 2024 Chemistry Question 129" style="max-width:100%;height:auto;"></p><p>The IUPAC name of the compound above is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3-methyl, 3-bromo butane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3-methyl, 3-bromo butane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-methyl, 2-bromo butane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-methyl, 2-bromo butane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-bromo, 2-methyl butane', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-bromo, 2-methyl butane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3-bromo, 3-methyl butane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3-bromo, 3-methyl butane' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 130 - Question 130
SET @source_marker := 'JAMB 2024 Chemistry - Item 130 - Question 130';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 130 - Question 130</small></p><p><strong>JAMB 2024 Chemistry - Question 130</strong></p><p>The shape of ammonia molecule is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'V-Shaped or bent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'V-Shaped or bent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tetrahedral', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tetrahedral' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'co-plannar', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'co-plannar' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trigonal', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trigonal' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 131 - Question 131
SET @source_marker := 'JAMB 2024 Chemistry - Item 131 - Question 131';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 131 - Question 131</small></p><p><strong>JAMB 2024 Chemistry - Question 131</strong></p><p>The percentage of carbon(IV) oxide in air is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.01', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.01' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.02', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.02' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.05', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.05' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.03', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.03' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 132 - Question 132
SET @source_marker := 'JAMB 2024 Chemistry - Item 132 - Question 132';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 132 - Question 132</small></p><p><strong>JAMB 2024 Chemistry - Question 132</strong></p><p>An example of a physical change is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exposing sodium metal to air', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exposing sodium metal to air' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'boiling of water', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'boiling of water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dissolving calcium metal in water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dissolving calcium metal in water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'burning of kerosene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'burning of kerosene' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 133 - Question 133
SET @source_marker := 'JAMB 2024 Chemistry - Item 133 - Question 133';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 133 - Question 133</small></p><p><strong>JAMB 2024 Chemistry - Question 133</strong></p><p>Boyle&#039;s law can be expressed mathematically as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'PV = K', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'PV = K' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'PV = RT', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'PV = RT' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'V =KT', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'V =KT' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{V}{T}"></span> = K', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{V}{T}"></span> = K' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 134 - Question 134
SET @source_marker := 'JAMB 2024 Chemistry - Item 134 - Question 134';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 134 - Question 134</small></p><p><strong>JAMB 2024 Chemistry - Question 134</strong></p><p>What is the vapour density of 560cm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> of a gas that weighs 0.4g at s.t.p?</p>

<p>[Molar Volume of gas at s.t.p = 22.4 dm<span contenteditable="false" class="math-editor-rendered" data-latex="^3"></span> ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.0', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '32.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '32.0' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 135 - Question 135
SET @source_marker := 'JAMB 2024 Chemistry - Item 135 - Question 135';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 135 - Question 135</small></p><p><strong>JAMB 2024 Chemistry - Question 135</strong></p><p>When the subsidiary quantum numbers (l) equals 1, the shape of the orbital is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spherical', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'spherical' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dumb-bell', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dumb-bell' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'flat', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'flat' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'round', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'round' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 136 - Question 136
SET @source_marker := 'JAMB 2024 Chemistry - Item 136 - Question 136';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 136 - Question 136</small></p><p><strong>JAMB 2024 Chemistry - Question 136</strong></p><p>Esterification reaction is analogous to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxidation reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxidation reaction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neutralization reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'neutralization reaction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'condensation reaction', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'condensation reaction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrolysis reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrolysis reaction' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 137 - Question 137
SET @source_marker := 'JAMB 2024 Chemistry - Item 137 - Question 137';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 137 - Question 137</small></p><p><strong>JAMB 2024 Chemistry - Question 137</strong></p><p>The IUPAC Nomenclature of CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>C(CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)=C(CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> for the compound is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2,3-dimethylpentene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2,3-dimethylpentene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2,3-dimethylpent-2-ene', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2,3-dimethylpent-2-ene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3,4-dimethylpent-3-ene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3,4-dimethylpent-3-ene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3,4-dimethylpentene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3,4-dimethylpentene' AND deleted = 0);

-- JAMB 2024 Chemistry - Item 138 - Question 138
SET @source_marker := 'JAMB 2024 Chemistry - Item 138 - Question 138';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Chemistry - Item 138 - Question 138</small></p><p><strong>JAMB 2024 Chemistry - Question 138</strong></p><p>                    H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span></p>

<p>C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>OH      →         C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span></p>

<p>                    170<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span>C</p>

<p>The reaction above illustrates </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxidation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxidation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'esterification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'esterification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dehydration', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dehydration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'polymerization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'polymerization' AND deleted = 0);
COMMIT;

SELECT
    COUNT(*) AS jamb_2024_chemistry_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2024
  AND question LIKE '%JAMB 2024 Chemistry - Item%';
