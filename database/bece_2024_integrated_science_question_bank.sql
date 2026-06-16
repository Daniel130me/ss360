-- BECE 2024 Integrated Science questions for the global question bank.
-- Generated from: # BECE 2024 INTEGRATED SCIENCE.md
-- Expected payload: 40 questions and 160 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.
-- Source verification notes keep flagged items in draft until an SS360 admin approves them.

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
SET @integrated_science_subject_id := (
    SELECT id
    FROM subjects
    WHERE subject IN ('Integrated Science', 'Basic Science', 'Science', 'Basic Science and Technology')
    ORDER BY FIELD(subject, 'Integrated Science', 'Basic Science', 'Science', 'Basic Science and Technology'), id ASC
    LIMIT 1
);

DROP PROCEDURE IF EXISTS ss360_require_bece_2024_science_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_bece_2024_science_refs()
BEGIN
    IF @bece_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BECE exam body could not be resolved.';
    END IF;
    IF @integrated_science_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Integrated Science subject could not be resolved. Create Integrated Science, Basic Science, Science, or Basic Science and Technology before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_bece_2024_science_refs();
DROP PROCEDURE IF EXISTS ss360_require_bece_2024_science_refs;

START TRANSACTION;

-- BECE 2024 Integrated Science - Item 1 - Question 1
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 1 - Question 1%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 1 - Question 1</small></p><p><strong>BECE 2024 Integrated Science - Question 1</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which of the following factors affect the rate of diffusion? I. particle size II. type of fluid III. temperature</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and II only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'I and II only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'III only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'III only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and III only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'I and III only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I, II and III', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'I, II and III' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 2 - Question 2
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 2 - Question 2%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 2 - Question 2</small></p><p><strong>BECE 2024 Integrated Science - Question 2</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Nucleons consist of....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'electrons, protons and neutrons', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'electrons, protons and neutrons' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'neutrons and electrons', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'neutrons and electrons' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'electrons and protons', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'electrons and protons' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protons and neutrons', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'protons and neutrons' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 3 - Question 3
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 3 - Question 3%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 3 - Question 3</small></p><p><strong>BECE 2024 Integrated Science - Question 3</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>An atom of an element Y has 11 protons and 12 neutrons. What is the number of electrons?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '12' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '11', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '11' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '23', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '23' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '1' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 4 - Question 4
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 4 - Question 4%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 4 - Question 4</small></p><p><strong>BECE 2024 Integrated Science - Question 4</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The following animals belong to the same community except.....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', 'Source verification note: Ambiguous ecology/community question. Review this item before approval.', 'draft', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Salmon', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Salmon' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Octopus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Octopus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tilapia', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Tilapia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Herring', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Herring' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 5 - Question 5
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 5 - Question 5%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 5 - Question 5</small></p><p><strong>BECE 2024 Integrated Science - Question 5</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Kerosene and petrol are obtained from crude oil by........</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Distillation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Distillation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Condensation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Condensation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Filtration', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Filtration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Evaporation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Evaporation' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 6 - Question 6
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 6 - Question 6%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 6 - Question 6</small></p><p><strong>BECE 2024 Integrated Science - Question 6</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which of the following ways of treating water makes the water soft?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adding alum', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Adding alum' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adding washing soda', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Adding washing soda' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Chlorination', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Chlorination' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Filtering', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Filtering' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 7 - Question 7
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 7 - Question 7%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 7 - Question 7</small></p><p><strong>BECE 2024 Integrated Science - Question 7</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The unit for electric charge is ......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Current', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Current' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ammeter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Ammeter' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Coulombs', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Coulombs' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ampere', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Ampere' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 8 - Question 8
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 8 - Question 8%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 8 - Question 8</small></p><p><strong>BECE 2024 Integrated Science - Question 8</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Porcelain is an example of ......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Conductor', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Conductor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Insulator', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Insulator' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Semi-conductor', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Semi-conductor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Convection', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Convection' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 9 - Question 9
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 9 - Question 9%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 9 - Question 9</small></p><p><strong>BECE 2024 Integrated Science - Question 9</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The part of a cocoyam which is used in propagation is the .....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bulb', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Bulb' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Corm', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Corm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Seed', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Seed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sucker', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Sucker' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 10 - Question 10
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 10 - Question 10%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 10 - Question 10</small></p><p><strong>BECE 2024 Integrated Science - Question 10</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Blood in the urine is a symptom of .......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bilharzia', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Bilharzia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cholera', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Cholera' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gonorrhea', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Gonorrhea' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Typhoid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Typhoid' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 11 - Question 11
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 11 - Question 11%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 11 - Question 11</small></p><p><strong>BECE 2024 Integrated Science - Question 11</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Ringworm is a skin disease which is caused by......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bacteria', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Bacteria' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fungi', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Fungi' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Insects', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Insects' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Worms', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Worms' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 12 - Question 12
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 12 - Question 12%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 12 - Question 12</small></p><p><strong>BECE 2024 Integrated Science - Question 12</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A man did 75 J of work by lifting a 50 N load from the floor onto a shelf. Calculate the height of the shelf.</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.67 m', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '0.67 m' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '25.00 m', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '25.00 m' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.50 m', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '1.50 m' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '125.00 m', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '125.00 m' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 13 - Question 13
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 13 - Question 13%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 13 - Question 13</small></p><p><strong>BECE 2024 Integrated Science - Question 13</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Weeds on a school farm can be controlled by ......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', 'Source verification note: More than one option can control weeds. Review this item before approval.', 'draft', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hand-picking', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Hand-picking' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mowing', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Mowing' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ploughing', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Ploughing' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tilling', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Tilling' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 14 - Question 14
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 14 - Question 14%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 14 - Question 14</small></p><p><strong>BECE 2024 Integrated Science - Question 14</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The practice that excess branches of growing plants are removed is called....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mulching', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Mulching' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pruning', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Pruning' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Thinning', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Thinning' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Staking', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Staking' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 15 - Question 15
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 15 - Question 15%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 15 - Question 15</small></p><p><strong>BECE 2024 Integrated Science - Question 15</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The feeling of soil between fingers is used to determine the........</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Texture of the soil', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Texture of the soil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Drainage of the soil', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Drainage of the soil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Capillary of the soil', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Capillary of the soil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Water holding capacity of the soil', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Water holding capacity of the soil' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 16 - Question 16
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 16 - Question 16%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 16 - Question 16</small></p><p><strong>BECE 2024 Integrated Science - Question 16</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Water drains faster through sand than clay because.....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sand particles are rougher', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Sand particles are rougher' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sand contains more air space', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Sand contains more air space' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Clay particles are smoother', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Clay particles are smoother' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Clay particles are bigger', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Clay particles are bigger' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 17 - Question 17
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 17 - Question 17%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 17 - Question 17</small></p><p><strong>BECE 2024 Integrated Science - Question 17</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A meter rule can be used for measuring the .....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Volume of a liquid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Volume of a liquid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Area of a ball', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Area of a ball' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Length of a table', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Length of a table' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Diameter of a wire', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Diameter of a wire' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 18 - Question 18
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 18 - Question 18%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 18 - Question 18</small></p><p><strong>BECE 2024 Integrated Science - Question 18</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The basic unit of a living organism is called.....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cell', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Cell' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tissue', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Tissue' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Organ', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Organ' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nucleus', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Nucleus' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 19 - Question 19
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 19 - Question 19%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 19 - Question 19</small></p><p><strong>BECE 2024 Integrated Science - Question 19</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The last stage of reproduction is ......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Embryo', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Embryo' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pregnancy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Pregnancy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fertilization', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Fertilization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Birth', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Birth' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 20 - Question 20
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 20 - Question 20%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 20 - Question 20</small></p><p><strong>BECE 2024 Integrated Science - Question 20</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Steel is an alloy made of .......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Iron and carbon', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Iron and carbon' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Zinc and copper', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Zinc and copper' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Iron and zinc', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Iron and zinc' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Brass and zinc', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Brass and zinc' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 21 - Question 21
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 21 - Question 21%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 21 - Question 21</small></p><p><strong>BECE 2024 Integrated Science - Question 21</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A chemical that can be used to test for the presence of protein in food substances is ....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Benedict&#039;s solution', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Benedict&#039;s solution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fehling&#039;s solution', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Fehling&#039;s solution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Iodine solution', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Iodine solution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Millon&#039;s solution', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Millon&#039;s solution' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 22 - Question 22
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 22 - Question 22%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 22 - Question 22</small></p><p><strong>BECE 2024 Integrated Science - Question 22</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A solution which can dissolve more solute at a given temperature is known as.....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Saturated solution', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Saturated solution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Aqueous solution', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Aqueous solution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Unsaturated solution', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Unsaturated solution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Dilute solution', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Dilute solution' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 23 - Question 23
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 23 - Question 23%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 23 - Question 23</small></p><p><strong>BECE 2024 Integrated Science - Question 23</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>What is the atomic number of magnesium?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '13', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '13' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '12' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '18' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '6' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 24 - Question 24
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 24 - Question 24%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 24 - Question 24</small></p><p><strong>BECE 2024 Integrated Science - Question 24</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Pure water is ......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bitter', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Bitter' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tasteless', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Tasteless' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sugary', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Sugary' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Salty', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Salty' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 25 - Question 25
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 25 - Question 25%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 25 - Question 25</small></p><p><strong>BECE 2024 Integrated Science - Question 25</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The part of the soil that is most important for growth of plant is....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sand', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Sand' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Clay', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Clay' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Humus', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Humus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Silt', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Silt' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 26 - Question 26
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 26 - Question 26%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 26 - Question 26</small></p><p><strong>BECE 2024 Integrated Science - Question 26</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Air is an example of .....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gas-in-gas mixture', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Gas-in-gas mixture' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Liquid-in-liquid mixture', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Liquid-in-liquid mixture' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Solid-in-solid mixture', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Solid-in-solid mixture' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Solid-in-liquid mixture', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Solid-in-liquid mixture' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 27 - Question 27
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 27 - Question 27%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 27 - Question 27</small></p><p><strong>BECE 2024 Integrated Science - Question 27</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A positively charged ion is called.....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Anion', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Anion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Cation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Neutron', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Neutron' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Protons', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Protons' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 28 - Question 28
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 28 - Question 28%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 28 - Question 28</small></p><p><strong>BECE 2024 Integrated Science - Question 28</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A group of atoms of the same or different elements chemically combined is called.....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ion', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Ion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Molecule', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Molecule' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Atom', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Atom' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Element', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Element' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 29 - Question 29
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 29 - Question 29%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 29 - Question 29</small></p><p><strong>BECE 2024 Integrated Science - Question 29</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The process by which naphthalene ball placed in a box gets smaller in size is ...</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sublimation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Sublimation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Condensation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Condensation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Melting', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Melting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Evaporation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Evaporation' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 30 - Question 30
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 30 - Question 30%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 30 - Question 30</small></p><p><strong>BECE 2024 Integrated Science - Question 30</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which of the following farming systems involves the cultivation of crops and rearing of animals?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mixed cropping', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Mixed cropping' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pastoral farming', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Pastoral farming' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mixed farming', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Mixed farming' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Crop rotation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Crop rotation' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 31 - Question 31
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 31 - Question 31%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 31 - Question 31</small></p><p><strong>BECE 2024 Integrated Science - Question 31</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which part of a tilapia is used to control yawing?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', 'Source verification note: Fish fin function may vary by textbook. Review this item before approval.', 'draft', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Scales', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Scales' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pelvic and anal fins', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Pelvic and anal fins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pectoral and dorsal fins', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Pectoral and dorsal fins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Dorsal and anal fins', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Dorsal and anal fins' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 32 - Question 32
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 32 - Question 32%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 32 - Question 32</small></p><p><strong>BECE 2024 Integrated Science - Question 32</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>An organism which is fed on in an ecosystem is called.....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Predation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Predation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Prey', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Prey' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Predator', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Predator' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Anteater', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Anteater' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 33 - Question 33
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 33 - Question 33%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 33 - Question 33</small></p><p><strong>BECE 2024 Integrated Science - Question 33</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which of the following receives a fertilized egg from the fallopian tube?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', 'Source verification note: Duplicate options concern in source review. Review this item before approval.', 'draft', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ovary', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Ovary' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cervix', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Cervix' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Uterus', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Uterus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Uteri', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Uteri' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 34 - Question 34
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 34 - Question 34%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 34 - Question 34</small></p><p><strong>BECE 2024 Integrated Science - Question 34</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The release of matured egg from the ovary into the fallopian tube is termed .....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mating', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Mating' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ovulation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Ovulation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Menstrual cycle', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Menstrual cycle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Copulation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Copulation' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 35 - Question 35
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 35 - Question 35%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 35 - Question 35</small></p><p><strong>BECE 2024 Integrated Science - Question 35</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Production of breast milk for feeding a baby is termed......</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lactation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Lactation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Prolactin', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Prolactin' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Breastfeeding', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Breastfeeding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Implantation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Implantation' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 36 - Question 36
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 36 - Question 36%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 36 - Question 36</small></p><p><strong>BECE 2024 Integrated Science - Question 36</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>One disease that affect the nervous system of human is...</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Filariasis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Filariasis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Measles', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Measles' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Poliomyelitis', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Poliomyelitis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Typhoid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Typhoid' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 37 - Question 37
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 37 - Question 37%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 37 - Question 37</small></p><p><strong>BECE 2024 Integrated Science - Question 37</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which of the following life processes leads to the release of energy?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Absorption', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Absorption' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Digestion of food', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Digestion of food' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Photosynthesis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Photosynthesis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Respiration', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Respiration' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 38 - Question 38
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 38 - Question 38%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 38 - Question 38</small></p><p><strong>BECE 2024 Integrated Science - Question 38</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Mineral salts in dead organisms are released into the soil by a process called....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Decomposition', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Decomposition' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Diffusion', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Diffusion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Leaching', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Leaching' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Osmosis', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Osmosis' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 39 - Question 39
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 39 - Question 39%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 39 - Question 39</small></p><p><strong>BECE 2024 Integrated Science - Question 39</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The male reproductive part of a flower is ....</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Stalk', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Stalk' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Receptacles', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Receptacles' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Carpel', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Carpel' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Stamen', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Stamen' AND deleted = 0);

