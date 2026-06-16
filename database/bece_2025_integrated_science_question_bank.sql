-- BECE 2025 Integrated Science questions for the global question bank.
-- Generated from: # BECE 2025 INTEGRATED SCIENCE.md
-- Expected payload: 40 questions and 160 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.
-- Source review notes keep flagged items in draft until an SS360 admin approves them.

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

DROP PROCEDURE IF EXISTS ss360_require_bece_2025_science_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_bece_2025_science_refs()
BEGIN
    IF @bece_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'BECE exam body could not be resolved.';
    END IF;
    IF @integrated_science_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Integrated Science subject could not be resolved. Create Integrated Science, Basic Science, Science, or Basic Science and Technology before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_bece_2025_science_refs();
DROP PROCEDURE IF EXISTS ss360_require_bece_2025_science_refs;

START TRANSACTION;

-- BECE 2025 Integrated Science - Item 1 - Question 1
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 1 - Question 1%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 1 - Question 1</small></p><p><strong>BECE 2025 Integrated Science - Question 1</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Consider the statements below, which of them is a property of salt?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'turns red litmus paper blue.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'turns red litmus paper blue.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'tastes sour.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'tastes sour.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'releases hydrogen ions in solution.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'releases hydrogen ions in solution.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'formed by the reaction between an acid and a base.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'formed by the reaction between an acid and a base.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 2 - Question 2
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 2 - Question 2%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 2 - Question 2</small></p><p><strong>BECE 2025 Integrated Science - Question 2</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>How can you save energy while using electronic devices?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'leaving devices on standby mode.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'leaving devices on standby mode.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'using energy-consuming appliances.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'using energy-consuming appliances.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'turning off appliances when not in use.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'turning off appliances when not in use.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'running appliances throughout the day.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'running appliances throughout the day.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 3 - Question 3
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 3 - Question 3%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 3 - Question 3</small></p><p><strong>BECE 2025 Integrated Science - Question 3</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The main role of pulmonary circulation is</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transporting blood to the liver.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'transporting blood to the liver.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carrying deoxygenated blood to the lungs for oxygenation.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'carrying deoxygenated blood to the lungs for oxygenation.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transporting oxygen-rich blood to the body.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'transporting oxygen-rich blood to the body.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'circulating lymph fluid.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'circulating lymph fluid.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 4 - Question 4
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 4 - Question 4%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 4 - Question 4</small></p><p><strong>BECE 2025 Integrated Science - Question 4</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Hydrochloric acid is an example of a binary compound. It consists of …….</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen and chlorine', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydrogen and chlorine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen and carbon', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydrogen and carbon' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen and oxygen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydrogen and oxygen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen and nitrogen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydrogen and nitrogen' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 5 - Question 5
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 5 - Question 5%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 5 - Question 5</small></p><p><strong>BECE 2025 Integrated Science - Question 5</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The nitrogen-fixing bacteria commonly found in the soil are called……….</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'denitrifying bacteria', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'denitrifying bacteria' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rhizobia', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rhizobia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ammonifying bacteria', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'ammonifying bacteria' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrifying bacteria', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'nitrifying bacteria' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 6 - Question 6
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 6 - Question 6%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 6 - Question 6</small></p><p><strong>BECE 2025 Integrated Science - Question 6</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which of these gases is released during respiration?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydrogen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxygen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'oxygen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carbon dioxide', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'carbon dioxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrogen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'nitrogen' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 7 - Question 7
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 7 - Question 7%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 7 - Question 7</small></p><p><strong>BECE 2025 Integrated Science - Question 7</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The activity that can help us to conserve energy when driving is ……….</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carpooling with friends.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'carpooling with friends.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'frequent solo driving.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'frequent solo driving.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'regular engine idling.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'regular engine idling.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'using larger vehicles for fewer people.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'using larger vehicles for fewer people.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 8 - Question 8
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 8 - Question 8%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 8 - Question 8</small></p><p><strong>BECE 2025 Integrated Science - Question 8</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Respiratory and circulatory systems work together to</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'regulate body temperature.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'regulate body temperature.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'digest food particles.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'digest food particles.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protecting the body from pathogens.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'protecting the body from pathogens.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'transport oxygen and nutrients.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'transport oxygen and nutrients.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 9 - Question 9
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 9 - Question 9%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 9 - Question 9</small></p><p><strong>BECE 2025 Integrated Science - Question 9</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A key characteristic of specialized cells is</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lack of specific functions.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'lack of specific functions.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'perform specific tasks.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'perform specific tasks.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'high reproduction rate.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'high reproduction rate.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'random distribution in tissues.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'random distribution in tissues.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 10 - Question 10
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 10 - Question 10%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 10 - Question 10</small></p><p><strong>BECE 2025 Integrated Science - Question 10</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>In the binary compound H₂O, the 2 represent……….</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen atoms', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydrogen atoms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxygen atoms', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'oxygen atoms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydroxide atoms', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydroxide atoms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxide atoms', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'oxide atoms' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 11 - Question 11
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 11 - Question 11%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 11 - Question 11</small></p><p><strong>BECE 2025 Integrated Science - Question 11</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A grasshopper is considered as a ……</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Carnivorous', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Carnivorous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Omnivorous', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Omnivorous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Herbivorous', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Herbivorous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Detritivores', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Detritivores' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 12 - Question 12
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 12 - Question 12%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 12 - Question 12</small></p><p><strong>BECE 2025 Integrated Science - Question 12</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>How does lightning contribute to the nitrogen cycle? It……….</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'decomposes organic matter.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'decomposes organic matter.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fixes atmospheric nitrogen into nitrates.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fixes atmospheric nitrogen into nitrates.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'releases nitrogen gas into the atmosphere.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'releases nitrogen gas into the atmosphere.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'converts nitrates back into nitrogen gas.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'converts nitrates back into nitrogen gas.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 13 - Question 13
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 13 - Question 13%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 13 - Question 13</small></p><p><strong>BECE 2025 Integrated Science - Question 13</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Sodium carbonate is a binary compound used in………</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', 'Source review note: Sodium carbonate is not a binary compound. Review this item before approval.', 'draft', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fertilizers.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fertilizers.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'glass manufacturing.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'glass manufacturing.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'antiseptics.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'antiseptics.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'batteries.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'batteries.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 14 - Question 14
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 14 - Question 14%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 14 - Question 14</small></p><p><strong>BECE 2025 Integrated Science - Question 14</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A flashlight is directed towards a mirror. What happens to the reflected light?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It passes through', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'It passes through' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It spreads in all directions', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'It spreads in all directions' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It bounces off at the same angle', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'It bounces off at the same angle' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It disappears', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'It disappears' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 15 - Question 15
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 15 - Question 15%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 15 - Question 15</small></p><p><strong>BECE 2025 Integrated Science - Question 15</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Every acid has a pH value, which of these values is a strong acid?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '1' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '14' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '7' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'less than 7', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'less than 7' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 16 - Question 16
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 16 - Question 16%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 16 - Question 16</small></p><p><strong>BECE 2025 Integrated Science - Question 16</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A chemical combination of carbon and oxygen will produce carbon dioxide, what is the chemical formula for carbon dioxide?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO₃', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'CO₃' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'CO' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'CO₂', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'CO₂' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'C₂O', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'C₂O' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 17 - Question 17
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 17 - Question 17%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 17 - Question 17</small></p><p><strong>BECE 2025 Integrated Science - Question 17</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which gas makes up the majority of earth&#039;s atmosphere?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'nitrogen', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'nitrogen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'oxygen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'oxygen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'carbon dioxide', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'carbon dioxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hydrogen', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'hydrogen' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 18 - Question 18
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 18 - Question 18%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 18 - Question 18</small></p><p><strong>BECE 2025 Integrated Science - Question 18</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Calcium oxide is used primarily in…..</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cement production.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'cement production.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'perfume making.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'perfume making.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'food coloring.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'food coloring.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'batteries.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'batteries.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 19 - Question 19
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 19 - Question 19%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 19 - Question 19</small></p><p><strong>BECE 2025 Integrated Science - Question 19</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Consider the compounds below, which of them is made up of only two elements? I. water II. sodium chloride III. vinegar IV. hydrogen peroxide</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', 'Source review note: Acceptable if vinegar is treated as a mixture rather than a pure compound.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II only', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'II only' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I, II and IV', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'I, II and IV' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I, III and IV', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'I, III and IV' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II, III and IV', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'II, III and IV' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 20 - Question 20
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 20 - Question 20%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 20 - Question 20</small></p><p><strong>BECE 2025 Integrated Science - Question 20</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which part of the circulatory system is responsible for carrying oxygenated blood away from the heart?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'veins', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'veins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'capillaries', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'capillaries' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'blood cells', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'blood cells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'arteries', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'arteries' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 21 - Question 21
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 21 - Question 21%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 21 - Question 21</small></p><p><strong>BECE 2025 Integrated Science - Question 21</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>If a device consumes 500 watts and is used for 5 hours, how much energy is consumed?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1000 Wh', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '1000 Wh' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2500 Wh', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '2500 Wh' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5000 Wh', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '5000 Wh' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2000 Wh', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = '2000 Wh' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 22 - Question 22
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 22 - Question 22%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 22 - Question 22</small></p><p><strong>BECE 2025 Integrated Science - Question 22</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>What unit is used to measure energy consumption over time?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'watts', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'watts' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'amps', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'amps' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'volts', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'volts' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'watt-hours', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'watt-hours' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 23 - Question 23
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 23 - Question 23%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 23 - Question 23</small></p><p><strong>BECE 2025 Integrated Science - Question 23</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>In a simple circuit, what limits the current flow?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Battery', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Battery' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Resistor', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Resistor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Switch', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Switch' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Wire', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Wire' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 24 - Question 24
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 24 - Question 24%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 24 - Question 24</small></p><p><strong>BECE 2025 Integrated Science - Question 24</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Force that opposes the motion of objects is called:</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Friction', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Friction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Elastic', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Elastic' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gravity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Gravity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tension', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Tension' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 25 - Question 25
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 25 - Question 25%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 25 - Question 25</small></p><p><strong>BECE 2025 Integrated Science - Question 25</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A ………. is formed when light is completely blocked by an object?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'rainbow', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'rainbow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reflection', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reflection' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'shadow', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'shadow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'mirage', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'mirage' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 26 - Question 26
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 26 - Question 26%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 26 - Question 26</small></p><p><strong>BECE 2025 Integrated Science - Question 26</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Ammonia is typically used for ……….</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'food coloring', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'food coloring' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'fertilizer production', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'fertilizer production' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'bleaching agent', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'bleaching agent' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'teeth whitening', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'teeth whitening' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 27 - Question 27
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 27 - Question 27%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 27 - Question 27</small></p><p><strong>BECE 2025 Integrated Science - Question 27</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>What is the primary impact of grasshoppers on agriculture?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'increase crop yield', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'increase crop yield' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'enhance soil fertility', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'enhance soil fertility' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'crop damage and loss', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'crop damage and loss' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reduce water consumption', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'reduce water consumption' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 28 - Question 28
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 28 - Question 28%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 28 - Question 28</small></p><p><strong>BECE 2025 Integrated Science - Question 28</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>What causes the formation of shadows?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Reflection of light.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Reflection of light.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Absorption of light.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Absorption of light.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Blocking of light by an object.', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Blocking of light by an object.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Dispersion of light.', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Dispersion of light.' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 29 - Question 29
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 29 - Question 29%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 29 - Question 29</small></p><p><strong>BECE 2025 Integrated Science - Question 29</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>How can a farmer prevent pecking injuries in chickens?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', 'Source review note: Debeaking/beak trimming is welfare-sensitive. Review this item before approval.', 'draft', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Reduce lighting', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Reduce lighting' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Increase crowding', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Increase crowding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Use debeaking', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Use debeaking' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Feed less often', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Feed less often' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 30 - Question 30
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 30 - Question 30%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 30 - Question 30</small></p><p><strong>BECE 2025 Integrated Science - Question 30</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The acid that is found in citrus fruits like lemons and oranges is the ………</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Acetic acid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Acetic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Citric acid', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Citric acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hydrochloric acid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Hydrochloric acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sulfuric acid', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Sulfuric acid' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 31 - Question 31
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 31 - Question 31%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 31 - Question 31</small></p><p><strong>BECE 2025 Integrated Science - Question 31</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>To separate a mixture of two miscible liquids with close boiling points, use:</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Simple distillation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Simple distillation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fractional distillation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Fractional distillation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Filtration', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Filtration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Evaporation', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Evaporation' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 32 - Question 32
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 32 - Question 32%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 32 - Question 32</small></p><p><strong>BECE 2025 Integrated Science - Question 32</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The process in the nitrogen cycle where bacteria convert nitrogen gas into ammonia is called………….</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nitrogen fixation', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Nitrogen fixation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nitrification', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Nitrification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Denitrification', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Denitrification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Decomposition', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Decomposition' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 33 - Question 33
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 33 - Question 33%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 33 - Question 33</small></p><p><strong>BECE 2025 Integrated Science - Question 33</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The force that keeps planets orbiting the Sun is called:</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Magnetism', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Magnetism' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gravity', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Gravity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Friction', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Friction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Inertia', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Inertia' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 34 - Question 34
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 34 - Question 34%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 34 - Question 34</small></p><p><strong>BECE 2025 Integrated Science - Question 34</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>During incomplete metamorphosis, how many stages does a grasshopper undergo?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Two', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Two' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Four', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Four' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Five', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Five' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Three', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Three' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 35 - Question 35
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 35 - Question 35%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 35 - Question 35</small></p><p><strong>BECE 2025 Integrated Science - Question 35</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>Which component of the blood is primarily responsible for clotting?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Red blood cells', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Red blood cells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'White blood cells', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'White blood cells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Plasma', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Plasma' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Platelets', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Platelets' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 36 - Question 36
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 36 - Question 36%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 36 - Question 36</small></p><p><strong>BECE 2025 Integrated Science - Question 36</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>What is the relationship between power, energy, and time?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Energy = Power × Time', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Energy = Power × Time' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Power = Energy × Time', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Power = Energy × Time' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Time = Energy × Power', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Time = Energy × Power' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Energy = Power ÷ Time', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Energy = Power ÷ Time' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 37 - Question 37
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 37 - Question 37%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 37 - Question 37</small></p><p><strong>BECE 2025 Integrated Science - Question 37</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>The type of tooth mainly responsible for grinding food is the:</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Canine', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Canine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Incisor', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Incisor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Molar', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Molar' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Premolar', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Premolar' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 38 - Question 38
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 38 - Question 38%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 38 - Question 38</small></p><p><strong>BECE 2025 Integrated Science - Question 38</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>In a second-class lever, where is the load located?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Between fulcrum and effort', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Between fulcrum and effort' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'At the fulcrum', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'At the fulcrum' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'On the effort side', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'On the effort side' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Opposite the fulcrum', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Opposite the fulcrum' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 39 - Question 39
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 39 - Question 39%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 39 - Question 39</small></p><p><strong>BECE 2025 Integrated Science - Question 39</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A farmer rotates different crops on the same land each season to:</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Increase pests', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Increase pests' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Deplete nutrients', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Deplete nutrients' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Improve soil fertility', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Improve soil fertility' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Reduce crop diversity', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Reduce crop diversity' AND deleted = 0);

