-- JAMB 2023 Physics objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2023_physics/jamb_2023_physics_import_manifest.json for exact per-item source URLs).
-- Expected payload: 64 questions and 256 options.
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
SET @subject_id := (SELECT id FROM subjects WHERE subject = 'Physics' ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_jamb_2023_physics_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2023_physics_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Physics subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2023_physics_refs();
DROP PROCEDURE ss360_require_jamb_2023_physics_refs;

START TRANSACTION;

-- JAMB 2023 Physics - Item 1 - Question 1
SET @source_marker := 'JAMB 2023 Physics - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 1 - Question 1</small></p><p><strong>JAMB 2023 Physics - Question 1</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q1_diagram.png" alt="Diagram for JAMB 2023 Physics Question 1" style="max-width:100%;height:auto;"></p><p>The property of wave shown in the diagram above is?<br>\n&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Diffraction', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Diffraction' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Refraction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Refraction' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Polarisation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Polarisation' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Interference', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Interference' AND deleted = 0);

-- JAMB 2023 Physics - Item 2 - Question 2
SET @source_marker := 'JAMB 2023 Physics - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 2 - Question 2</small></p><p><strong>JAMB 2023 Physics - Question 2</strong></p><p>Which of the following statements regarding the application of electrical conduction via gases is/are correct?<br>\nElectrical conduction in gas is applied in:<br>\n(i) The identification of gases<br>\n(ii) Lighting/fluorescent tubes<br>\n(iii) Photocells<br>\n(iv) Cathode ray oscilloscope/T.V. tubes<br>\n<br>\n&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i), (iii) and (iv) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i), (iii) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i), (ii) and (iv) only', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i), (ii) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(ii), (iii) and (iv) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(ii), (iii) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i), (ii) and (iii) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i), (ii) and (iii) only' AND deleted = 0);

-- JAMB 2023 Physics - Item 3 - Question 3
SET @source_marker := 'JAMB 2023 Physics - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 3 - Question 3</small></p><p><strong>JAMB 2023 Physics - Question 3</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q3_diagram.png" alt="Diagram for JAMB 2023 Physics Question 3" style="max-width:100%;height:auto;"></p><p>Find the tension in the two cords shown in the figure above. Neglect the mass of the cords, and assume that the angle is 38&deg; and the mass m is 220 kg</p>\n\n<p>&nbsp;</p>\n\n<p>[Take g = 9.8 ms-2]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span> = 2864 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span>= 3612 N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span> = 2864 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span>= 3612 N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span>= 3612 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span> = 2864 N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span>= 3612 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span> = 2864 N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span>= 3502 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span>= 2760 N', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span>= 3502 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span>= 2760 N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span> = 2760 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span> = 3502 N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="T_1"></span> = 2760 N,  <span contenteditable="false" class="math-editor-rendered" data-latex="T_2"></span> = 3502 N' AND deleted = 0);

-- JAMB 2023 Physics - Item 4 - Question 4
SET @source_marker := 'JAMB 2023 Physics - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 4 - Question 4</small></p><p><strong>JAMB 2023 Physics - Question 4</strong></p><p>A missile is launched with a speed of 75 ms-1 at an angle of 22&deg; above the surface of a warship. Find the horizontal range achieved by the missile. Ignore the effects of air resistance.<br>\n<br>\n[Take g = 10 ms-2]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '195', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '195' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '271 m', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '271 m' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '391 m', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '391 m' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '136 m', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '136 m' AND deleted = 0);

-- JAMB 2023 Physics - Item 5 - Question 5
SET @source_marker := 'JAMB 2023 Physics - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 5 - Question 5</small></p><p><strong>JAMB 2023 Physics - Question 5</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q5_diagram.png" alt="Diagram for JAMB 2023 Physics Question 5" style="max-width:100%;height:auto;"></p><p>On a particular hot day, the temperature is 40&deg;C and the partial pressure of water vapor in the air is 38.8 mmHg. What is the relative humidity?<br>\n<br>\n&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '70', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '70' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '62', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '62' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '80', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '80' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '42', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '42' AND deleted = 0);

-- JAMB 2023 Physics - Item 6 - Question 6
SET @source_marker := 'JAMB 2023 Physics - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 6 - Question 6</small></p><p><strong>JAMB 2023 Physics - Question 6</strong></p><p>Calculate the absolute pressure at the bottom of a lake at a depth of 32.8 m. Assume the density of the water is 1 x 10^3 kgm-3 and the air above is at a pressure of 101.3 kPa.<br>\n<br>\n[Take g = 9.8 ms-2]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '422.7', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '422.7' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '220.14', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '220.14' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '464.53', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '464.53' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '321.74', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '321.74' AND deleted = 0);

-- JAMB 2023 Physics - Item 7 - Question 7
SET @source_marker := 'JAMB 2023 Physics - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 7 - Question 7</small></p><p><strong>JAMB 2023 Physics - Question 7</strong></p><p>The terminals of a battery of emf 24.0 V and internal resistance of 1.0 &Omega; is connected to an external resistor 5.0 &Omega;. Find the terminal p.d.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18.0V', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '18.0V' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '12.0V', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '12.0V' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16.0V', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16.0V' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '20.0V', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '20.0V' AND deleted = 0);

