-- JAMB 2023 Biology objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2023_biology/jamb_2023_biology_import_manifest.json for exact per-item source URLs).
-- Expected payload: 78 questions and 312 options.
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
SET @subject_id := (SELECT id FROM subjects WHERE subject = 'Biology' ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_jamb_2023_biology_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2023_biology_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Biology subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2023_biology_refs();
DROP PROCEDURE ss360_require_jamb_2023_biology_refs;

START TRANSACTION;

-- JAMB 2023 Biology - Item 1 - Question 1
SET @source_marker := 'JAMB 2023 Biology - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 1 - Question 1</small></p><p><strong>JAMB 2023 Biology - Question 1</strong></p><p>Which of the following is an example of a microorganism in action as a disease vector?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fungi decomposing dead plant material', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fungi decomposing dead plant material' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mosquito transmitting malaria', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mosquito transmitting malaria' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bacteria causing food poisoning', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bacteria causing food poisoning' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Algae producing oxygen through photosynthesis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Algae producing oxygen through photosynthesis' AND deleted = 0);

-- JAMB 2023 Biology - Item 2 - Question 2
SET @source_marker := 'JAMB 2023 Biology - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 2 - Question 2</small></p><p><strong>JAMB 2023 Biology - Question 2</strong></p><p>Which of the following is a characteristic of cells related to irritability?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ability to respond to stimuli', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ability to respond to stimuli' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ability to synthesize proteins', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ability to synthesize proteins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ability to generate energy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ability to generate energy' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ability to replicate DNA', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ability to replicate DNA' AND deleted = 0);

-- JAMB 2023 Biology - Item 3 - Question 3
SET @source_marker := 'JAMB 2023 Biology - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 3 - Question 3</small></p><p><strong>JAMB 2023 Biology - Question 3</strong></p><p>The membrane around the vacuole is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Elaioplast', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Elaioplast' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Amyloplast', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Amyloplast' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tonoplast', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tonoplast' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cytoplast', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cytoplast' AND deleted = 0);

-- JAMB 2023 Biology - Item 4 - Question 4
SET @source_marker := 'JAMB 2023 Biology - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 4 - Question 4</small></p><p><strong>JAMB 2023 Biology - Question 4</strong></p><p>Which of the following is evidence of evolution?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'All of the above.', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'All of the above.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Similarities in embryonic development', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Similarities in embryonic development' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fossils of extinct organisms', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fossils of extinct organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Homologous structures in different species', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Homologous structures in different species' AND deleted = 0);

-- JAMB 2023 Biology - Item 5 - Question 5
SET @source_marker := 'JAMB 2023 Biology - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 5 - Question 5</small></p><p><strong>JAMB 2023 Biology - Question 5</strong></p><p>Which of the following is an example of an adaptation for survival in social insects?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Migration to warmer climates', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Migration to warmer climates' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Production of venom for defense', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Production of venom for defense' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Formation of complex caste systems', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Formation of complex caste systems' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hibernation during winter months', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hibernation during winter months' AND deleted = 0);

-- JAMB 2023 Biology - Item 6 - Question 6
SET @source_marker := 'JAMB 2023 Biology - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 6 - Question 6</small></p><p><strong>JAMB 2023 Biology - Question 6</strong></p><p>Which of the following is NOT a part of the alimentary canal?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oesophagus', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oesophagus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Large intestine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Large intestine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Liver', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Liver' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Small intestine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Small intestine' AND deleted = 0);

-- JAMB 2023 Biology - Item 7 - Question 7
SET @source_marker := 'JAMB 2023 Biology - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 7 - Question 7</small></p><p><strong>JAMB 2023 Biology - Question 7</strong></p><p>Which of the following is an evolutionary trend commonly observed in organisms?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Decreased complexity over time', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Decreased complexity over time' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Increased dependence on external resources', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Increased dependence on external resources' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Increased genetic diversity within populations', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Increased genetic diversity within populations' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Decreased adaptation to the environment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Decreased adaptation to the environment' AND deleted = 0);

-- JAMB 2023 Biology - Item 8 - Question 8
SET @source_marker := 'JAMB 2023 Biology - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 8 - Question 8</small></p><p><strong>JAMB 2023 Biology - Question 8</strong></p><p>Which of the following is a characteristic feature of Kingdom Plantae?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Presence of chloroplasts', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Presence of chloroplasts' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ability to perform photosynthesis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ability to perform photosynthesis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lack of cell walls', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lack of cell walls' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Heterotrophic mode of nutrition', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Heterotrophic mode of nutrition' AND deleted = 0);

-- JAMB 2023 Biology - Item 9 - Question 9
SET @source_marker := 'JAMB 2023 Biology - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 9 - Question 9</small></p><p><strong>JAMB 2023 Biology - Question 9</strong></p><p>A biome characterized by hot summer, warm winter and treeless vegetation is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Steppe grasslands', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Steppe grasslands' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Temperate deserts', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Temperate deserts' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Savannah grassland', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Savannah grassland' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tropical deserts', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tropical deserts' AND deleted = 0);

-- JAMB 2023 Biology - Item 10 - Question 10
SET @source_marker := 'JAMB 2023 Biology - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 10 - Question 10</small></p><p><strong>JAMB 2023 Biology - Question 10</strong></p><p>Which of the following is an example of physiological variation in organisms?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Variation in blood pressure among individuals', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Variation in blood pressure among individuals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Variation in beak shape among finches', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Variation in beak shape among finches' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Differences in fur color in rabbits', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Differences in fur color in rabbits' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Variation in leaf shape in plants', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Variation in leaf shape in plants' AND deleted = 0);