-- BECE 2024 Integrated Science - Item 40 - Question 40
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2024 Integrated Science - Item 40 - Question 40%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2024 Integrated Science - Item 40 - Question 40</small></p><p><strong>BECE 2024 Integrated Science - Question 40</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which of these organs in humans releases carbon dioxide as a waste product?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2024, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Kidney', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Kidney' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Liver', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Liver' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lung', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Lung' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Skin', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Skin' AND deleted = 0);
COMMIT;

-- Verification queries after running this migration:
-- SELECT COUNT(*) AS bece_2024_integrated_science_questions FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @integrated_science_subject_id AND exam_year = 2024 AND question LIKE '%BECE 2024 Integrated Science - Item%' AND deleted = 0;
-- SELECT review_status, COUNT(*) AS total FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @integrated_science_subject_id AND exam_year = 2024 AND question LIKE '%BECE 2024 Integrated Science - Item%' AND deleted = 0 GROUP BY review_status;
-- SELECT COUNT(*) AS bece_2024_integrated_science_options FROM question_bank_options o JOIN question_bank q ON q.id = o.question_id WHERE q.source_type = 'exam_body' AND q.exam_body_id = @bece_exam_body_id AND q.subject_id = @integrated_science_subject_id AND q.exam_year = 2024 AND q.question LIKE '%BECE 2024 Integrated Science - Item%' AND o.deleted = 0;