-- BECE 2025 Integrated Science - Item 40 - Question 40
SET @existing_question_id := (SELECT id FROM question_bank WHERE school_id = 0 AND source_type = 'exam_body' AND question LIKE '%BECE 2025 Integrated Science - Item 40 - Question 40%' AND deleted = 0 ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: BECE 2025 Integrated Science - Item 40 - Question 40</small></p><p><strong>BECE 2025 Integrated Science - Question 40</strong></p><p>Each question is followed by four options lettered A to D. Choose the correct answer.</p><p>A child who is not exposed to enough sunlight may develop which deficiency disease?</p>', @integrated_science_subject_id, 0, 'exam_body', @bece_exam_body_id, 2025, 0, 'Medium', 'JSS3', '', 'Integrated Science', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Rickets', 1, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Rickets' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Scurvy', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Scurvy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pellagra', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Pellagra' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Goitre', 0, 0
WHERE NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND options = 'Goitre' AND deleted = 0);
COMMIT;

-- Verification queries after running this migration:
-- SELECT COUNT(*) AS bece_2025_integrated_science_questions FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @integrated_science_subject_id AND exam_year = 2025 AND question LIKE '%BECE 2025 Integrated Science - Item%' AND deleted = 0;
-- SELECT review_status, COUNT(*) AS total FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @bece_exam_body_id AND subject_id = @integrated_science_subject_id AND exam_year = 2025 AND question LIKE '%BECE 2025 Integrated Science - Item%' AND deleted = 0 GROUP BY review_status;
-- SELECT COUNT(*) AS bece_2025_integrated_science_options FROM question_bank_options o JOIN question_bank q ON q.id = o.question_id WHERE q.source_type = 'exam_body' AND q.exam_body_id = @bece_exam_body_id AND q.subject_id = @integrated_science_subject_id AND q.exam_year = 2025 AND q.question LIKE '%BECE 2025 Integrated Science - Item%' AND o.deleted = 0;