-- JAMB 2023 Physics - Item 8 - Question 8
SET @source_marker := 'JAMB 2023 Physics - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 8 - Question 8</small></p><p><strong>JAMB 2023 Physics - Question 8</strong></p><p>A lorry accelerates uniformly in a straight line with acceleration of&nbsp; <span contenteditable="false" class="math-editor-rendered" data-latex="4ms^-2"></span> and covers a distance of 250 m in a time interval of 10 s. How far will it travel in the next 10 s?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '650', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '650' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '900', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '900' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '800', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '800' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '250', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '250' AND deleted = 0);

-- JAMB 2023 Physics - Item 9 - Question 9
SET @source_marker := 'JAMB 2023 Physics - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 9 - Question 9</small></p><p><strong>JAMB 2023 Physics - Question 9</strong></p><p>The half life of a radioactive material is 12 days. Calculate the decay constant.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.8663 <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.8663 <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.04331 <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.04331 <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.17325  <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.17325  <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.05775  <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.05775  <span contenteditable="false" class="math-editor-rendered" data-latex="day^{-1}"></span>' AND deleted = 0);

-- JAMB 2023 Physics - Item 10 - Question 10
SET @source_marker := 'JAMB 2023 Physics - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 10 - Question 10</small></p><p><strong>JAMB 2023 Physics - Question 10</strong></p><p>The number of holes in an intrinsic semiconductor</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is not equal to the number of free electrons', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'is not equal to the number of free electrons' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is greater than the number of free electrons', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'is greater than the number of free electrons' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is equal to the number of free electrons', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'is equal to the number of free electrons' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'is less than the number of free electrons', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'is less than the number of free electrons' AND deleted = 0);

-- JAMB 2023 Physics - Item 11 - Question 11
SET @source_marker := 'JAMB 2023 Physics - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 11 - Question 11</small></p><p><strong>JAMB 2023 Physics - Question 11</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q11_diagram.png" alt="Diagram for JAMB 2023 Physics Question 11" style="max-width:100%;height:auto;"></p><p>Name the type of equilibrium for each position of the ball</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A - unstable, B - neutral, C - stable', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A - unstable, B - neutral, C - stable' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A - stable, B - neutral, C - unstable', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A - stable, B - neutral, C - unstable' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A - stable, B - unstable, C - neutral', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A - stable, B - unstable, C - neutral' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'A - unstable, B - stable, C - neutral', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'A - unstable, B - stable, C - neutral' AND deleted = 0);

-- JAMB 2023 Physics - Item 12 - Question 12
SET @source_marker := 'JAMB 2023 Physics - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 12 - Question 12</small></p><p><strong>JAMB 2023 Physics - Question 12</strong></p><p>Rainbow formation is as a result of the combination of which of the following phenomena?<br>\n(i) Reflection<br>\n(ii) Dispersion<br>\n(iii) Total internal reflection<br>\n(iv) Refraction</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(ii) and (iv) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(ii) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i), (iii) and (iv) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i), (iii) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(ii), (iii) and (iv) only', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(ii), (iii) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i), (ii) and (iv) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i), (ii) and (iv) only' AND deleted = 0);

-- JAMB 2023 Physics - Item 13 - Question 13
SET @source_marker := 'JAMB 2023 Physics - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 13 - Question 13</small></p><p><strong>JAMB 2023 Physics - Question 13</strong></p><p>The surface temperature of a swimming pool on a warm day is 25&ordm;C and the temperature at the bottom is 15&ordm;C. If the swimming pool has a surface area of 620 <span contenteditable="false" class="math-editor-rendered" data-latex="m^2"></span> and a depth of 1.5m. Find the rate at which energy is transferred by conduction from the surface to the bottom of the swimming pool.<br>\n[Thermal conductivity of water (k) = 0.6071 Wm-1K-1]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.5kw', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.5kw' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '250kw', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '250kw' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '300kw', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '300kw' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.0kw', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.0kw' AND deleted = 0);

-- JAMB 2023 Physics - Item 14 - Question 14
SET @source_marker := 'JAMB 2023 Physics - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 14 - Question 14</small></p><p><strong>JAMB 2023 Physics - Question 14</strong></p><p>Which process is responsible for production of energy in stars?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nuclear reaction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nuclear reaction' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nuclear fission', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nuclear fission' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nuclear fusion', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nuclear fusion' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Radioactive decay', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Radioactive decay' AND deleted = 0);

-- JAMB 2023 Physics - Item 15 - Question 15
SET @source_marker := 'JAMB 2023 Physics - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 15 - Question 15</small></p><p><strong>JAMB 2023 Physics - Question 15</strong></p><p>How much net work is required to accelerate a 1200 kg car from 10<span contenteditable="false" class="math-editor-rendered" data-latex="ms^{-1}"></span> to 15<span contenteditable="false" class="math-editor-rendered" data-latex="ms^{-1}"></span></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.95×<span contenteditable="false" class="math-editor-rendered" data-latex="10^5 j"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.95×<span contenteditable="false" class="math-editor-rendered" data-latex="10^5 j"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.35×<span contenteditable="false" class="math-editor-rendered" data-latex="10^4 j"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.35×<span contenteditable="false" class="math-editor-rendered" data-latex="10^4 j"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.5×<span contenteditable="false" class="math-editor-rendered" data-latex="10^4 j"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.5×<span contenteditable="false" class="math-editor-rendered" data-latex="10^4 j"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6.0×<span contenteditable="false" class="math-editor-rendered" data-latex="10^4 j"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6.0×<span contenteditable="false" class="math-editor-rendered" data-latex="10^4 j"></span>' AND deleted = 0);

