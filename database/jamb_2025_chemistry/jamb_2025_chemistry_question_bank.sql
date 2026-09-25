-- JAMB 2025 Chemistry objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2025_chemistry/jamb_2025_chemistry_import_manifest.json for exact per-item source URLs).
-- Expected payload: 109 questions and 436 options.
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

DROP PROCEDURE IF EXISTS ss360_require_jamb_2025_chemistry_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2025_chemistry_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chemistry subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2025_chemistry_refs();
DROP PROCEDURE ss360_require_jamb_2025_chemistry_refs;

START TRANSACTION;

-- JAMB 2025 Chemistry - Item 1 - Question 1
SET @source_marker := 'JAMB 2025 Chemistry - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 1 - Question 1</small></p><p><strong>JAMB 2025 Chemistry - Question 1</strong></p><p>The molecule with the highest number of lone pair of electrons is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C0<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C0<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 2 - Question 2
SET @source_marker := 'JAMB 2025 Chemistry - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 2 - Question 2</small></p><p><strong>JAMB 2025 Chemistry - Question 2</strong></p><p>The composition of petroleum varies because it is a </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrocarbon', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrocarbon' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'liquid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'liquid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mixture', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'mixture' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'natural resource', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'natural resource' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 3 - Question 3
SET @source_marker := 'JAMB 2025 Chemistry - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 3 - Question 3</small></p><p><strong>JAMB 2025 Chemistry - Question 3</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q3_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 3" style="max-width:100%;height:auto;"></p><p>In the table above, the two compounds that will combine in the presence of an acid-catalyzed compound, V is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and IV', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I and IV' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'III and IV', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'III and IV' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and II', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I and II' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II and III', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'II and III' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 4 - Question 4
SET @source_marker := 'JAMB 2025 Chemistry - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 4 - Question 4</small></p><p><strong>JAMB 2025 Chemistry - Question 4</strong></p><p>An example of an alkaline gas is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'HCl', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'HCl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 5 - Question 5
SET @source_marker := 'JAMB 2025 Chemistry - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 5 - Question 5</small></p><p><strong>JAMB 2025 Chemistry - Question 5</strong></p><p>The dusty and sand particles present in the air is an example of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a suspension', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a suspension' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a dispersion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a dispersion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'an emulsion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'an emulsion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a saturated solution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a saturated solution' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 6 - Question 6
SET @source_marker := 'JAMB 2025 Chemistry - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 6 - Question 6</small></p><p><strong>JAMB 2025 Chemistry - Question 6</strong></p><p>The property of metal that makes it suitable as a catalyst is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'filled f-orbital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'filled f-orbital' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'partially filled d-orbitals', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'partially filled d-orbitals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'partially filled f-orbital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'partially filled f-orbital' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'filled d-orbital', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'filled d-orbital' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 7 - Question 7
SET @source_marker := 'JAMB 2025 Chemistry - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 7 - Question 7</small></p><p><strong>JAMB 2025 Chemistry - Question 7</strong></p><p>When ΔH is positive and small, and ΔS is positive and large, the reaction will be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Non-spontaneous', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Non-spontaneous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour forward reaction only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'favour forward reaction only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour backward reaction only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'favour backward reaction only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spontaneous', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'spontaneous' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 8 - Question 8
SET @source_marker := 'JAMB 2025 Chemistry - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 8 - Question 8</small></p><p><strong>JAMB 2025 Chemistry - Question 8</strong></p><p>Calculate the pH of 0.001M  KOH solution.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '11' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '14' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 9 - Question 9
SET @source_marker := 'JAMB 2025 Chemistry - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 9 - Question 9</small></p><p><strong>JAMB 2025 Chemistry - Question 9</strong></p><p>The acid used in making baking soda and soft drink is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tartaric acid', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tartaric acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fatty acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fatty acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'boric acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'boric acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'citric acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'citric acid' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 10 - Question 10
SET @source_marker := 'JAMB 2025 Chemistry - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 10 - Question 10</small></p><p><strong>JAMB 2025 Chemistry - Question 10</strong></p><p>NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_g"></span>) +  HCl<span contenteditable="false" class="math-editor-rendered" data-latex="(_g"></span>) →   NH<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>Cl <span contenteditable="false" class="math-editor-rendered" data-latex="_(g)"></span></p>

<p>In the reaction above, increase in pressure will</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lower the equilibrium constant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lower the equilibrium constant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour the product', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'favour the product' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour the reactant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'favour the reactant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase the equilibrium constant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'increase the equilibrium constant' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 11 - Question 11
SET @source_marker := 'JAMB 2025 Chemistry - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 11 - Question 11</small></p><p><strong>JAMB 2025 Chemistry - Question 11</strong></p><p>The compound CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH(NH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>)CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> is an example of a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'primary amine', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'primary amine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tertiary amine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tertiary amine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quaternary amine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'quaternary amine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'secondary amine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'secondary amine' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 12 - Question 12
SET @source_marker := 'JAMB 2025 Chemistry - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 12 - Question 12</small></p><p><strong>JAMB 2025 Chemistry - Question 12</strong></p><p>Nitrogen, a component of air is used for</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'production of cooling agent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'production of cooling agent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'production of margarine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'production of margarine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'production of HNO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'production of HNO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'manufacturing of oil', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'manufacturing of oil' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 13 - Question 13
SET @source_marker := 'JAMB 2025 Chemistry - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 13 - Question 13</small></p><p><strong>JAMB 2025 Chemistry - Question 13</strong></p><p>2Na  +  Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> → 2NaCl</p>

<p>In the reaction above, the specie that undergoes reduction is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Na', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Na' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NaCl', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NaCl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cl<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cl<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 14 - Question 14
SET @source_marker := 'JAMB 2025 Chemistry - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 14 - Question 14</small></p><p><strong>JAMB 2025 Chemistry - Question 14</strong></p><p>The sublimation of solid to gas involves</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'energy absorption', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'energy absorption' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'vapourization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'vapourization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'melting', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'melting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'osmotic diffusion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'osmotic diffusion' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 15 - Question 15
SET @source_marker := 'JAMB 2025 Chemistry - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 15 - Question 15</small></p><p><strong>JAMB 2025 Chemistry - Question 15</strong></p><p>The products of the thermal decomposition of ammonium trioxonitrate(v) are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O and H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O and H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> and H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> and H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O and O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O and O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> and H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> and H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 16 - Question 16
SET @source_marker := 'JAMB 2025 Chemistry - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 16 - Question 16</small></p><p><strong>JAMB 2025 Chemistry - Question 16</strong></p><p>2X + 2HCl  → 2XCl  +  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span></p>