-- JAMB 2023 Biology - Item 11 - Question 11
SET @source_marker := 'JAMB 2023 Biology - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 11 - Question 11</small></p><p><strong>JAMB 2023 Biology - Question 11</strong></p><p>Which of the following are components of the skeletal system in humans?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cartilage and blood vessels', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cartilage and blood vessels' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ligaments and tendons', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ligaments and tendons' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Muscles and nerves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Muscles and nerves' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bones and joints', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bones and joints' AND deleted = 0);

-- JAMB 2023 Biology - Item 12 - Question 12
SET @source_marker := 'JAMB 2023 Biology - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 12 - Question 12</small></p><p><strong>JAMB 2023 Biology - Question 12</strong></p><p>Which of the following represents an example of ecological management and conservation through a biological association?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Construction of a dam for hydroelectric power', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Construction of a dam for hydroelectric power' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Introduction of an invasive species for pest control', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Introduction of an invasive species for pest control' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Clear-cutting of a forest for timber extraction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Clear-cutting of a forest for timber extraction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Establishment of marine protected areas', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Establishment of marine protected areas' AND deleted = 0);

-- JAMB 2023 Biology - Item 13 - Question 13
SET @source_marker := 'JAMB 2023 Biology - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 13 - Question 13</small></p><p><strong>JAMB 2023 Biology - Question 13</strong></p><p>The term cell was given by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Robert Hooke', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Robert Hooke' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Schwann', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Schwann' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'De Bary', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'De Bary' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tatum', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tatum' AND deleted = 0);

-- JAMB 2023 Biology - Item 14 - Question 14
SET @source_marker := 'JAMB 2023 Biology - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 14 - Question 14</small></p><p><strong>JAMB 2023 Biology - Question 14</strong></p><p>Which of the following is the primary organ involved in gas exchange during respiration in humans?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Diaphragm', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Diaphragm' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bronchi', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bronchi' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lungs', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lungs' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Trachea', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Trachea' AND deleted = 0);

-- JAMB 2023 Biology - Item 15 - Question 15
SET @source_marker := 'JAMB 2023 Biology - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 15 - Question 15</small></p><p><strong>JAMB 2023 Biology - Question 15</strong></p><p>Which gland is responsible for producing the hormone insulin?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Thyroid gland', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Thyroid gland' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pituitary gland', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pituitary gland' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pancreas', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pancreas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adrenal gland', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Adrenal gland' AND deleted = 0);

-- JAMB 2023 Biology - Item 16 - Question 16
SET @source_marker := 'JAMB 2023 Biology - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 16 - Question 16</small></p><p><strong>JAMB 2023 Biology - Question 16</strong></p><p>Most fishes do not sink in water because of the presences of:<br>\r\nI. swim bladder<br>\r\nII. air bladder<br>\r\nIII. air sacs<br>\r\nIV. air in spongy bones</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'II and III are correct', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'II and III are correct' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I and II are correct', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I and II are correct' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'I, II, III and IV are correct', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'I, II, III and IV are correct' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'III and IV are correct', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'III and IV are correct' AND deleted = 0);

-- JAMB 2023 Biology - Item 17 - Question 17
SET @source_marker := 'JAMB 2023 Biology - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 17 - Question 17</small></p><p><strong>JAMB 2023 Biology - Question 17</strong></p><p>In monohybrid inheritance, if an organism carries two different alleles for a particular gene, it is called:</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Homozygous', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Homozygous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Dominant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Dominant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Heterozygous', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Heterozygous' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Recessive', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Recessive' AND deleted = 0);

-- JAMB 2023 Biology - Item 18 - Question 18
SET @source_marker := 'JAMB 2023 Biology - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 18 - Question 18</small></p><p><strong>JAMB 2023 Biology - Question 18</strong></p><p>What is the tissue responsible for transporting water and minerals from the roots to the rest of the plant?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Xylem', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Xylem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Epidermis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Epidermis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Parenchyma', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Parenchyma' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Phloem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Phloem' AND deleted = 0);

-- JAMB 2023 Biology - Item 19 - Question 19
SET @source_marker := 'JAMB 2023 Biology - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 19 - Question 19</small></p><p><strong>JAMB 2023 Biology - Question 19</strong></p><p>Which of the following is an example of an abiotic ecological factor?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Temperature', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Competition', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Competition' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Predation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Predation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Symbiosis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Symbiosis' AND deleted = 0);

-- JAMB 2023 Biology - Item 20 - Question 20
SET @source_marker := 'JAMB 2023 Biology - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 20 - Question 20</small></p><p><strong>JAMB 2023 Biology - Question 20</strong></p><p>Which of the following processes is involved in the reproduction of developing organisms?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Budding', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Budding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Germination', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Germination' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fertilization', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fertilization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pollination', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pollination' AND deleted = 0);

-- JAMB 2023 Biology - Item 21 - Question 21
SET @source_marker := 'JAMB 2023 Biology - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 21 - Question 21</small></p><p><strong>JAMB 2023 Biology - Question 21</strong></p><p>Behavioral adaptation for dealing with a hot climate could include</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hibernating during the hottest part of the day', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hibernating during the hottest part of the day' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Large scales on the back of a lizard', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Large scales on the back of a lizard' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Feeding during the hottest part of the day', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Feeding during the hottest part of the day' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A small kidney to conserve water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A small kidney to conserve water' AND deleted = 0);