-- JAMB 2023 Physics - Item 16 - Question 16
SET @source_marker := 'JAMB 2023 Physics - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 16 - Question 16</small></p><p><strong>JAMB 2023 Physics - Question 16</strong></p><p>A wire of radius 0.2 mm is extended by 0.5% of its length when supported by a load of 1.5 kg. Determine the Young&#39;s modulus for the material of the wire.<br>\n[Take g = 10 ms<span contenteditable="false" class="math-editor-rendered" data-latex="^{-2}"></span>]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="2.4×10^{10}(Nm^{-2})"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="2.4×10^{10}(Nm^{-2})"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="1.5×10^{10}(Nm^{-2})"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="1.5×10^{10}(Nm^{-2})"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="2.4×10^9(Nm^{-2})"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="2.4×10^9(Nm^{-2})"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="1.3×10^{10}(Nm^{-2})"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="1.3×10^{10}(Nm^{-2})"></span>' AND deleted = 0);

-- JAMB 2023 Physics - Item 18 - Question 18
SET @source_marker := 'JAMB 2023 Physics - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 18 - Question 18</small></p><p><strong>JAMB 2023 Physics - Question 18</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q18_diagram.jpg" alt="Diagram for JAMB 2023 Physics Question 18" style="max-width:100%;height:auto;"></p><p>A 200 kg load is raised using a 110 m long lever as shown in the diagram above. The load is 10m from the pivot P. If the efficiency of the the lever is 80%, find the effort E required to lift the load.<br>\n<br>\n[Take g = 10ms-2]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '250', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '250' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '300', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '300' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '450', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '450' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '200', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '200' AND deleted = 0);

-- JAMB 2023 Physics - Item 19 - Question 19
SET @source_marker := 'JAMB 2023 Physics - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 19 - Question 19</small></p><p><strong>JAMB 2023 Physics - Question 19</strong></p><p>An air bubble of radius 4.5 cm initially at a depth of 12 m below the water surface rises to the surface. If the atmospheric pressure is equal to 10.34 m of water, the radius of the bubble just before it reaches the water surface is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6.43 cm', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6.43 cm' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.24 cm', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.24 cm' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.26 cm', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.26 cm' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5.82 cm', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5.82 cm' AND deleted = 0);

-- JAMB 2023 Physics - Item 20 - Question 20
SET @source_marker := 'JAMB 2023 Physics - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 20 - Question 20</small></p><p><strong>JAMB 2023 Physics - Question 20</strong></p><p>A parallel plate capacitor separated by an air gap is made of <span contenteditable="false" class="math-editor-rendered" data-latex="0.8m^2"></span>&nbsp;tin plates and 20 mm apart. It is connected to 120 V battery. What is the charge on each plate?<br>\n<br>\nTake <span contenteditable="false" class="math-editor-rendered" data-latex="&amp;epsilon;_o"></span> = <span contenteditable="false" class="math-editor-rendered" data-latex="8.85&amp;times;10^-12 Fm^-1"></span></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.54nC', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.54nC' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '42.5nC', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '42.5nC' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '35.4nC', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '35.4nC' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.25nC', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.25nC' AND deleted = 0);

-- JAMB 2023 Physics - Item 21 - Question 21
SET @source_marker := 'JAMB 2023 Physics - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 21 - Question 21</small></p><p><strong>JAMB 2023 Physics - Question 21</strong></p><p>What is the amount of heat required to raise the temperature of a 0.02 kg of ice cube from <span contenteditable="false" class="math-editor-rendered" data-latex="-10^oC"></span> to <span contenteditable="false" class="math-editor-rendered" data-latex="10^oC"></span> ?<br>\n<br>\n[specific latent heat of fusion of ice = 3.34 x <span contenteditable="false" class="math-editor-rendered" data-latex="10^5"></span>&nbsp; <span contenteditable="false" class="math-editor-rendered" data-latex="Jkg^-1"></span>, Specific heat capacity of water = 4200 <span contenteditable="false" class="math-editor-rendered" data-latex="Jkg^-1"></span> <span contenteditable="false" class="math-editor-rendered" data-latex="k^-1"></span>&nbsp;&nbsp;</p>\n\n<p>Specific heat capacity of ice = 2100 <span contenteditable="false" class="math-editor-rendered" data-latex="Jkg^-1"></span> <span contenteditable="false" class="math-editor-rendered" data-latex="k^-1"></span></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6680 J', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6680 J' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1680 J', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1680 J' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7520 J', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7520 J' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7940 J', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7940 J' AND deleted = 0);

-- JAMB 2023 Physics - Item 22 - Question 22
SET @source_marker := 'JAMB 2023 Physics - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 22 - Question 22</small></p><p><strong>JAMB 2023 Physics - Question 22</strong></p><p>Which of the following thermometers measures temperature from the thermal radiation emitted by objects?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Pyrometer thermometer', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Pyrometer thermometer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Platinum resistance thermometer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Platinum resistance thermometer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Thermocouple thermometer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Thermocouple thermometer' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Constant pressure gas thermometer', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Constant pressure gas thermometer' AND deleted = 0);