<p>In the equation above, X is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'K', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'K' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mg', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mg' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ca', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ca' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ba', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ba' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 17 - Question 17
SET @source_marker := 'JAMB 2025 Chemistry - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 17 - Question 17</small></p><p><strong>JAMB 2025 Chemistry - Question 17</strong></p><p>Alkanoic acids have higher boiling points than alkanols because</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoic acids are more volatile than alkanols', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoic acids are more volatile than alkanols' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanols are more polar than alkanoic acids', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanols are more polar than alkanoic acids' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoic acids are larger molecules', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoic acids are larger molecules' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoic acids form stronger hydrogen bonds', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoic acids form stronger hydrogen bonds' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 18 - Question 18
SET @source_marker := 'JAMB 2025 Chemistry - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 18 - Question 18</small></p><p><strong>JAMB 2025 Chemistry - Question 18</strong></p><p>Water drops are spherical in shape because of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'polarity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'polarity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'viscocity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'viscocity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'density', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'density' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'surface tension', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'surface tension' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 19 - Question 19
SET @source_marker := 'JAMB 2025 Chemistry - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 19 - Question 19</small></p><p><strong>JAMB 2025 Chemistry - Question 19</strong></p><p>In the electrolysis of brine using neutral electrode, which ion is discharged at the anode?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2H<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2H<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Na<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Na<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cl<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cl<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'OH<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'OH<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 20 - Question 20
SET @source_marker := 'JAMB 2025 Chemistry - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 20 - Question 20</small></p><p><strong>JAMB 2025 Chemistry - Question 20</strong></p><p>The time required to deposit 4.5g of copper from CuSO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> solution by passing a current of 2.5 Amperes is (Cu = 64g ; 1F = 96500C/mol)</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2714 sec', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2714 sec' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2527 sec', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2527 sec' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5428 sec', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5428 sec' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6785 sec', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6785 sec' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 21 - Question 21
SET @source_marker := 'JAMB 2025 Chemistry - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 21 - Question 21</small></p><p><strong>JAMB 2025 Chemistry - Question 21</strong></p><p>Which of the following pairs of elements will exhibit diagonal relationship?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Be and Si', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Be and Si' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Na and Be', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Na and Be' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Li and Al', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Li and Al' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'B and Si', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'B and Si' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 22 - Question 22
SET @source_marker := 'JAMB 2025 Chemistry - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 22 - Question 22</small></p><p><strong>JAMB 2025 Chemistry - Question 22</strong></p><p>The following is not a water pollutant?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'warm water affluent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'warm water affluent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inorganic fertilizers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inorganic fertilizers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxygen gas', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxygen gas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'biodegradable waste', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'biodegradable waste' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 23 - Question 23
SET @source_marker := 'JAMB 2025 Chemistry - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 23 - Question 23</small></p><p><strong>JAMB 2025 Chemistry - Question 23</strong></p><p>Acid radicals are present in </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, PO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{3-}"></span>, Mg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, PO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{3-}"></span>, Mg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, Na<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, Na<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, NO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, K<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span><span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span>, K<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 24 - Question 24
SET @source_marker := 'JAMB 2025 Chemistry - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 24 - Question 24</small></p><p><strong>JAMB 2025 Chemistry - Question 24</strong></p><p>What accounts for the low melting and boiling points of covalent molecules?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They have weak intermolecular forces', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They have weak intermolecular forces' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They have definite shapes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They have definite shapes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They are three dimensional structures', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They are three dimensional structures' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'They possess shared electron pairs', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'They possess shared electron pairs' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 25 - Question 25
SET @source_marker := 'JAMB 2025 Chemistry - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 25 - Question 25</small></p><p><strong>JAMB 2025 Chemistry - Question 25</strong></p><p>Iron produced directly from a blast furnace is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'wrought iron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'wrought iron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cast iron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cast iron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pig iron', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pig iron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carbon steel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'carbon steel' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 26 - Question 26
SET @source_marker := 'JAMB 2025 Chemistry - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 26 - Question 26</small></p><p><strong>JAMB 2025 Chemistry - Question 26</strong></p><p>What is the molecular mass of an alkanoic acid, if 0.5 mole of the acid weighs 44g?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '72', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '72' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '88', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '88' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '60', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '60' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '46', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '46' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 27 - Question 27
SET @source_marker := 'JAMB 2025 Chemistry - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 27 - Question 27</small></p><p><strong>JAMB 2025 Chemistry - Question 27</strong></p><p>Alkenes are represented with the general molecular formula </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n-2}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n-2}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n+2}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n+2}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n+1}"></span>OH', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_n"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{2n+1}"></span>OH' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 28 - Question 28
SET @source_marker := 'JAMB 2025 Chemistry - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 28 - Question 28</small></p><p><strong>JAMB 2025 Chemistry - Question 28</strong></p><p>The major product when 2-methylpropene reacts with HCl is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-chloro, 2-methylpropane', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-chloro, 2-methylpropane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1-chloro,2-methylpropane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1-chloro,2-methylpropane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3-chloro, 2-methylpropane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3-chloro, 2-methylpropane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-chloro,3-methylbutane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-chloro,3-methylbutane' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 29 - Question 29
SET @source_marker := 'JAMB 2025 Chemistry - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 29 - Question 29</small></p><p><strong>JAMB 2025 Chemistry - Question 29</strong></p><p>In the laboratory preparation of Chlorine, the gas is passed through a wash bottle of water to </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dilute it', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dilute it' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'absorb HCl gas', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'absorb HCl gas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neutralize it', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'neutralize it' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'absorb the Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> gas', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'absorb the Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> gas' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 30 - Question 30
SET @source_marker := 'JAMB 2025 Chemistry - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 30 - Question 30</small></p><p><strong>JAMB 2025 Chemistry - Question 30</strong></p><p>Carbohydrates can generally be represented by the general formula C<span contenteditable="false" class="math-editor-rendered" data-latex="_x"></span>(H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O)<span contenteditable="false" class="math-editor-rendered" data-latex="_y"></span>, for fructose the value for &quot;X&quot; is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 31 - Question 31
SET @source_marker := 'JAMB 2025 Chemistry - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 31 - Question 31</small></p><p><strong>JAMB 2025 Chemistry - Question 31</strong></p><p>If a gold bar and a silver bar are tied together firmly and left for years, some of the gold particles will be found in the silver bar due to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Brownian movement', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Brownian movement' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'diffusion', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'diffusion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'displacement', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'displacement' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'osmosis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'osmosis' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 32 - Question 32
SET @source_marker := 'JAMB 2025 Chemistry - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 32 - Question 32</small></p><p><strong>JAMB 2025 Chemistry - Question 32</strong></p><p>A metal that can be found in the free state in nature is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'silver', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'silver' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Zinc', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Zinc' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Iron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Iron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'copper', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'copper' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 33 - Question 33
SET @source_marker := 'JAMB 2025 Chemistry - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 33 - Question 33</small></p><p><strong>JAMB 2025 Chemistry - Question 33</strong></p><p>Which of the following has the highest boiling point?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>OH', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>OH' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>Cl', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>Cl' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>OH', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>OH' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 34 - Question 34
SET @source_marker := 'JAMB 2025 Chemistry - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 34 - Question 34</small></p><p><strong>JAMB 2025 Chemistry - Question 34</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q34_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 34" style="max-width:100%;height:auto;"></p><p>From the graph, it can be inferred that</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the solubility of X and Y is the same at all temperature', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the solubility of X and Y is the same at all temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the solubility of X, Y and Z is temperature dependent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the solubility of X, Y and Z is temperature dependent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'solubility of Z increases as temperature increases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'solubility of Z increases as temperature increases' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'solubility of Y increases steadily as temperature increases', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'solubility of Y increases steadily as temperature increases' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 35 - Question 35
SET @source_marker := 'JAMB 2025 Chemistry - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 35 - Question 35</small></p><p><strong>JAMB 2025 Chemistry - Question 35</strong></p><p>The gas that is commonly used to demonstrate the fountain experiment is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen chloride', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogen chloride' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen sulphide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogen sulphide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dinitrogen(I) oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dinitrogen(I) oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrogen(II) oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nitrogen(II) oxide' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 36 - Question 36
SET @source_marker := 'JAMB 2025 Chemistry - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 36 - Question 36</small></p><p><strong>JAMB 2025 Chemistry - Question 36</strong></p><p>Which of the following statements is false about hard water?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Helps animals to build strong teeth', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Helps animals to build strong teeth' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cannot be supplied in pipes made of leads', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cannot be supplied in pipes made of leads' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tastes better than soft water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tastes better than soft water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Helps animals to build strong bones.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Helps animals to build strong bones.' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 37 - Question 37
SET @source_marker := 'JAMB 2025 Chemistry - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 37 - Question 37</small></p><p><strong>JAMB 2025 Chemistry - Question 37</strong></p><p>The empirical mass of C<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{12}"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span> is </p>