-- JAMB 2023 Biology - Item 22 - Question 22
SET @source_marker := 'JAMB 2023 Biology - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 22 - Question 22</small></p><p><strong>JAMB 2023 Biology - Question 22</strong></p><p>The natural place of an organism or community is known as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Niche', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Niche' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Habit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Habit' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Biome', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Biome' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Habitat', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Habitat' AND deleted = 0);

-- JAMB 2023 Biology - Item 23 - Question 23
SET @source_marker := 'JAMB 2023 Biology - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 23 - Question 23</small></p><p><strong>JAMB 2023 Biology - Question 23</strong></p><p>Which process in the nutrient cycle converts atmospheric nitrogen into a form that plants can utilize?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Denitrification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Denitrification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nitrogen fixation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nitrogen fixation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ammonification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ammonification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nitrification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nitrification' AND deleted = 0);

-- JAMB 2023 Biology - Item 24 - Question 24
SET @source_marker := 'JAMB 2023 Biology - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 24 - Question 24</small></p><p><strong>JAMB 2023 Biology - Question 24</strong></p><p>Which of the following functions is performed by the skin to help maintain homeostasis in the human body?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Regulation of body temperature', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Regulation of body temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Filtration of blood', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Filtration of blood' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Production of hormones', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Production of hormones' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Digestion of food', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Digestion of food' AND deleted = 0);

-- JAMB 2023 Biology - Item 25 - Question 25
SET @source_marker := 'JAMB 2023 Biology - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 25 - Question 25</small></p><p><strong>JAMB 2023 Biology - Question 25</strong></p><p>Which of the following soil types becomes less fertile due to the intense leaching caused by tropical rains?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Yellow soil', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Yellow soil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Laterite soil', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Laterite soil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Red soils', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Red soils' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Black soil', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Black soil' AND deleted = 0);

-- JAMB 2023 Biology - Item 26 - Question 26
SET @source_marker := 'JAMB 2023 Biology - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 26 - Question 26</small></p><p><strong>JAMB 2023 Biology - Question 26</strong></p><p>Which type of reproduction involves the fusion of gametes from two parents?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sexual reproduction', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sexual reproduction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Asexual reproduction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Asexual reproduction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Binary fission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Binary fission' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Budding', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Budding' AND deleted = 0);

-- JAMB 2023 Biology - Item 27 - Question 27
SET @source_marker := 'JAMB 2023 Biology - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 27 - Question 27</small></p><p><strong>JAMB 2023 Biology - Question 27</strong></p><p>Which processes are involved in nutrient cycling in a functioning ecosystem?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Erosion, weathering, and sedimentation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Erosion, weathering, and sedimentation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Decomposition, evaporation, and precipitation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Decomposition, evaporation, and precipitation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nitrogen fixation, denitrification, and ammonification', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nitrogen fixation, denitrification, and ammonification' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Respiration, photosynthesis, and transpiration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Respiration, photosynthesis, and transpiration' AND deleted = 0);

-- JAMB 2023 Biology - Item 28 - Question 28
SET @source_marker := 'JAMB 2023 Biology - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 28 - Question 28</small></p><p><strong>JAMB 2023 Biology - Question 28</strong></p><p>What is autotrophic nutrition?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nutrition in which organisms obtain food by breaking down complex organic compounds.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nutrition in which organisms obtain food by breaking down complex organic compounds.' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nutrition in which organisms obtain food from other organisms', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nutrition in which organisms obtain food from other organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nutrition in which organisms obtain food by consuming both plants and animals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nutrition in which organisms obtain food by consuming both plants and animals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nutrition in which organisms produce their own food using energy from the sun or inorganic substances', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nutrition in which organisms produce their own food using energy from the sun or inorganic substances' AND deleted = 0);

-- JAMB 2023 Biology - Item 29 - Question 29
SET @source_marker := 'JAMB 2023 Biology - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 29 - Question 29</small></p><p><strong>JAMB 2023 Biology - Question 29</strong></p><p>The theory of evolution can be defined as</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The belief that all species were created in their current form', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The belief that all species were created in their current form' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The hypothesis that organisms strive to improve themselves over generations', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The hypothesis that organisms strive to improve themselves over generations' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The idea that species change over time through natural processes', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The idea that species change over time through natural processes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The concept that evolution occurs through a series of sudden and dramatic changes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The concept that evolution occurs through a series of sudden and dramatic changes' AND deleted = 0);

-- JAMB 2023 Biology - Item 30 - Question 30
SET @source_marker := 'JAMB 2023 Biology - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 30 - Question 30</small></p><p><strong>JAMB 2023 Biology - Question 30</strong></p><p>Which of the following is a male reproductive organ in humans?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Uterus', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Uterus' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ovary', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ovary' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Testis', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Testis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fallopian tube', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fallopian tube' AND deleted = 0);

-- JAMB 2023 Biology - Item 31 - Question 31
SET @source_marker := 'JAMB 2023 Biology - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 31 - Question 31</small></p><p><strong>JAMB 2023 Biology - Question 31</strong></p><p>Which of the following is an example of a behavioral adaptation for survival in animals?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sharp teeth', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sharp teeth' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Migration', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Migration' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Wings', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Wings' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Camouflage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Camouflage' AND deleted = 0);

-- JAMB 2023 Biology - Item 32 - Question 32
SET @source_marker := 'JAMB 2023 Biology - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 32 - Question 32</small></p><p><strong>JAMB 2023 Biology - Question 32</strong></p><p>Which of the following traits is not visible in a person with Down syndrome?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Short neck', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Short neck' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'High muscle tone', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'High muscle tone' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Small stature', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Small stature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Slant eyes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Slant eyes' AND deleted = 0);