-- JAMB 2023 Physics - Item 23 - Question 23
SET @source_marker := 'JAMB 2023 Physics - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 23 - Question 23</small></p><p><strong>JAMB 2023 Physics - Question 23</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q23_diagram.png" alt="Diagram for JAMB 2023 Physics Question 23" style="max-width:100%;height:auto;"></p><p>A 400 N box is being pushed across a level floor at a constant speed by a force P of 100 N at an angle of 30.0&deg; to the horizontal, as shown in the the diagram below. What is the coefficient of kinetic friction between the box and the floor?<br>\n&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.19', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.19' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.24', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.24' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.40', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.40' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.22', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.22' AND deleted = 0);

-- JAMB 2023 Physics - Item 24 - Question 24
SET @source_marker := 'JAMB 2023 Physics - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 24 - Question 24</small></p><p><strong>JAMB 2023 Physics - Question 24</strong></p><p>Light of wavelength 589 nm in vacuum passes through a piece of fused quartz of index of refraction n = 1.458. What is the frequency of the light in fused quartz?<br>\n<br>\n[Speed of light c = <span contenteditable="false" class="math-editor-rendered" data-latex="3.00&amp;times;10^8 ms^{-1}"></span>]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="5.09×10^{15}"></span>Hz', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="5.09×10^{15}"></span>Hz' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="5.09×10^{14}"></span> Hz', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="5.09×10^{14}"></span> Hz' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="1.77×10^{15}"></span> Hz', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="1.77×10^{15}"></span> Hz' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="1.77×10^{14}"></span> Hz', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="1.77×10^{14}"></span> Hz' AND deleted = 0);

-- JAMB 2023 Physics - Item 25 - Question 25
SET @source_marker := 'JAMB 2023 Physics - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 25 - Question 25</small></p><p><strong>JAMB 2023 Physics - Question 25</strong></p><p>A simple pendulum, has a period of 5.77 seconds. When the pendulum is shortened by 3 m, the period is 4.60 seconds. Calculate the new length of the pendulum</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5.23 m', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5.23 m' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6.42 m', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6.42 m' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.87 m', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.87 m' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.26 m', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.26 m' AND deleted = 0);

-- JAMB 2023 Physics - Item 26 - Question 26
SET @source_marker := 'JAMB 2023 Physics - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 26 - Question 26</small></p><p><strong>JAMB 2023 Physics - Question 26</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q26_diagram.png" alt="Diagram for JAMB 2023 Physics Question 26" style="max-width:100%;height:auto;"></p><p>Three forces with magnitudes 16 N, 12 N and 21 N are shown in the diagram below. Determine the magnitude of their resultant force and angle with the x-axis</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.63N,61°', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.63N,61°' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.71N,61°', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.71N,61°' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.63N,29°', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.63N,29°' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.71N,29°', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.71N,29°' AND deleted = 0);

-- JAMB 2023 Physics - Item 27 - Question 27
SET @source_marker := 'JAMB 2023 Physics - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 27 - Question 27</small></p><p><strong>JAMB 2023 Physics - Question 27</strong></p><p>A travelling wave of amplitude 0.80 m has a frequency of 16 Hz and a wave speed of 20 <span contenteditable="false" class="math-editor-rendered" data-latex="ms-1"></span></p>\n\n<p>Calculate the wave number of the wave.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '5', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '5' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2' AND deleted = 0);

-- JAMB 2023 Physics - Item 28 - Question 28
SET @source_marker := 'JAMB 2023 Physics - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 28 - Question 28</small></p><p><strong>JAMB 2023 Physics - Question 28</strong></p><p>The near point of a patient&#39;s eye is 50.0 cm. What power (in diopters) must a corrective lens have to enable the eye to see clearly an object 25.0 cm away?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2 diopters', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2 diopters' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.5 diopters', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.5 diopters' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.5 diopters', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.5 diopters' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3 diopters', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3 diopters' AND deleted = 0);

-- JAMB 2023 Physics - Item 29 - Question 29
SET @source_marker := 'JAMB 2023 Physics - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 29 - Question 29</small></p><p><strong>JAMB 2023 Physics - Question 29</strong></p><p>Which of the following is/are <strong>not</strong> true about the heat capacity of a substance?<br>\n(i) It is an intensive property<br>\n(ii) Its S.I unit is <span contenteditable="false" class="math-editor-rendered" data-latex="jK-1"></span><br>\n(iii) It is an extensive property<br>\n(iv) Its S.I unit is <span contenteditable="false" class="math-editor-rendered" data-latex="jkg-1"></span></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i) and (iii) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i) and (iii) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i), (ii) and (iv) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i), (ii) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(i) and (iv) only', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(i) and (iv) only' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '(ii) and (iii) only', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '(ii) and (iii) only' AND deleted = 0);

-- JAMB 2023 Physics - Item 30 - Question 30
SET @source_marker := 'JAMB 2023 Physics - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 30 - Question 30</small></p><p><strong>JAMB 2023 Physics - Question 30</strong></p><p>The pinhole camera works on</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the principle of the reversibility of light', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the principle of the reversibility of light' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the principle of the rectilinear propagation of light', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the principle of the rectilinear propagation of light' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Huygen’s principle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Huygen’s principle' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the principle of total internal reflection of light', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the principle of total internal reflection of light' AND deleted = 0);

-- JAMB 2023 Physics - Item 31 - Question 31
SET @source_marker := 'JAMB 2023 Physics - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 31 - Question 31</small></p><p><strong>JAMB 2023 Physics - Question 31</strong></p><p>A step-down transformer is used on a 2.2 kV line to deliver 110 V. How many turns are on the primary windings if the secondary has 25 turns?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '20', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '20' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '250', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '250' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '200', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '200' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '500', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '500' AND deleted = 0);