<p>[H =1, C = 12, O = 16]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '90', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '90' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '180', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '180' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '45', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '45' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '30', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '30' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 38 - Question 38
SET @source_marker := 'JAMB 2025 Chemistry - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 38 - Question 38</small></p><p><strong>JAMB 2025 Chemistry - Question 38</strong></p><p>The nitrogenous compound in dead materials in the soil is converted to </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ammonia', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ammonia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trioxonitrate(V)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trioxonitrate(V)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ammonium salts', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ammonium salts' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dioxonitrate(III)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dioxonitrate(III)' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 39 - Question 39
SET @source_marker := 'JAMB 2025 Chemistry - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 39 - Question 39</small></p><p><strong>JAMB 2025 Chemistry - Question 39</strong></p><p>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>C ≡ CCH(CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span></p>

<p>The IUPAC nomenclature of the compound above is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3-ethyl but-2-yne', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3-ethyl but-2-yne' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4-methylpent-2-yne', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4-methylpent-2-yne' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-ethyl but-2-yne', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-ethyl but-2-yne' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2-methyl pent-2-yne', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2-methyl pent-2-yne' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 40 - Question 40
SET @source_marker := 'JAMB 2025 Chemistry - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 40 - Question 40</small></p><p><strong>JAMB 2025 Chemistry - Question 40</strong></p><p>In the laboratory preparation of oxygen using potassium trioxochlorate(V), tetraoxomanganate (VII), usually not recommended in modern laboratory because</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it forms explosive mixture with carbonaceous materials', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it forms explosive mixture with carbonaceous materials' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it is explosive.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it is explosive.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it reacts with the catalyst', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it reacts with the catalyst' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'it is hazardous', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'it is hazardous' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 41 - Question 41
SET @source_marker := 'JAMB 2025 Chemistry - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 41 - Question 41</small></p><p><strong>JAMB 2025 Chemistry - Question 41</strong></p><p>The type of bond between copper(II) tetraamine and chlorine in [Cu(NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>]Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dative', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dative' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'van der waals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'van der waals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ionic', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ionic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'covalent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'covalent' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 42 - Question 42
SET @source_marker := 'JAMB 2025 Chemistry - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 42 - Question 42</small></p><p><strong>JAMB 2025 Chemistry - Question 42</strong></p><p>Mg<span contenteditable="false" class="math-editor-rendered" data-latex="_{(s)}"></span>  +   2HCl<span contenteditable="false" class="math-editor-rendered" data-latex="_{(aq)}"></span> <strong>→ </strong>MgCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="_{(aq)}"></span> +  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="_{(g)}"></span></p>