-- JAMB 2023 Biology - Item 33 - Question 33
SET @source_marker := 'JAMB 2023 Biology - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 33 - Question 33</small></p><p><strong>JAMB 2023 Biology - Question 33</strong></p><p>What is the definition of population ecology?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The study of interactions between organisms and their physical environment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The study of interactions between organisms and their physical environment' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The study of evolutionary processes and their effects on populations', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The study of evolutionary processes and their effects on populations' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The study of interactions between different populations in an ecosystem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The study of interactions between different populations in an ecosystem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The study of the distribution and abundance of individuals within a species', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The study of the distribution and abundance of individuals within a species' AND deleted = 0);

-- JAMB 2023 Biology - Item 34 - Question 34
SET @source_marker := 'JAMB 2023 Biology - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 34 - Question 34</small></p><p><strong>JAMB 2023 Biology - Question 34</strong></p><p>What is the term used to describe the maximum number of individuals of a species that an environment can support indefinitely?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ecological niche', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ecological niche' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Limiting factor', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Limiting factor' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Carrying capacity', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Carrying capacity' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Density-dependent factor', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Density-dependent factor' AND deleted = 0);

-- JAMB 2023 Biology - Item 35 - Question 35
SET @source_marker := 'JAMB 2023 Biology - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 35 - Question 35</small></p><p><strong>JAMB 2023 Biology - Question 35</strong></p><p>Which of the following statements about the heart is true?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The heart is responsible for the production of red blood cells', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The heart is responsible for the production of red blood cells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The heart pumps oxygenated blood to the lungs', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The heart pumps oxygenated blood to the lungs' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The heart receives blood from the kidneys and filters waste products', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The heart receives blood from the kidneys and filters waste products' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The heart is a muscular organ that contracts to circulate blood throughout the body', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The heart is a muscular organ that contracts to circulate blood throughout the body' AND deleted = 0);

-- JAMB 2023 Biology - Item 36 - Question 36
SET @source_marker := 'JAMB 2023 Biology - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 36 - Question 36</small></p><p><strong>JAMB 2023 Biology - Question 36</strong></p><p>What is the primary source of variation in a population?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gene flow', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Gene flow' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mutation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mutation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Natural selection', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Natural selection' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Genetic drift', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Genetic drift' AND deleted = 0);

-- JAMB 2023 Biology - Item 37 - Question 37
SET @source_marker := 'JAMB 2023 Biology - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 37 - Question 37</small></p><p><strong>JAMB 2023 Biology - Question 37</strong></p><p>Which component of blood is responsible for carrying oxygen to the body tissues?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Platelets', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Platelets' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'White blood cells', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'White blood cells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Red blood cells', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Red blood cells' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Plasma', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Plasma' AND deleted = 0);

-- JAMB 2023 Biology - Item 38 - Question 38
SET @source_marker := 'JAMB 2023 Biology - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 38 - Question 38</small></p><p><strong>JAMB 2023 Biology - Question 38</strong></p><p>What are the primary products of photosynthesis?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Carbon dioxide and water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Carbon dioxide and water' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Glucose and oxygen', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Glucose and oxygen' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Glucose and carbon dioxide', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Glucose and carbon dioxide' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oxygen and water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oxygen and water' AND deleted = 0);

-- JAMB 2023 Biology - Item 39 - Question 39
SET @source_marker := 'JAMB 2023 Biology - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 39 - Question 39</small></p><p><strong>JAMB 2023 Biology - Question 39</strong></p><p>The alternate form of a gene is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Alternate type', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Alternate type' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Dominant character', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Dominant character' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Recessive character', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Recessive character' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Allele', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Allele' AND deleted = 0);

-- JAMB 2023 Biology - Item 40 - Question 40
SET @source_marker := 'JAMB 2023 Biology - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 40 - Question 40</small></p><p><strong>JAMB 2023 Biology - Question 40</strong></p><p>Which organs are part of the alimentary canal in the human digestive system?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Salivary glands, tongue, and pharynx', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Salivary glands, tongue, and pharynx' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Large intestine, appendix, and rectum', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Large intestine, appendix, and rectum' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Stomach, liver, and gallbladder', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Stomach, liver, and gallbladder' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oesophagus, pancreas, and small intestine', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oesophagus, pancreas, and small intestine' AND deleted = 0);

-- JAMB 2023 Biology - Item 41 - Question 41
SET @source_marker := 'JAMB 2023 Biology - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 41 - Question 41</small></p><p><strong>JAMB 2023 Biology - Question 41</strong></p><p>Which of the following characteristics is typical of the phylum Arthropoda?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Radial symmetry', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Radial symmetry' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Closed circulatory system', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Closed circulatory system' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Endoskeleton made of bones', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Endoskeleton made of bones' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Presence of a segmented body', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Presence of a segmented body' AND deleted = 0);

-- JAMB 2023 Biology - Item 42 - Question 42
SET @source_marker := 'JAMB 2023 Biology - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 42 - Question 42</small></p><p><strong>JAMB 2023 Biology - Question 42</strong></p><p>Which of the following is an example of conserving resources in an ecosystem</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Excessive use of chemical fertilizers in agriculture', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Excessive use of chemical fertilizers in agriculture' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Introducing invasive species to an ecosystem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Introducing invasive species to an ecosystem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Implementing sustainable fishing practices', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Implementing sustainable fishing practices' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cutting down trees for timber production', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cutting down trees for timber production' AND deleted = 0);