-- JAMB 2023 Physics - Item 32 - Question 32
SET @source_marker := 'JAMB 2023 Physics - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 32 - Question 32</small></p><p><strong>JAMB 2023 Physics - Question 32</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q32_diagram.png" alt="Diagram for JAMB 2023 Physics Question 32" style="max-width:100%;height:auto;"></p><p>A block of mass 0.5 kg is suspended at the 40 cm mark of a light metre rule AB that is pivoted at point E, the 90 cm mark, and is kept at equilibrium by a string attached at point D, the 60 cm mark, as shown in the figure above. Find the tension T in the string.<br>\n<br>\n[Take g = <span contenteditable="false" class="math-editor-rendered" data-latex="10 ms-2"></span> ]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '16.67N', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '16.67N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '15.67N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '15.67N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '14.67N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '14.67N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '18.67N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '18.67N' AND deleted = 0);

-- JAMB 2023 Physics - Item 33 - Question 33
SET @source_marker := 'JAMB 2023 Physics - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 33 - Question 33</small></p><p><strong>JAMB 2023 Physics - Question 33</strong></p><p>A 35 k&Omega; is connected in series with a resistance of 40 k&Omega;. What resistance R must be connected in parallel with the combination so that the equivalent resistance is equal to 25 k&Omega;?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '40 kΩ', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '40 kΩ' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '37.5 kΩ', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '37.5 kΩ' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '45.5 kΩ', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '45.5 kΩ' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '30 kΩ', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '30 kΩ' AND deleted = 0);

-- JAMB 2023 Physics - Item 34 - Question 34
SET @source_marker := 'JAMB 2023 Physics - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 34 - Question 34</small></p><p><strong>JAMB 2023 Physics - Question 34</strong></p><p>A piano wire 50 cm long has a total mass of 10 g and its stretched with a tension of 800 N. Find the frequency of the wire when it sounds its third overtone note.</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '800 Hz', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '800 Hz' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '600 Hz', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '600 Hz' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '400 Hz', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '400 Hz' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '200 Hz', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '200 Hz' AND deleted = 0);

-- JAMB 2023 Physics - Item 35 - Question 35
SET @source_marker := 'JAMB 2023 Physics - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 35 - Question 35</small></p><p><strong>JAMB 2023 Physics - Question 35</strong></p><p>An object is placed 35 cm away from a convex mirror with a focal length of magnitude 15 cm. What is the location of the image?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '26.25 cm behind the mirror', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '26.25 cm behind the mirror' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10.5 cm behind the mirror', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10.5 cm behind the mirror' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '26.25 cm in front of the mirror', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '26.25 cm in front of the mirror' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '10.5 cm in front of the mirror', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '10.5 cm in front of the mirror' AND deleted = 0);

-- JAMB 2023 Physics - Item 36 - Question 36
SET @source_marker := 'JAMB 2023 Physics - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 36 - Question 36</small></p><p><strong>JAMB 2023 Physics - Question 36</strong></p><p>A relative density bottle has a mass of 19 g when empty. When it is completely filled with water, its mass is 66 g. What will be its mass if completely filled with alcohol of relative density 0.8?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '47 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '47 g' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '52.8 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '52.8 g' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '37.6 g', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '37.6 g' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '56.6 g', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '56.6 g' AND deleted = 0);

-- JAMB 2023 Physics - Item 37 - Question 37
SET @source_marker := 'JAMB 2023 Physics - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 37 - Question 37</small></p><p><strong>JAMB 2023 Physics - Question 37</strong></p><p>How much work is done against the gravitational force on a 3.0 kg object when it is carried from the ground floor to the roof of a building, a vertical climb of 240 m?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '7.2 kJ', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '7.2 kJ' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.6 kJ', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.6 kJ' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '6.8 kJ', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '6.8 kJ' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '8.4 kJ', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '8.4 kJ' AND deleted = 0);

-- JAMB 2023 Physics - Item 38 - Question 38
SET @source_marker := 'JAMB 2023 Physics - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 38 - Question 38</small></p><p><strong>JAMB 2023 Physics - Question 38</strong></p><p>A beam of light travelling in water is incident on a glass which is immersed in the water. The incident beam makes an angle of <span contenteditable="false" class="math-editor-rendered" data-latex="40^o"></span> with the normal. Calculate the angle of refraction in the glass.<br>\n<br>\n[Refractive index of water = 1.33, Refractive index of glass = 1.5]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="29.36^o"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="29.36^o"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="25.37^o"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="25.37^o"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="37.21^o"></span>', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="37.21^o"></span>' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '<span contenteditable="false" class="math-editor-rendered" data-latex="34.75^o"></span>', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '<span contenteditable="false" class="math-editor-rendered" data-latex="34.75^o"></span>' AND deleted = 0);

-- JAMB 2023 Physics - Item 39 - Question 39
SET @source_marker := 'JAMB 2023 Physics - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 39 - Question 39</small></p><p><strong>JAMB 2023 Physics - Question 39</strong></p><p>An open-tube mercury manometer is used to measure the pressure in a gas tank. When the atmospheric pressure is 101,325 <span contenteditable="false" class="math-editor-rendered" data-latex="P_a"></span>, what is the absolute pressure in <span contenteditable="false" class="math-editor-rendered" data-latex="P_a"></span> in the tank if the height of the mercury in the open tube is 25 cm higher. density of mercury = <span contenteditable="false" class="math-editor-rendered" data-latex="13600kg/m^3, g = 9.8m/s^2"></span></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '108,986 Pa', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '108,986 Pa' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '165,238 Pa', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '165,238 Pa' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '122,364 Pa', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '122,364 Pa' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '134,645 Pa', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '134,645 Pa' AND deleted = 0);