<p>In the reaction above, magnesium is a reducing agent because</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxidized', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxidized' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reduced', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reduced' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a metal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a metal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a solid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a solid' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 43 - Question 43
SET @source_marker := 'JAMB 2025 Chemistry - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 43 - Question 43</small></p><p><strong>JAMB 2025 Chemistry - Question 43</strong></p><p>An example of a physical change is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'addition of water to calcium oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'addition of water to calcium oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'corrosion of iron', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'corrosion of iron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dissolving sodium chloride in water', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dissolving sodium chloride in water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'burning of charcoal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'burning of charcoal' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 44 - Question 44
SET @source_marker := 'JAMB 2025 Chemistry - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 44 - Question 44</small></p><p><strong>JAMB 2025 Chemistry - Question 44</strong></p><p>When a sample of air is passed through alkaline pyrogalol, potash and finally through U-tube containing fused calcium chloride, the components of air left unabsorbed are </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrogen and carbon(IV)oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'nitrogen and carbon(IV)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'noble gases and carbon(IV)oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'noble gases and carbon(IV)oxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'noble gases and nitrogen', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'noble gases and nitrogen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'noble gases, nitrogen and carbon(IV) oxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'noble gases, nitrogen and carbon(IV) oxide' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 45 - Question 45
SET @source_marker := 'JAMB 2025 Chemistry - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 45 - Question 45</small></p><p><strong>JAMB 2025 Chemistry - Question 45</strong></p><p>An atom of element with the configuration 1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^5"></span> is likely to belong to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'group 7', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'group 7' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'group 5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'group 5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'group 2', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'group 2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'group 3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'group 3' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 46 - Question 46
SET @source_marker := 'JAMB 2025 Chemistry - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 46 - Question 46</small></p><p><strong>JAMB 2025 Chemistry - Question 46</strong></p><p>A molecule with a polar covalent bond between atoms exhibits</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unequal sharing of electron pair', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unequal sharing of electron pair' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'equal sharing of electron pair', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'equal sharing of electron pair' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'equal sharing of electron lone pair', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'equal sharing of electron lone pair' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unequal sharing of electron lone pair', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unequal sharing of electron lone pair' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 47 - Question 47
SET @source_marker := 'JAMB 2025 Chemistry - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 47 - Question 47</small></p><p><strong>JAMB 2025 Chemistry - Question 47</strong></p><p>Mg + Pb<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> →  Mg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span> + Pb</p>

<p>What is the cell notation for the cell reaction above?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MgIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IPb', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MgIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IPb' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MgIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IIPbIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MgIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IIPbIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MgIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IPb', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MgIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^{2+}"></span>IPb' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'MgIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>IIPbIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'MgIMg<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>IIPbIPb<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 48 - Question 48
SET @source_marker := 'JAMB 2025 Chemistry - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 48 - Question 48</small></p><p><strong>JAMB 2025 Chemistry - Question 48</strong></p><p>The correct arrangement of gases in the order of increasing rate of diffusion is</p>

<p>[H = 1, C = 12, N = 14, O = 16, S = 32]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, CO', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, CO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>, H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>, H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>, NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>,N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>, NO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>,N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>, O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, NH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>, O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>, SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 49 - Question 49
SET @source_marker := 'JAMB 2025 Chemistry - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 49 - Question 49</small></p><p><strong>JAMB 2025 Chemistry - Question 49</strong></p><p>In a series of solutions with pH of 2.5, 3.5, 7.0 and 8.0, which is likely to turn red moist litmus paper blue?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.0', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.0' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 50 - Question 50
SET @source_marker := 'JAMB 2025 Chemistry - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 50 - Question 50</small></p><p><strong>JAMB 2025 Chemistry - Question 50</strong></p><p>The process by which iron corrodes is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rusting', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rusting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'burning', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'burning' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'galvanizing', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'galvanizing' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alloying', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alloying' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 51 - Question 51
SET @source_marker := 'JAMB 2025 Chemistry - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 51 - Question 51</small></p><p><strong>JAMB 2025 Chemistry - Question 51</strong></p><p>On heating 12.5g of saturated solution to dryness at 60<span contenteditable="false" class="math-editor-rendered" data-latex="^0"></span>C, 2g of anhydrous salt was recovered, calculate its solubility in grams per 100g of water.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.0' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '20.0', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '20.0' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 52 - Question 52
SET @source_marker := 'JAMB 2025 Chemistry - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 52 - Question 52</small></p><p><strong>JAMB 2025 Chemistry - Question 52</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q52_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 52" style="max-width:100%;height:auto;"></p><p>The reaction above is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neutralization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'neutralization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'substitution', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'substitution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'polymerization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'polymerization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxidation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxidation' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 53 - Question 53
SET @source_marker := 'JAMB 2025 Chemistry - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 53 - Question 53</small></p><p><strong>JAMB 2025 Chemistry - Question 53</strong></p><p>The gas produced at the cathode during electrolysis of brine is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'steam', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'steam' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'chlorine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'chlorine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxygen', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxygen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogen' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 54 - Question 54
SET @source_marker := 'JAMB 2025 Chemistry - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 54 - Question 54</small></p><p><strong>JAMB 2025 Chemistry - Question 54</strong></p><p>An example of a salt that can dissolve in water to form a solution with a pH of 7.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sodium chloride', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sodium chloride' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ammonium chloride', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ammonium chloride' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ammonium tetraoxosulphate(VI)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ammonium tetraoxosulphate(VI)' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sodium trioxocarbonate(IV)', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sodium trioxocarbonate(IV)' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 55 - Question 55
SET @source_marker := 'JAMB 2025 Chemistry - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 55 - Question 55</small></p><p><strong>JAMB 2025 Chemistry - Question 55</strong></p><p>PCl<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_g"></span>) → PCl<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_s"></span>)  +  Cl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="(_g"></span>)</p>

<p>In the equation above, the reaction will be spontaneous if</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔH = constant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔH = constant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔH = + ve', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔH = + ve' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔH = zero', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔH = zero' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔH  = - ve', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔH  = - ve' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 56 - Question 56
SET @source_marker := 'JAMB 2025 Chemistry - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 56 - Question 56</small></p><p><strong>JAMB 2025 Chemistry - Question 56</strong></p><p>C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>OH   +  CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>COOH  ⇌  CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>COOC<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>  +  H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O</p>

<p>The reaction above is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'condensation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'condensation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fermentation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fermentation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'esterification', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'esterification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrolysis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrolysis' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 57 - Question 57
SET @source_marker := 'JAMB 2025 Chemistry - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 57 - Question 57</small></p><p><strong>JAMB 2025 Chemistry - Question 57</strong></p><p>CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> - CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> - COOCH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> - CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span></p>