-- JAMB 2023 Biology - Item 43 - Question 43
SET @source_marker := 'JAMB 2023 Biology - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 43 - Question 43</small></p><p><strong>JAMB 2023 Biology - Question 43</strong></p><p>Which of the following represents the correct hierarchical organization of life from the smallest to the largest scale?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Organs, tissues, cells, organisms, populations, communities, ecosystems', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Organs, tissues, cells, organisms, populations, communities, ecosystems' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cells, organs, tissues, organisms, populations, communities, ecosystems', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cells, organs, tissues, organisms, populations, communities, ecosystems' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tissues, organs, cells, organisms, populations, communities, ecosystems', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tissues, organs, cells, organisms, populations, communities, ecosystems' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cells, tissues, organs, organisms, populations, communities, ecosystems', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cells, tissues, organs, organisms, populations, communities, ecosystems' AND deleted = 0);

-- JAMB 2023 Biology - Item 44 - Question 44
SET @source_marker := 'JAMB 2023 Biology - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 44 - Question 44</small></p><p><strong>JAMB 2023 Biology - Question 44</strong></p><p>Which of the following blood vessels carries oxygenated blood away from the heart?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Arteries', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Arteries' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Venules', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Venules' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Capillaries', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Capillaries' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Veins', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Veins' AND deleted = 0);

-- JAMB 2023 Biology - Item 45 - Question 45
SET @source_marker := 'JAMB 2023 Biology - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 45 - Question 45</small></p><p><strong>JAMB 2023 Biology - Question 45</strong></p><p>Which of the following factors primarily affects the distribution of organisms in an ecosystem</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Wind speed', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Wind speed' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Soil pH', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Soil pH' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Temperature', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Day length', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Day length' AND deleted = 0);

-- JAMB 2023 Biology - Item 46 - Question 46
SET @source_marker := 'JAMB 2023 Biology - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 46 - Question 46</small></p><p><strong>JAMB 2023 Biology - Question 46</strong></p><p>Which of the following is NOT a method of reproduction in animals?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Asexual reproduction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Asexual reproduction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Budding', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Budding' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sexual reproduction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sexual reproduction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sporulation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sporulation' AND deleted = 0);

-- JAMB 2023 Biology - Item 47 - Question 47
SET @source_marker := 'JAMB 2023 Biology - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 47 - Question 47</small></p><p><strong>JAMB 2023 Biology - Question 47</strong></p><p>Which of the following statements is true about the kingdom Fungi?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fungi obtain nutrients by absorbing organic matter', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fungi obtain nutrients by absorbing organic matter' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fungi are photosynthetic organisms', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fungi are photosynthetic organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fungi are multicellular organisms', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fungi are multicellular organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fungi reproduce through the formation of seeds', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fungi reproduce through the formation of seeds' AND deleted = 0);

-- JAMB 2023 Biology - Item 48 - Question 48
SET @source_marker := 'JAMB 2023 Biology - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 48 - Question 48</small></p><p><strong>JAMB 2023 Biology - Question 48</strong></p><p>Viviparity refers to the reproductive strategy in which</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Offspring are produced by internal fertilization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Offspring are produced by internal fertilization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Offspring are produced by external fertilization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Offspring are produced by external fertilization' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Offspring develop and are nourished inside the female''s body', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Offspring develop and are nourished inside the female''s body' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Offspring develop and are nourished outside the female''s body', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Offspring develop and are nourished outside the female''s body' AND deleted = 0);

-- JAMB 2023 Biology - Item 49 - Question 49
SET @source_marker := 'JAMB 2023 Biology - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 49 - Question 49</small></p><p><strong>JAMB 2023 Biology - Question 49</strong></p><p>Which of the following is the most inclusive level of classification in the Linnaean system?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Kingdom', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Kingdom' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Phylum', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Phylum' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Domain', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Domain' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Class', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Class' AND deleted = 0);

-- JAMB 2023 Biology - Item 50 - Question 50
SET @source_marker := 'JAMB 2023 Biology - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 50 - Question 50</small></p><p><strong>JAMB 2023 Biology - Question 50</strong></p><p>Which of the following describes the inheritance of traits from parents to offspring?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adaptation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Adaptation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Evolution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Evolution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Natural selection', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Natural selection' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Genetics', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Genetics' AND deleted = 0);

-- JAMB 2023 Biology - Item 51 - Question 51
SET @source_marker := 'JAMB 2023 Biology - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 51 - Question 51</small></p><p><strong>JAMB 2023 Biology - Question 51</strong></p><p>Which of the following statements best describes the role of competition in the process of adaptation?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Competition leads to the selection of individuals with favorable traits for survival and reproduction', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Competition leads to the selection of individuals with favorable traits for survival and reproduction' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Competition ensures equal distribution of resources among individuals in a population', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Competition ensures equal distribution of resources among individuals in a population' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Competition leads to the development of new traits and adaptations in a population', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Competition leads to the development of new traits and adaptations in a population' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Competition reduces the need for adaptations as individuals coexist peacefully', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Competition reduces the need for adaptations as individuals coexist peacefully' AND deleted = 0);

-- JAMB 2023 Biology - Item 52 - Question 52
SET @source_marker := 'JAMB 2023 Biology - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 52 - Question 52</small></p><p><strong>JAMB 2023 Biology - Question 52</strong></p><p>Which of the following statements is true regarding sex-linked traits?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sex-linked traits are located on the sex chromosomes', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sex-linked traits are located on the sex chromosomes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sex-linked traits are inherited only from the mother', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sex-linked traits are inherited only from the mother' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sex-linked traits are more commonly observed in females', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sex-linked traits are more commonly observed in females' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sex-linked traits are not influenced by hormonal factors', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sex-linked traits are not influenced by hormonal factors' AND deleted = 0);