-- JAMB 2023 Physics - Item 40 - Question 40
SET @source_marker := 'JAMB 2023 Physics - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 40 - Question 40</small></p><p><strong>JAMB 2023 Physics - Question 40</strong></p><p>The sensitivity of a thermometer is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'All of the above', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'All of the above' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'how quickly a temperature change can be detected', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'how quickly a temperature change can be detected' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the difference between the maximum and the minimum temperature', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the difference between the maximum and the minimum temperature' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the smallest temperature change that can be detected or measured', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the smallest temperature change that can be detected or measured' AND deleted = 0);

-- JAMB 2023 Physics - Item 41 - Question 41
SET @source_marker := 'JAMB 2023 Physics - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 41 - Question 41</small></p><p><strong>JAMB 2023 Physics - Question 41</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q41_diagram.png" alt="Diagram for JAMB 2023 Physics Question 41" style="max-width:100%;height:auto;"></p><p>The diagram above illustrates the penetrating power of some types of radiation. X, Y and Z are likely</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'X = α-particle; Y = γ-ray; Z = β-particle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'X = α-particle; Y = γ-ray; Z = β-particle' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'X = α-particle; Y = β-particle; Z = γ-ray', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'X = α-particle; Y = β-particle; Z = γ-ray' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'X = γ-ray; Y = α-particle; Z = β-particle', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'X = γ-ray; Y = α-particle; Z = β-particle' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'X = β-particle; Y = γ-ray; Z = α-particle', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'X = β-particle; Y = γ-ray; Z = α-particle' AND deleted = 0);

-- JAMB 2023 Physics - Item 42 - Question 42
SET @source_marker := 'JAMB 2023 Physics - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 42 - Question 42</small></p><p><strong>JAMB 2023 Physics - Question 42</strong></p><p>An explosion occurs at an altitude of 312 m above the ground. If the air temperature is -10.00&deg;C, how long does it take the sound to reach the ground?<br>\n<br>\n[velocity of sound at <span contenteditable="false" class="math-editor-rendered" data-latex="0^oC"></span> = 331 ms-1]</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.94s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.94s' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.96s', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.96s' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.93s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.93s' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '0.95s', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '0.95s' AND deleted = 0);

-- JAMB 2023 Physics - Item 43 - Question 43
SET @source_marker := 'JAMB 2023 Physics - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 43 - Question 43</small></p><p><strong>JAMB 2023 Physics - Question 43</strong></p><p>A charge of <span contenteditable="false" class="math-editor-rendered" data-latex="4.6 &amp;times; 10^{-5}"></span>C is placed in an electric field of intensity <span contenteditable="false" class="math-editor-rendered" data-latex="3.2 &amp;times; 10^4"></span> <span contenteditable="false" class="math-editor-rendered" data-latex="Vm^{-1}"></span>. What is the force acting on the electron?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '1.5 N', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '1.5 N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '3.7 N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '3.7 N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '4.2 N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '4.2 N' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '2.5 N', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '2.5 N' AND deleted = 0);

-- JAMB 2023 Physics - Item 44 - Question 44
SET @source_marker := 'JAMB 2023 Physics - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 44 - Question 44</small></p><p><strong>JAMB 2023 Physics - Question 44</strong></p><p>The branch of physics that deals with the motion of objects and the forces acting on them is called:</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Electromagnetism', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Electromagnetism' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Thermodynamics', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Thermodynamics' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mechanics', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mechanics' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Quantum mechanics', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Quantum mechanics' AND deleted = 0);

-- JAMB 2023 Physics - Item 45 - Question 45
SET @source_marker := 'JAMB 2023 Physics - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 45 - Question 45</small></p><p><strong>JAMB 2023 Physics - Question 45</strong></p><p>The working of the beam balance is based on the principle of</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'moments', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'moments' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'conservation of energy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'conservation of energy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'equivalence', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'equivalence' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'floatation', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'floatation' AND deleted = 0);

-- JAMB 2023 Physics - Item 46 - Question 46
SET @source_marker := 'JAMB 2023 Physics - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 46 - Question 46</small></p><p><strong>JAMB 2023 Physics - Question 46</strong></p><p>Which of the following is a type of incandescent light source?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Fluorescent lamp', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Fluorescent lamp' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'LED lamp', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'LED lamp' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tungsten filament lamp', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tungsten filament lamp' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Neon lamp', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Neon lamp' AND deleted = 0);

-- JAMB 2023 Physics - Item 47 - Question 47
SET @source_marker := 'JAMB 2023 Physics - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 47 - Question 47</small></p><p><strong>JAMB 2023 Physics - Question 47</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q47_diagram.png" alt="Diagram for JAMB 2023 Physics Question 47" style="max-width:100%;height:auto;"></p><p>From the diagram above, if the potential differences across the resistor, capacitor, and inductor are 30V, 120V, and 60V, respectively, the effective potential difference is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '81', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '81' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '67', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '67' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '59', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '59' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, '73', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY '73' AND deleted = 0);