<p>From the condensed structure above, the reactants are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ethanol and ethanoic acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ethanol and ethanoic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propanol and propanoic acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propanol and propanoic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propanol and ethanoic acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propanol and ethanoic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propanoic acid and ethanol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propanoic acid and ethanol' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 58 - Question 58
SET @source_marker := 'JAMB 2025 Chemistry - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 58 - Question 58</small></p><p><strong>JAMB 2025 Chemistry - Question 58</strong></p><p>The stainless steel alloy is used for making</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cutlery', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cutlery' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'permanent magnets', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'permanent magnets' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rock crushers', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'rock crushers' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bridges', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'bridges' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 59 - Question 59
SET @source_marker := 'JAMB 2025 Chemistry - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 59 - Question 59</small></p><p><strong>JAMB 2025 Chemistry - Question 59</strong></p><p>The gas that ammoniacal solution of CuCl<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> is used to absorb from producer or water gas is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'CO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 60 - Question 60
SET @source_marker := 'JAMB 2025 Chemistry - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 60 - Question 60</small></p><p><strong>JAMB 2025 Chemistry - Question 60</strong></p><p>The liquid state of water at room temperature is as a result of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'electrovalent bond', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'electrovalent bond' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'covalent bond', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'covalent bond' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'van der waals forces', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'van der waals forces' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen bond', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogen bond' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 61 - Question 61
SET @source_marker := 'JAMB 2025 Chemistry - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 61 - Question 61</small></p><p><strong>JAMB 2025 Chemistry - Question 61</strong></p><p>The process that illustrates reformation of petroleum product is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hexene to hexane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hexene to hexane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cyclohexane to benzene', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cyclohexane to benzene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hexane to carbon(IV)oxide and water vapour', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hexane to carbon(IV)oxide and water vapour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hexane to butane and ethane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hexane to butane and ethane' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 62 - Question 62
SET @source_marker := 'JAMB 2025 Chemistry - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 62 - Question 62</small></p><p><strong>JAMB 2025 Chemistry - Question 62</strong></p><p>The source of carbon(II)oxide that acts as air pollutant is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'photochemical smog', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'photochemical smog' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'respiration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'respiration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'combustion of fuel', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'combustion of fuel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decomposition of sewage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'decomposition of sewage' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 63 - Question 63
SET @source_marker := 'JAMB 2025 Chemistry - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 63 - Question 63</small></p><p><strong>JAMB 2025 Chemistry - Question 63</strong></p><p>If there is no change in volume in a gaseous reaction, the pressure will</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour forward reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'favour forward reaction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'favour backward reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'favour backward reaction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have no effect on equilibrium position', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'have no effect on equilibrium position' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'have effect on equilibrium position', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'have effect on equilibrium position' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 64 - Question 64
SET @source_marker := 'JAMB 2025 Chemistry - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 64 - Question 64</small></p><p><strong>JAMB 2025 Chemistry - Question 64</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q64_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 64" style="max-width:100%;height:auto;"></p><p>The IUPAC nomenclature of the compound above is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propyl ethanoate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propyl ethanoate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ethyl ethanoate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ethyl ethanoate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ethyl propanoate', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ethyl propanoate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propyl methanoate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propyl methanoate' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 65 - Question 65
SET @source_marker := 'JAMB 2025 Chemistry - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 65 - Question 65</small></p><p><strong>JAMB 2025 Chemistry - Question 65</strong></p><p>If 5g of Iron filling was reacted with excess dilute H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> to evolve hydrogen gas, which came to completion after 10 min, calculate the rate of reaction in g/hr.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '30', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '30' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '20', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '20' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 66 - Question 66
SET @source_marker := 'JAMB 2025 Chemistry - Item 66 - Question 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 66 - Question 66</small></p><p><strong>JAMB 2025 Chemistry - Question 66</strong></p><p>The evaluation of petrol from crude oil before it is put on sale is to prevent</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pinking', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pinking' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reforming', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reforming' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pyrolysis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pyrolysis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cracking', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cracking' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 67 - Question 67
SET @source_marker := 'JAMB 2025 Chemistry - Item 67 - Question 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 67 - Question 67</small></p><p><strong>JAMB 2025 Chemistry - Question 67</strong></p><p>The metal used as a packaging material is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Al', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Al' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cu', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cu' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fe', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fe' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Na', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Na' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 68 - Question 68
SET @source_marker := 'JAMB 2025 Chemistry - Item 68 - Question 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 68 - Question 68</small></p><p><strong>JAMB 2025 Chemistry - Question 68</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q68_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 68" style="max-width:100%;height:auto;"></p><p>The expression above represents</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Avogadro&#039;s law', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Avogadro&#039;s law' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Boyle&#039;s law', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Boyle&#039;s law' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'General gas law', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'General gas law' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Charles&#039; law', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Charles&#039; law' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 69 - Question 69
SET @source_marker := 'JAMB 2025 Chemistry - Item 69 - Question 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 69 - Question 69</small></p><p><strong>JAMB 2025 Chemistry - Question 69</strong></p><p>The basicity of  C<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span> is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 70 - Question 70
SET @source_marker := 'JAMB 2025 Chemistry - Item 70 - Question 70';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 70 - Question 70</small></p><p><strong>JAMB 2025 Chemistry - Question 70</strong></p><p>Enzymatic conversion of glucose to ethanol is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'polymerization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'polymerization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogenation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogenation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fermentation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fermentation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'saponification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'saponification' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 71 - Question 71
SET @source_marker := 'JAMB 2025 Chemistry - Item 71 - Question 71';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 71 - Question 71</small></p><p><strong>JAMB 2025 Chemistry - Question 71</strong></p><p>Gold does not require extraction because it is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a precious mineral', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a precious mineral' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'inert', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'inert' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'free in nature', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'free in nature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neutral', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'neutral' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 72 - Question 72
SET @source_marker := 'JAMB 2025 Chemistry - Item 72 - Question 72';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 72 - Question 72</small></p><p><strong>JAMB 2025 Chemistry - Question 72</strong></p><p>The process employed in the industrial preparation of tetraoxosulphate(VI) acid is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Contact', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Contact' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bosch', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bosch' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Frasch', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Frasch' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Haber', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Haber' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 73 - Question 73
SET @source_marker := 'JAMB 2025 Chemistry - Item 73 - Question 73';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 73 - Question 73</small></p><p><strong>JAMB 2025 Chemistry - Question 73</strong></p><p>The catalytic hydrogenation of benzene produces</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hexane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hexane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'margarine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'margarine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hexene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hexene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cyclohexane', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cyclohexane' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 74 - Question 74
SET @source_marker := 'JAMB 2025 Chemistry - Item 74 - Question 74';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 74 - Question 74</small></p><p><strong>JAMB 2025 Chemistry - Question 74</strong></p><p>A by-product of the alkaline hydrolysis of tristearin is a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dihydric alkanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dihydric alkanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tertiary alkanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tertiary alkanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'secondary alkanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'secondary alkanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'trihydric alkanol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'trihydric alkanol' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 75 - Question 75
SET @source_marker := 'JAMB 2025 Chemistry - Item 75 - Question 75';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 75 - Question 75</small></p><p><strong>JAMB 2025 Chemistry - Question 75</strong></p><p>2SO<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="_{(s)}"></span>  +  O<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span><span contenteditable="false" class="math-editor-rendered" data-latex="_{(s)}"></span> ⇌  2SO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> ; ΔG° = - ve</p>