-- JAMB 2023 Biology - Item 53 - Question 53
SET @source_marker := 'JAMB 2023 Biology - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 53 - Question 53</small></p><p><strong>JAMB 2023 Biology - Question 53</strong></p><p>Which of the following is a plant hormone responsible for promoting cell elongation and growth?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Abscisic acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Abscisic acid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Gibberellins', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Gibberellins' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ethylene', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ethylene' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cytokinins', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cytokinins' AND deleted = 0);

-- JAMB 2023 Biology - Item 54 - Question 54
SET @source_marker := 'JAMB 2023 Biology - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 54 - Question 54</small></p><p><strong>JAMB 2023 Biology - Question 54</strong></p><p>Which of the following is a primary source of pollution in aquatic ecosystems?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Soil erosion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Soil erosion' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Industrial discharge', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Industrial discharge' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Air pollution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Air pollution' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Deforestation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Deforestation' AND deleted = 0);

-- JAMB 2023 Biology - Item 55 - Question 55
SET @source_marker := 'JAMB 2023 Biology - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 55 - Question 55</small></p><p><strong>JAMB 2023 Biology - Question 55</strong></p><p>Which of the following mechanisms is responsible for providing support in plants?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Muscles and bones', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Muscles and bones' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Exoskeleton', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Exoskeleton' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Endocrine system', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Endocrine system' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cell walls and turgor pressure', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cell walls and turgor pressure' AND deleted = 0);

-- JAMB 2023 Biology - Item 56 - Question 56
SET @source_marker := 'JAMB 2023 Biology - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 56 - Question 56</small></p><p><strong>JAMB 2023 Biology - Question 56</strong></p><p>Metamorphosis is a biological process that involves</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The growth and development of an organism from a zygote to an adult', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The growth and development of an organism from a zygote to an adult' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The change in form and structure during the life cycle of certain organisms', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The change in form and structure during the life cycle of certain organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The regeneration of lost body parts in an organism', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The regeneration of lost body parts in an organism' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The transformation of an organism from an adult stage to a larval stage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The transformation of an organism from an adult stage to a larval stage' AND deleted = 0);

-- JAMB 2023 Biology - Item 57 - Question 57
SET @source_marker := 'JAMB 2023 Biology - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 57 - Question 57</small></p><p><strong>JAMB 2023 Biology - Question 57</strong></p><p>Which of the following organs is primarily responsible for excretion in humans?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Liver', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Liver' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pancreas', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pancreas' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Kidneys', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Kidneys' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lungs', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lungs' AND deleted = 0);

-- JAMB 2023 Biology - Item 58 - Question 58
SET @source_marker := 'JAMB 2023 Biology - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 58 - Question 58</small></p><p><strong>JAMB 2023 Biology - Question 58</strong></p><p>Which of the following is the correct classification of carbohydrates?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lipid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lipid' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Phytonutrient', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Phytonutrient' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Macronutrient', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Macronutrient' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Micronutrient', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Micronutrient' AND deleted = 0);

-- JAMB 2023 Biology - Item 59 - Question 59
SET @source_marker := 'JAMB 2023 Biology - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 59 - Question 59</small></p><p><strong>JAMB 2023 Biology - Question 59</strong></p><p>Which of the following eye defects is caused by the inability of the eye to focus light on the retina?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Glaucoma', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Glaucoma' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Myopia', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Myopia' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cataracts', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cataracts' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Astigmatism', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Astigmatism' AND deleted = 0);

-- JAMB 2023 Biology - Item 60 - Question 60
SET @source_marker := 'JAMB 2023 Biology - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 60 - Question 60</small></p><p><strong>JAMB 2023 Biology - Question 60</strong></p><p>Germination is the process in which a seed</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Begins to photosynthesize', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Begins to photosynthesize' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Develops into a mature plant', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Develops into a mature plant' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Absorbs nutrients from the soil', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Absorbs nutrients from the soil' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Breaks dormancy and starts to grow', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Breaks dormancy and starts to grow' AND deleted = 0);

-- JAMB 2023 Biology - Item 61 - Question 61
SET @source_marker := 'JAMB 2023 Biology - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 61 - Question 61</small></p><p><strong>JAMB 2023 Biology - Question 61</strong></p><p>Which of the following statements is true regarding sexual reproduction in organisms?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It involves the fusion of gametes from two parents, resulting in offspring with genetic variation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It involves the fusion of gametes from two parents, resulting in offspring with genetic variation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It involves the production of offspring through a single parent, resulting in genetically identical offspring', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It involves the production of offspring through a single parent, resulting in genetically identical offspring' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It is a form of asexual reproduction where offspring are produced without the involvement of gametes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It is a form of asexual reproduction where offspring are produced without the involvement of gametes' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'It does not involve the formation of gametes or the fusion of reproductive cells', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'It does not involve the formation of gametes or the fusion of reproductive cells' AND deleted = 0);

-- JAMB 2023 Biology - Item 62 - Question 62
SET @source_marker := 'JAMB 2023 Biology - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 62 - Question 62</small></p><p><strong>JAMB 2023 Biology - Question 62</strong></p><p>Which of the following is a method of asexual reproduction in plants?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pollination', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pollination' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Vegetative propagation', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Vegetative propagation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Seed dispersal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Seed dispersal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fertilization', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fertilization' AND deleted = 0);