-- JAMB 2023 Physics - Item 48 - Question 48
SET @source_marker := 'JAMB 2023 Physics - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 48 - Question 48</small></p><p><strong>JAMB 2023 Physics - Question 48</strong></p><p>When light of a certain frequency is incident on a metal surface, no photoelectrons are emitted. If the frequency of the light is increased, what happens to the stopping potential?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The stopping potential does not change.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The stopping potential does not change.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The stopping potential decreases.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The stopping potential decreases.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The stopping potential can either increase or decrease, depending on the intensity of the light.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The stopping potential can either increase or decrease, depending on the intensity of the light.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The stopping potential increases.', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The stopping potential increases.' AND deleted = 0);

-- JAMB 2023 Physics - Item 49 - Question 49
SET @source_marker := 'JAMB 2023 Physics - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 49 - Question 49</small></p><p><strong>JAMB 2023 Physics - Question 49</strong></p><p>Which of the following is NOT a limitation of experimental measurements?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Systematic error', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Systematic error' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Instrument resolution', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Instrument resolution' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Random errors', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Random errors' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Human error', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Human error' AND deleted = 0);

-- JAMB 2023 Physics - Item 50 - Question 50
SET @source_marker := 'JAMB 2023 Physics - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 50 - Question 50</small></p><p><strong>JAMB 2023 Physics - Question 50</strong></p><p>Which of the following liquids has the highest surface tension?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Soapy water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Soapy water' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Water' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mercury', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mercury' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Oil', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Oil' AND deleted = 0);

-- JAMB 2023 Physics - Item 51 - Question 51
SET @source_marker := 'JAMB 2023 Physics - Item 51 - Question 51';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 51 - Question 51</small></p><p><strong>JAMB 2023 Physics - Question 51</strong></p><p>What is the name of the model of the atom that describes electrons as orbiting the nucleus in specific energy levels?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Bohr model', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Bohr model' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Dalton model', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Dalton model' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Rutherford model', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Rutherford model' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Thomson model', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Thomson model' AND deleted = 0);

-- JAMB 2023 Physics - Item 52 - Question 52
SET @source_marker := 'JAMB 2023 Physics - Item 52 - Question 52';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 52 - Question 52</small></p><p><strong>JAMB 2023 Physics - Question 52</strong></p><p>The electrolyte used in the Nickel-Iron (NiFe) accumulator is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dilute tetraoxosulphate(VI) acid', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dilute tetraoxosulphate(VI) acid' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'barium chloride solution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'barium chloride solution' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'potassium hydroxide solution', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'potassium hydroxide solution' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sodium hydroxide solution', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sodium hydroxide solution' AND deleted = 0);

-- JAMB 2023 Physics - Item 53 - Question 53
SET @source_marker := 'JAMB 2023 Physics - Item 53 - Question 53';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 53 - Question 53</small></p><p><strong>JAMB 2023 Physics - Question 53</strong></p><p>Which of the following materials is a good insulator?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Silver', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Silver' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Water' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Rubber', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Rubber' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Copper', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Copper' AND deleted = 0);

-- JAMB 2023 Physics - Item 54 - Question 54
SET @source_marker := 'JAMB 2023 Physics - Item 54 - Question 54';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 54 - Question 54</small></p><p><strong>JAMB 2023 Physics - Question 54</strong></p><p>A generator manufacturing company accidentally made an AC generator instead of a DC generator. To fix this error,</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the magnetic field needs to be made stronger', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the magnetic field needs to be made stronger' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the split rings should be replaced with slip rings', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the split rings should be replaced with slip rings' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the number of turns of the armature coil needs to be decreased', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the number of turns of the armature coil needs to be decreased' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the slip rings should be replaced with split rings', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the slip rings should be replaced with split rings' AND deleted = 0);

-- JAMB 2023 Physics - Item 55 - Question 55
SET @source_marker := 'JAMB 2023 Physics - Item 55 - Question 55';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 55 - Question 55</small></p><p><strong>JAMB 2023 Physics - Question 55</strong></p><p>Which of the following is NOT an example of elementary modern physics?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Classical mechanics', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Classical mechanics' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Quantum mechanics', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Quantum mechanics' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Special relativity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Special relativity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nuclear physics', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nuclear physics' AND deleted = 0);

-- JAMB 2023 Physics - Item 56 - Question 56
SET @source_marker := 'JAMB 2023 Physics - Item 56 - Question 56';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 56 - Question 56</small></p><p><strong>JAMB 2023 Physics - Question 56</strong></p><p>Which of the following is an example of a couple?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'All of the above.', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'All of the above.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The forces that are applied to the handle of a screwdriver when you twist it.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The forces that are applied to the handle of a screwdriver when you twist it.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The forces that are applied to a cross wench to loosen or tighten the lug nuts on a wheel of a car.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The forces that are applied to a cross wench to loosen or tighten the lug nuts on a wheel of a car.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The forces that are applied to the steering wheel of a car when you turn it.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The forces that are applied to the steering wheel of a car when you turn it.' AND deleted = 0);

-- JAMB 2023 Physics - Item 57 - Question 57
SET @source_marker := 'JAMB 2023 Physics - Item 57 - Question 57';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 57 - Question 57</small></p><p><strong>JAMB 2023 Physics - Question 57</strong></p><p>A positively charged particle is placed near a negatively charged particle. What is the direction of the electric force between the two particles?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The electric force is directed from the negative particle to the positive particle.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The electric force is directed from the negative particle to the positive particle.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The electric force is zero.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The electric force is zero.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The direction of the electric force cannot be determined.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The direction of the electric force cannot be determined.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The electric force is directed from the positive particle to the negative particle.', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The electric force is directed from the positive particle to the negative particle.' AND deleted = 0);