<p>For the above reaction to be feasible</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔH = + ve ,ΔS = + ve', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔH = + ve ,ΔS = + ve' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔH = 0 ,ΔS = + ve', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔH = 0 ,ΔS = + ve' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔH = + ve ,ΔS = - ve', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔH = + ve ,ΔS = - ve' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ΔS = 0', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ΔS = 0' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 76 - Question 76
SET @source_marker := 'JAMB 2025 Chemistry - Item 76 - Question 76';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 76 - Question 76</small></p><p><strong>JAMB 2025 Chemistry - Question 76</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q76_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 76" style="max-width:100%;height:auto;"></p><p>Sodium in the above reaction is produced by </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Browning process', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Browning process' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Chlor process', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Chlor process' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Downs process', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Downs process' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bosch process', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bosch process' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 77 - Question 77
SET @source_marker := 'JAMB 2025 Chemistry - Item 77 - Question 77';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 77 - Question 77</small></p><p><strong>JAMB 2025 Chemistry - Question 77</strong></p><p>The use of CFCs as a blowing agent has application in</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'foam industry', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'foam industry' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tyre industry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'tyre industry' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'refrigerant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'refrigerant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propellant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propellant' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 78 - Question 78
SET @source_marker := 'JAMB 2025 Chemistry - Item 78 - Question 78';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 78 - Question 78</small></p><p><strong>JAMB 2025 Chemistry - Question 78</strong></p><p>The metal that will liberate H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span> gas from dilute HNO<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span> is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cu', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cu' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mg', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mg' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ca', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ca' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Zn', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Zn' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 79 - Question 79
SET @source_marker := 'JAMB 2025 Chemistry - Item 79 - Question 79';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 79 - Question 79</small></p><p><strong>JAMB 2025 Chemistry - Question 79</strong></p><p>Atom with the electron configuration of 1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span> belongs to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Group 3 and Period 2', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Group 3 and Period 2' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Group 8 and Period 3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Group 8 and Period 3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Group 2 and Period 3', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Group 2 and Period 3' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Group 2 and Period 6', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Group 2 and Period 6' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 80 - Question 80
SET @source_marker := 'JAMB 2025 Chemistry - Item 80 - Question 80';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 80 - Question 80</small></p><p><strong>JAMB 2025 Chemistry - Question 80</strong></p><p>The relative molecular mass of an alkanoic acid with the empirical formula of CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O is</p>