-- JAMB 2023 Biology - Item 63 - Question 63
SET @source_marker := 'JAMB 2023 Biology - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 63 - Question 63</small></p><p><strong>JAMB 2023 Biology - Question 63</strong></p><p>Which of the following plant tissues is responsible for transporting water and nutrients from the roots to the rest of the plant?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mesophyll', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mesophyll' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Xylem', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Xylem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Epidermis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Epidermis' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Phloem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Phloem' AND deleted = 0);

-- JAMB 2023 Biology - Item 64 - Question 64
SET @source_marker := 'JAMB 2023 Biology - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 64 - Question 64</small></p><p><strong>JAMB 2023 Biology - Question 64</strong></p><p>Which of the following statements best describes courtship behaviors in animals?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Courtship behaviors are solely performed by males to establish dominance within a social group', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Courtship behaviors are solely performed by males to establish dominance within a social group' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Courtship behaviors involve displays and rituals performed by both males and females to attract a mate', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Courtship behaviors involve displays and rituals performed by both males and females to attract a mate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Courtship behaviors are primarily performed by females to attract males for mating', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Courtship behaviors are primarily performed by females to attract males for mating' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Courtship behaviors are aggressive interactions between males competing for a female mate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Courtship behaviors are aggressive interactions between males competing for a female mate' AND deleted = 0);

-- JAMB 2023 Biology - Item 65 - Question 65
SET @source_marker := 'JAMB 2023 Biology - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 65 - Question 65</small></p><p><strong>JAMB 2023 Biology - Question 65</strong></p><p>Which of the following best describes physiological variation in biology?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Variations in the physiological processes and functions of organisms', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Variations in the physiological processes and functions of organisms' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Differences in physical characteristics and appearance within a population', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Differences in physical characteristics and appearance within a population' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Differences in behavior and social interactions among individuals', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Differences in behavior and social interactions among individuals' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Variations in the genetic makeup of individuals within a species', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Variations in the genetic makeup of individuals within a species' AND deleted = 0);

-- JAMB 2023 Biology - Item 66 - Question 66
SET @source_marker := 'JAMB 2023 Biology - Item 66 - Question 66';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 66 - Question 66</small></p><p><strong>JAMB 2023 Biology - Question 66</strong></p><p>Which of the following options correctly identifies excretory organs in animals?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Stomach, intestines, and bladder', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Stomach, intestines, and bladder' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Lungs, kidneys, and skin', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Lungs, kidneys, and skin' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Brain, spinal cord, and nerves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Brain, spinal cord, and nerves' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Heart, liver, and spleen', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Heart, liver, and spleen' AND deleted = 0);

-- JAMB 2023 Biology - Item 67 - Question 67
SET @source_marker := 'JAMB 2023 Biology - Item 67 - Question 67';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 67 - Question 67</small></p><p><strong>JAMB 2023 Biology - Question 67</strong></p><p>Which of the following best describes the concept of trophic levels in a functioning ecosystem?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The levels of ecological interactions within an ecosystem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The levels of ecological interactions within an ecosystem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The levels of energy flow within an ecosystem', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The levels of energy flow within an ecosystem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The levels of nutrient cycling within an ecosystem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The levels of nutrient cycling within an ecosystem' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The levels of biological diversity within an ecosystem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The levels of biological diversity within an ecosystem' AND deleted = 0);

-- JAMB 2023 Biology - Item 68 - Question 68
SET @source_marker := 'JAMB 2023 Biology - Item 68 - Question 68';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 68 - Question 68</small></p><p><strong>JAMB 2023 Biology - Question 68</strong></p><p>Which of the following statements best describes pollination in plants?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pollination is the process of transferring pollen from the stigma to the anther of a flower', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pollination is the process of transferring pollen from the stigma to the anther of a flower' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pollination is the process of transferring pollen from the anther to the stigma of a flower', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pollination is the process of transferring pollen from the anther to the stigma of a flower' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pollination is the process of releasing pollen into the air for dispersal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pollination is the process of releasing pollen into the air for dispersal' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pollination is the process of seed formation within a flower', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pollination is the process of seed formation within a flower' AND deleted = 0);

-- JAMB 2023 Biology - Item 69 - Question 69
SET @source_marker := 'JAMB 2023 Biology - Item 69 - Question 69';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 69 - Question 69</small></p><p><strong>JAMB 2023 Biology - Question 69</strong></p><p>Which of the following best describes a natural habitat in ecology?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'An area where organisms naturally live and interact with their surroundings', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'An area where organisms naturally live and interact with their surroundings' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A human-created environment for wildlife conservation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A human-created environment for wildlife conservation' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A controlled laboratory setting for ecological experiments', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A controlled laboratory setting for ecological experiments' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A protected area for endangered species', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A protected area for endangered species' AND deleted = 0);

-- JAMB 2023 Biology - Item 70 - Question 70
SET @source_marker := 'JAMB 2023 Biology - Item 70 - Question 70';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 70 - Question 70</small></p><p><strong>JAMB 2023 Biology - Question 70</strong></p><p>Which of the following statements about viruses is true?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Viruses can reproduce outside of a host cell', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Viruses can reproduce outside of a host cell' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Viruses require a host cell to replicate', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Viruses require a host cell to replicate' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Viruses possess a cellular structure', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Viruses possess a cellular structure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Viruses are living organisms', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Viruses are living organisms' AND deleted = 0);