-- JAMB 2023 Physics - Item 58 - Question 58
SET @source_marker := 'JAMB 2023 Physics - Item 58 - Question 58';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 58 - Question 58</small></p><p><strong>JAMB 2023 Physics - Question 58</strong></p><p>When a water droplet is placed on a freshly cut piece of wood, it spreads out to form a thin layer because the wood is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'not at equilibrium with the water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'not at equilibrium with the water' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'cohesive to water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'cohesive to water' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'at equilibrium with the water', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'at equilibrium with the water' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'adhesive to water', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'adhesive to water' AND deleted = 0);

-- JAMB 2023 Physics - Item 59 - Question 59
SET @source_marker := 'JAMB 2023 Physics - Item 59 - Question 59';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 59 - Question 59</small></p><p><strong>JAMB 2023 Physics - Question 59</strong></p><p>Which of the following statements is correct about the angle of dip at various points on Earth?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The angle of dip is zero at the equator and 90 degrees at the magnetic poles.', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The angle of dip is zero at the equator and 90 degrees at the magnetic poles.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The angle of dip is greater at higher altitudes than at lower altitudes', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The angle of dip is greater at higher altitudes than at lower altitudes' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The angle of dip is positive in the northern hemisphere and negative in the southern hemisphere.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The angle of dip is positive in the northern hemisphere and negative in the southern hemisphere.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The angle of dip is constant at all points on Earth', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The angle of dip is constant at all points on Earth' AND deleted = 0);

-- JAMB 2023 Physics - Item 60 - Question 60
SET @source_marker := 'JAMB 2023 Physics - Item 60 - Question 60';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 60 - Question 60</small></p><p><strong>JAMB 2023 Physics - Question 60</strong></p><p><img src="../uploads/question_bank/jamb_2023_physics/Q60_diagram.png" alt="Diagram for JAMB 2023 Physics Question 60" style="max-width:100%;height:auto;"></p><p>In the diagram above, if the south poles of two magnets stroke a steel bar, the polarities at X and Y will respectively be</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'south and north', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'south and north' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'north and south', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'north and south' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'north and north', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'north and north' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'south and south', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'south and south' AND deleted = 0);

-- JAMB 2023 Physics - Item 61 - Question 61
SET @source_marker := 'JAMB 2023 Physics - Item 61 - Question 61';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 61 - Question 61</small></p><p><strong>JAMB 2023 Physics - Question 61</strong></p><p>Which of the following types of electromagnetic waves is used in night vision goggles?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Microwaves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Microwaves' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ultraviolet waves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ultraviolet waves' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Infrared waves', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Infrared waves' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Radio waves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Radio waves' AND deleted = 0);

-- JAMB 2023 Physics - Item 62 - Question 62
SET @source_marker := 'JAMB 2023 Physics - Item 62 - Question 62';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 62 - Question 62</small></p><p><strong>JAMB 2023 Physics - Question 62</strong></p><p>Which of the following is a type of wave that is both mechanical and longitudinal?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Water waves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Water waves' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Seismic waves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Seismic waves' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Sound waves', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Sound waves' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Light waves', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Light waves' AND deleted = 0);

-- JAMB 2023 Physics - Item 63 - Question 63
SET @source_marker := 'JAMB 2023 Physics - Item 63 - Question 63';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 63 - Question 63</small></p><p><strong>JAMB 2023 Physics - Question 63</strong></p><p>In an AC circuit, resonance occurs when the impedance of the circuit is:</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Zero', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Zero' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Maximum', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Maximum' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Equal to the capacitive reactance of the circuit', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Equal to the capacitive reactance of the circuit' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Minimum', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Minimum' AND deleted = 0);

-- JAMB 2023 Physics - Item 64 - Question 64
SET @source_marker := 'JAMB 2023 Physics - Item 64 - Question 64';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 64 - Question 64</small></p><p><strong>JAMB 2023 Physics - Question 64</strong></p><p>The pitch of a musical note is determined by the frequency of the sound wave that it produces. If two instruments have the same frequency, which of the following factors will <strong>most</strong> affect the difference in their pitches?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The shape of the instrument', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The shape of the instrument' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The tension of the string', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The tension of the string' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The size of the instrument', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The size of the instrument' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The material of the instrument', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The material of the instrument' AND deleted = 0);

-- JAMB 2023 Physics - Item 65 - Question 65
SET @source_marker := 'JAMB 2023 Physics - Item 65 - Question 65';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2023 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2023 Physics - Item 65 - Question 65</small></p><p><strong>JAMB 2023 Physics - Question 65</strong></p><p>A metal sphere is placed on an insulating stand. A negatively charged rod is brought close to it. If the sphere is earthed and the rod is taken away, what will be the charge on the sphere?</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2023, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The sphere will remain neutral.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The sphere will remain neutral.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The sphere will have a net negative charge.', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The sphere will have a net negative charge.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The sphere will have a net positive charge.', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The sphere will have a net positive charge.' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'The sphere will become polarized', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'The sphere will become polarized' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS jamb_2023_physics_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2023
  AND question LIKE '%JAMB 2023 Physics - Item%';