<p>[ H = 1, C = 12, O = 16 ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '46', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '46' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '88', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '88' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '60', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '60' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '72', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '72' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 81 - Question 81
SET @source_marker := 'JAMB 2025 Chemistry - Item 81 - Question 81';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 81 - Question 81</small></p><p><strong>JAMB 2025 Chemistry - Question 81</strong></p><p>Commercial deodorant is an example of a colloid called</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aerosol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aerosol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'foam', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'foam' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'emulsion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'emulsion' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 82 - Question 82
SET @source_marker := 'JAMB 2025 Chemistry - Item 82 - Question 82';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 82 - Question 82</small></p><p><strong>JAMB 2025 Chemistry - Question 82</strong></p><p>Calculate the time required to liberate 9g of Aluminium metal, when a current of 18A is passed through it.</p>

<p>(1F = 96500C , Al = 27)</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1769.17 minutes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1769.17 minutes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '89.34 minutes', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '89.34 minutes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5360.58 minutes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5360.58 minutes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '29.48 minutes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '29.48 minutes' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 83 - Question 83
SET @source_marker := 'JAMB 2025 Chemistry - Item 83 - Question 83';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 83 - Question 83</small></p><p><strong>JAMB 2025 Chemistry - Question 83</strong></p><p>What is the function of concentrated H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It reacts with metals to give a salt and hydro gas', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It reacts with metals to give a salt and hydro gas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It is a dehydrating agent', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It is a dehydrating agent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It neutralizes alkali', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It neutralizes alkali' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It produces a cryolite precipitate with basic solution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It produces a cryolite precipitate with basic solution' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 84 - Question 84
SET @source_marker := 'JAMB 2025 Chemistry - Item 84 - Question 84';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 84 - Question 84</small></p><p><strong>JAMB 2025 Chemistry - Question 84</strong></p><p>In oxidation reactions, electrons are</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrolysed', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrolysed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'removed', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'removed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'added', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'added' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrated', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrated' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 85 - Question 85
SET @source_marker := 'JAMB 2025 Chemistry - Item 85 - Question 85';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 85 - Question 85</small></p><p><strong>JAMB 2025 Chemistry - Question 85</strong></p><p>(CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>CHCH(OH)CH<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>C(CH<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>)<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span></p>

<p>The IUPAC name of the compound above is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2,5,5-trimethylhexan-3-ol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2,5,5-trimethylhexan-3-ol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1,1-dimethylisopentanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1,1-dimethylisopentanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1,1,4,4-pentamethylbutanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1,1,4,4-pentamethylbutanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2,5-dimethylhexan-4-ol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2,5-dimethylhexan-4-ol' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 86 - Question 86
SET @source_marker := 'JAMB 2025 Chemistry - Item 86 - Question 86';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 86 - Question 86</small></p><p><strong>JAMB 2025 Chemistry - Question 86</strong></p><p>Anti-freeze used in a vehicle radiator is a mixture of water and</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propanetriol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propanetriol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propanol', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propanone', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propanone' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propanal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propanal' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 87 - Question 87
SET @source_marker := 'JAMB 2025 Chemistry - Item 87 - Question 87';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 87 - Question 87</small></p><p><strong>JAMB 2025 Chemistry - Question 87</strong></p><p>Magnesium tetraoxosulphate(VI) salt is commonly used as a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'disinfectant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'disinfectant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'plasticizer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'plasticizer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fertilizer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fertilizer' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'laxative', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'laxative' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 88 - Question 88
SET @source_marker := 'JAMB 2025 Chemistry - Item 88 - Question 88';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 88 - Question 88</small></p><p><strong>JAMB 2025 Chemistry - Question 88</strong></p><p>The constituents of permalloy are Iron and </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nickel', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nickel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tin', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tin' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Chromium', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Chromium' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Copper', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Copper' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 89 - Question 89
SET @source_marker := 'JAMB 2025 Chemistry - Item 89 - Question 89';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 89 - Question 89</small></p><p><strong>JAMB 2025 Chemistry - Question 89</strong></p><p>An inflated balloon shrinks when placed in a freezer because the </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'volume of gas increases and expands', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'volume of gas increases and expands' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'number of gas molecules decreases', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'number of gas molecules decreases' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gas motion reduces and exert less pressure', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gas motion reduces and exert less pressure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gas molecules completely stop moving', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gas molecules completely stop moving' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 90 - Question 90
SET @source_marker := 'JAMB 2025 Chemistry - Item 90 - Question 90';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 90 - Question 90</small></p><p><strong>JAMB 2025 Chemistry - Question 90</strong></p><p>The compound in which the oxidation state of nitrogen is + 3 is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_3"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'N<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 91 - Question 91
SET @source_marker := 'JAMB 2025 Chemistry - Item 91 - Question 91';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 91 - Question 91</small></p><p><strong>JAMB 2025 Chemistry - Question 91</strong></p><p>Na<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>X ⇌  2Na<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span>  +  X<span contenteditable="false" class="math-editor-rendered" data-latex="^{2-}"></span></p>

<p>The bond between Na and X is likely to be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dative', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dative' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ionic', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ionic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metallic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metallic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'covalent', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'covalent' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 92 - Question 92
SET @source_marker := 'JAMB 2025 Chemistry - Item 92 - Question 92';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 92 - Question 92</small></p><p><strong>JAMB 2025 Chemistry - Question 92</strong></p><p>The compound responsible for the pleasant scent of fruits and perfumes belongs to the class of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanamide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanamide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanone', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanone' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoate', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoate' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 93 - Question 93
SET @source_marker := 'JAMB 2025 Chemistry - Item 93 - Question 93';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 93 - Question 93</small></p><p><strong>JAMB 2025 Chemistry - Question 93</strong></p><p>The most suitable indicator to be used when reacting ethanedioic acid with potassium hydroxide is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'phenolphthalein', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'phenolphthalein' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methyl orange', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methyl orange' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methyl red', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methyl red' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methyl purple', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methyl purple' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 94 - Question 94
SET @source_marker := 'JAMB 2025 Chemistry - Item 94 - Question 94';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 94 - Question 94</small></p><p><strong>JAMB 2025 Chemistry - Question 94</strong></p><p>Electron configuration of Chlorine atom is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^5"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^5"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^4"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^4"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^5"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>2P<span contenteditable="false" class="math-editor-rendered" data-latex="^5"></span>3S<span contenteditable="false" class="math-editor-rendered" data-latex="^2"></span>3P<span contenteditable="false" class="math-editor-rendered" data-latex="^6"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 95 - Question 95
SET @source_marker := 'JAMB 2025 Chemistry - Item 95 - Question 95';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 95 - Question 95</small></p><p><strong>JAMB 2025 Chemistry - Question 95</strong></p><p>A table in which metals are arranged in series according to their comparative tendencies to give up their valence electrons is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'periodic table', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'periodic table' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'electrochemical series', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'electrochemical series' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'table of elements', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'table of elements' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'periodicals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'periodicals' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 96 - Question 96
SET @source_marker := 'JAMB 2025 Chemistry - Item 96 - Question 96';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 96 - Question 96</small></p><p><strong>JAMB 2025 Chemistry - Question 96</strong></p><p>An importance of solubility is that it</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'determines the amount of solute that can dissolve in a given amount of solvent', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'determines the amount of solute that can dissolve in a given amount of solvent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lowers the vapour pressure of the liquid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lowers the vapour pressure of the liquid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enables us to know the chemical reactions of the gas with the liquid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'enables us to know the chemical reactions of the gas with the liquid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'raises the boiling point of liquid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'raises the boiling point of liquid' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 97 - Question 97
SET @source_marker := 'JAMB 2025 Chemistry - Item 97 - Question 97';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 97 - Question 97</small></p><p><strong>JAMB 2025 Chemistry - Question 97</strong></p><p>The disintegration of radioactive phosphorus to silicon follows the first order kinetics with rate constant k<span contenteditable="false" class="math-editor-rendered" data-latex="_1"></span> = 3.85 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-3}"></span>. Determine the half life of phosphorus.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8 s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8 s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '180 s', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '180 s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '80 s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '80 s' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '100 s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '100 s' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 98 - Question 98
SET @source_marker := 'JAMB 2025 Chemistry - Item 98 - Question 98';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 98 - Question 98</small></p><p><strong>JAMB 2025 Chemistry - Question 98</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q98_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 98" style="max-width:100%;height:auto;"></p><p>The above structure is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkylamine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkylamine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanone', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanone' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanamide', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanamide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'amino acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'amino acid' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 99 - Question 99
SET @source_marker := 'JAMB 2025 Chemistry - Item 99 - Question 99';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 99 - Question 99</small></p><p><strong>JAMB 2025 Chemistry - Question 99</strong></p><p>The fractions of crude oil are best separated by </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'steam distillation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'steam distillation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fractional crystallization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fractional crystallization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'precipitation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'precipitation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fractional distillation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fractional distillation' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 100 - Question 100
SET @source_marker := 'JAMB 2025 Chemistry - Item 100 - Question 100';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 100 - Question 100</small></p><p><strong>JAMB 2025 Chemistry - Question 100</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q100_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 100" style="max-width:100%;height:auto;"></p><p>In the equation above, the expression for the equilibrium constant, k<span contenteditable="false" class="math-editor-rendered" data-latex="_c"></span> is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[2XY_3]}{[X_2][3Y_2]}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[2XY_3]}{[X_2][3Y_2]}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[X_2][3Y_2]}{2XY_3]}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[X_2][3Y_2]}{2XY_3]}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[XY_3]^2}{[X_2][Y_2]}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[XY_3]^2}{[X_2][Y_2]}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[X_2][Y_2]^3}{[XY_3]^2}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="\\frac{[X_2][Y_2]^3}{[XY_3]^2}"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 101 - Question 101
SET @source_marker := 'JAMB 2025 Chemistry - Item 101 - Question 101';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 101 - Question 101</small></p><p><strong>JAMB 2025 Chemistry - Question 101</strong></p><p>How many molecules are there in 4.0 moles of glucose?</p>

<p>[Avogadro&#039;s number = 6.02 x  10<span contenteditable="false" class="math-editor-rendered" data-latex="^{23}"></span>]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.51 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{23}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.51 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{23}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.41 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.41 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '24.08 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '24.08 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.51 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.51 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{24}"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 102 - Question 102
SET @source_marker := 'JAMB 2025 Chemistry - Item 102 - Question 102';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 102 - Question 102</small></p><p><strong>JAMB 2025 Chemistry - Question 102</strong></p><p>What is the product obtained at the anode in the electrolysis of concentrated sodium chloride using graphite electrode?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Chlorine gas', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Chlorine gas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxygen gas', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'oxygen gas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'water vapour', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'water vapour' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen gas', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hydrogen gas' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 103 - Question 103
SET @source_marker := 'JAMB 2025 Chemistry - Item 103 - Question 103';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 103 - Question 103</small></p><p><strong>JAMB 2025 Chemistry - Question 103</strong></p><p>Freons pollution in the air are released from </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fossil fuel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'fossil fuel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aerosol can', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aerosol can' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'photosynthesis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'photosynthesis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'organic decay', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'organic decay' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 104 - Question 104
SET @source_marker := 'JAMB 2025 Chemistry - Item 104 - Question 104';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 104 - Question 104</small></p><p><strong>JAMB 2025 Chemistry - Question 104</strong></p><p>In welding and cutting of metals, the organic gas commonly used in the heating process is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'methane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'methane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'propene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'propene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'butane', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'butane' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ethyne', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ethyne' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 105 - Question 105
SET @source_marker := 'JAMB 2025 Chemistry - Item 105 - Question 105';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 105 - Question 105</small></p><p><strong>JAMB 2025 Chemistry - Question 105</strong></p><p>Bronze is used in making</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'musical instruments and ornaments', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'musical instruments and ornaments' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'coins and medals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'coins and medals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'electromagnets and cutlery', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'electromagnets and cutlery' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aircrafts and ship', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aircrafts and ship' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 106 - Question 106
SET @source_marker := 'JAMB 2025 Chemistry - Item 106 - Question 106';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 106 - Question 106</small></p><p><strong>JAMB 2025 Chemistry - Question 106</strong></p><p>Find the hydrogen ion, H<span contenteditable="false" class="math-editor-rendered" data-latex="^+"></span> concentration and hydroxide ion, OH<span contenteditable="false" class="math-editor-rendered" data-latex="^-"></span> concentration in 0.06 moldm<span contenteditable="false" class="math-editor-rendered" data-latex="^{-3}"></span> solution of H<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>SO<span contenteditable="false" class="math-editor-rendered" data-latex="_4"></span>.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-2}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-13}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-2}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-13}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-1}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-13}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-1}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-13}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-1}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-14}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-1}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-14}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-2}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-14}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.2 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-2}"></span> ; 8.3 x 10<span contenteditable="false" class="math-editor-rendered" data-latex="^{-14}"></span>' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 107 - Question 107
SET @source_marker := 'JAMB 2025 Chemistry - Item 107 - Question 107';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 107 - Question 107</small></p><p><strong>JAMB 2025 Chemistry - Question 107</strong></p><p>After breathing in a test tube that contains acidified K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>Cr<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span>, a man noticed a change in the colour of the acidified K<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>Cr<span contenteditable="false" class="math-editor-rendered" data-latex="_2"></span>O<span contenteditable="false" class="math-editor-rendered" data-latex="_7"></span> from orange to green. This suggests the presence of </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanoic acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanoic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanol', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanol' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alkanone', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alkanone' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 108 - Question 108
SET @source_marker := 'JAMB 2025 Chemistry - Item 108 - Question 108';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 108 - Question 108</small></p><p><strong>JAMB 2025 Chemistry - Question 108</strong></p><p><img src="../uploads/question_bank/jamb_2025_chemistry/Q108_diagram.png" alt="Diagram for JAMB 2025 Chemistry Question 108" style="max-width:100%;height:auto;"></p><p>The reaction above illustrated is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spontaneous', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'spontaneous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'endothermic', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'endothermic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'exothermic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'exothermic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reversible', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reversible' AND deleted = 0);

-- JAMB 2025 Chemistry - Item 109 - Question 109
SET @source_marker := 'JAMB 2025 Chemistry - Item 109 - Question 109';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2025 Chemistry - Item 109 - Question 109</small></p><p><strong>JAMB 2025 Chemistry - Question 109</strong></p><p>The 5<span contenteditable="false" class="math-editor-rendered" data-latex="^{th}"></span> member of an alkyne series is </p>', @subject_id, 0, 'exam_body', @exam_body_id, 2025, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_8"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_8"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_5"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{12}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{12}"></span>' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'C<span contenteditable="false" class="math-editor-rendered" data-latex="_6"></span>H<span contenteditable="false" class="math-editor-rendered" data-latex="_{10}"></span>' AND deleted = 0);
COMMIT;

SELECT
    COUNT(*) AS jamb_2025_chemistry_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2025
  AND question LIKE '%JAMB 2025 Chemistry - Item%';