-- JAMB 2023 Biology - Item 71 - Question 71
SET @source_marker := 'JAMB 2023 Biology - Item 71 - Question 71';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 71 - Question 71</small></p><p><strong>JAMB 2023 Biology - Question 71</strong></p><p>Which of the following statements is true regarding cell growth?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cell growth is solely influenced by external factors', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cell growth is solely influenced by external factors' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cell growth is a continuous process throughout the life of a cell', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cell growth is a continuous process throughout the life of a cell' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cell growth involves an increase in the number of organelles within a cell', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cell growth involves an increase in the number of organelles within a cell' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cell growth occurs by cell division', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cell growth occurs by cell division' AND deleted = 0);

-- JAMB 2023 Biology - Item 72 - Question 72
SET @source_marker := 'JAMB 2023 Biology - Item 72 - Question 72';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 72 - Question 72</small></p><p><strong>JAMB 2023 Biology - Question 72</strong></p><p>Which of the following statements is true regarding the urinary tubule in the excretory system?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The urinary tubule is responsible for the production of urine', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The urinary tubule is responsible for the production of urine' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The urinary tubule regulates the water and electrolyte balance in the body', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The urinary tubule regulates the water and electrolyte balance in the body' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The urinary tubule connects the kidneys to the bladder', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The urinary tubule connects the kidneys to the bladder' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The urinary tubule is the site of filtration of blood', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The urinary tubule is the site of filtration of blood' AND deleted = 0);

-- JAMB 2023 Biology - Item 73 - Question 73
SET @source_marker := 'JAMB 2023 Biology - Item 73 - Question 73';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 73 - Question 73</small></p><p><strong>JAMB 2023 Biology - Question 73</strong></p><p>What is the primary function of the liver in the human body?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Regulation of body temperature', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Regulation of body temperature' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Regulation of blood pressure', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Regulation of blood pressure' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Production of hormones', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Production of hormones' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Detoxification and metabolism of nutrients and drugs', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Detoxification and metabolism of nutrients and drugs' AND deleted = 0);

-- JAMB 2023 Biology - Item 74 - Question 74
SET @source_marker := 'JAMB 2023 Biology - Item 74 - Question 74';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 74 - Question 74</small></p><p><strong>JAMB 2023 Biology - Question 74</strong></p><p>Ecological succession refers to</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The movement of organisms from one habitat to another', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The movement of organisms from one habitat to another' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The competition among species for limited resources', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The competition among species for limited resources' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The process of natural selection in a population', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The process of natural selection in a population' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The gradual and predictable change in a community over time', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The gradual and predictable change in a community over time' AND deleted = 0);

-- JAMB 2023 Biology - Item 75 - Question 75
SET @source_marker := 'JAMB 2023 Biology - Item 75 - Question 75';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 75 - Question 75</small></p><p><strong>JAMB 2023 Biology - Question 75</strong></p><p>Which of the following options best describes adaptation for survival in organisms?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adaptation is the inherited trait that increases an organism''s chances of survival and reproduction in its environment', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Adaptation is the inherited trait that increases an organism''s chances of survival and reproduction in its environment' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adaptation is the process by which organisms acquire new characteristics during their lifetime', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Adaptation is the process by which organisms acquire new characteristics during their lifetime' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adaptation refers to the ability of an organism to change its environment to better suit its needs', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Adaptation refers to the ability of an organism to change its environment to better suit its needs' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Adaptation involves the development of new traits in response to changes in the environment', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Adaptation involves the development of new traits in response to changes in the environment' AND deleted = 0);

-- JAMB 2023 Biology - Item 76 - Question 76
SET @source_marker := 'JAMB 2023 Biology - Item 76 - Question 76';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 76 - Question 76</small></p><p><strong>JAMB 2023 Biology - Question 76</strong></p><p>Digestive enzymes are responsible for</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Breaking down food into smaller molecules', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Breaking down food into smaller molecules' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Absorbing nutrients into the bloodstream', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Absorbing nutrients into the bloodstream' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Regulating the pH of the digestive tract', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Regulating the pH of the digestive tract' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Transporting food through the digestive system', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Transporting food through the digestive system' AND deleted = 0);

-- JAMB 2023 Biology - Item 77 - Question 77
SET @source_marker := 'JAMB 2023 Biology - Item 77 - Question 77';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 77 - Question 77</small></p><p><strong>JAMB 2023 Biology - Question 77</strong></p><p>Which of the following is a difference between plant and animal cells?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Plant cells have a nucleus, while animal cells do not', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Plant cells have a nucleus, while animal cells do not' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Plant cells have a cell membrane, while animal cells have a cell wall', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Plant cells have a cell membrane, while animal cells have a cell wall' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Plant cells contain chloroplasts for photosynthesis, while animal cells do not', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Plant cells contain chloroplasts for photosynthesis, while animal cells do not' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Plant cells have a central vacuole, while animal cells have multiple small vacuoles', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Plant cells have a central vacuole, while animal cells have multiple small vacuoles' AND deleted = 0);

-- JAMB 2023 Biology - Item 78 - Question 78
SET @source_marker := 'JAMB 2023 Biology - Item 78 - Question 78';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Biology - Item 78 - Question 78</small></p><p><strong>JAMB 2023 Biology - Question 78</strong></p><p>Which of the following structures in the ear is responsible for transmitting sound vibrations to the auditory nerve?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Eardrum', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Eardrum' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ossicles', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ossicles' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cochlea', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cochlea' AND deleted = 0);
INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Auditory canal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Auditory canal' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS jamb_2023_biology_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2023
  AND question LIKE '%JAMB 2023 Biology - Item%';
