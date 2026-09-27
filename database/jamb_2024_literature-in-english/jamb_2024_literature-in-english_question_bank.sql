-- JAMB 2024 Literature in English objective questions for the global question bank.
-- Collected from myschool.ng classroom (see companion manifest:
--   database/jamb_2024_literature-in-english/jamb_2024_literature-in-english_import_manifest.json for exact per-item source URLs).
-- Expected payload: 32 questions and 128 options.
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
SET @subject_id := (SELECT id FROM subjects WHERE subject = 'Literature in English' ORDER BY id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_jamb_2024_literature-in-english_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_jamb_2024_literature-in-english_refs()
BEGIN
    IF @exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'JAMB exam body could not be resolved.';
    END IF;
    IF @subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Literature in English subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_jamb_2024_literature-in-english_refs();
DROP PROCEDURE ss360_require_jamb_2024_literature-in-english_refs;

START TRANSACTION;

-- JAMB 2024 Literature in English - Item 1 - Question 1
SET @source_marker := 'JAMB 2024 Literature in English - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 1 - Question 1</small></p><p><strong>JAMB 2024 Literature in English - Question 1</strong></p><p><strong>This question is based on Literary Appreciation.</strong></p>\n\n<p>Football is the only sport on earth that can be considered truly global. Simple and inexpensive. it is equally likely to be found in a tight Marseille banlieue, an obscure corner of a Lagos slum, and the heart of a Buenos barrio. Marley&#39;s music is similarly universal...</p>\n\n<p>According to the excerpt above, football is&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'played only in Lagos slums', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'played only in Lagos slums' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'footballers like Marley''s music', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'footballers like Marley''s music' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'popular but cheap', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'popular but cheap' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'a universal game', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'a universal game' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 2 - Question 2
SET @source_marker := 'JAMB 2024 Literature in English - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 2 - Question 2</small></p><p><strong>JAMB 2024 Literature in English - Question 2</strong></p><p><strong>This question is based on Literary Appreciation.</strong></p>\n\n<p>&quot;The commission has the power to investigate,&nbsp;<br>\nto conciliate to hold hearings, to order<br>\nreinstatement of a discharged employee, and<br>\nto direct the appointment of a qualified applicant&quot;</p>\n\n<p>The rhetorical device used in the excerpt above is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Irony', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Irony' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Personification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Personification' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hyperbole', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hyperbole' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Parallelism', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Parallelism' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 3 - Question 3
SET @source_marker := 'JAMB 2024 Literature in English - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 3 - Question 3</small></p><p><strong>JAMB 2024 Literature in English - Question 3</strong></p><p><strong>This question is based on Literary Appreciation.</strong></p>\n\n<p>&quot;Lonely road,<br>\nNot a star<br>\nLonely road<br>\nShadows far<br>\nAnd quiet&quot;</p>\n\n<p>Peter Abraham&nbsp;<strong>Lonely Road.</strong></p>\n\n<p>The rhyme scheme in the excerpt above is&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'abcdec', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'abcdec' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ababc', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ababc' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'babac', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'babac' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'aabbc', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'aabbc' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 4 - Question 4
SET @source_marker := 'JAMB 2024 Literature in English - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 4 - Question 4</small></p><p><strong>JAMB 2024 Literature in English - Question 4</strong></p> From the novel; <strong>Unexpected Joy at Dawn</strong><p><strong>This question is based on Alex Agyei-Agyiri&#39;s&nbsp;<em>Unexpected Joy at Dawn.</em></strong></p>\n\n<p>The setting of the novel is&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nigeria and Ghana', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nigeria and Ghana' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nigeria and Togo', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nigeria and Togo' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Ghana and Niger', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Ghana and Niger' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nigeria and Benin', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nigeria and Benin' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 5 - Question 5
SET @source_marker := 'JAMB 2024 Literature in English - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 5 - Question 5</small></p><p><strong>JAMB 2024 Literature in English - Question 5</strong></p> From the novel; <strong>Unexpected Joy at Dawn</strong><p><strong>This question is based on Alex Agyei-Agyiri&#39;s&nbsp;<em>Unexpected Joy at Dawn.</em></strong></p>\n\n<p>Wachuk&nbsp;in the novel is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the cigarette seller', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the cigarette seller' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Niyi''s friend', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Niyi''s friend' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Idem''s husband', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Idem''s husband' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the alcohol seller', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the alcohol seller' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 6 - Question 6
SET @source_marker := 'JAMB 2024 Literature in English - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 6 - Question 6</small></p><p><strong>JAMB 2024 Literature in English - Question 6</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>In Senghor&#39;s&nbsp;<strong>Black Woman,&nbsp;</strong>the dominant literary device is&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'hyperbole', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'hyperbole' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'personification', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'personification' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'simile', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'simile' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metaphor', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metaphor' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 7 - Question 7
SET @source_marker := 'JAMB 2024 Literature in English - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 7 - Question 7</small></p><p><strong>JAMB 2024 Literature in English - Question 7</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>Sesay&#39;s &quot;The Song of the Woman of My Land&quot; is a&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'political poem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'political poem' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'geographical poem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'geographical poem' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'social poem', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'social poem' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'panegyric poem', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'panegyric poem' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 8 - Question 8
SET @source_marker := 'JAMB 2024 Literature in English - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 8 - Question 8</small></p><p><strong>JAMB 2024 Literature in English - Question 8</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>In Eliot&#39;s &quot;Journey of the Magi&quot;, &quot;six hands at an open door&quot; is an example of&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'synecdoche', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'synecdoche' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'irony', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'irony' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'alliteration', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'alliteration' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'metonymy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'metonymy' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 9 - Question 9
SET @source_marker := 'JAMB 2024 Literature in English - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 9 - Question 9</small></p><p><strong>JAMB 2024 Literature in English - Question 9</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>Osundare&#39;s &quot;The Leader and the Led&quot; is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dramatic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dramatic' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'satiric', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'satiric' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'narrative', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'narrative' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'elegaic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'elegaic' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 10 - Question 10
SET @source_marker := 'JAMB 2024 Literature in English - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 10 - Question 10</small></p><p><strong>JAMB 2024 Literature in English - Question 10</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>The poet persona in Donne&#39;s &quot;The Good Morrow&quot; reflects on&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'spiritual love', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'spiritual love' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the immortality of love', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the immortality of love' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'falling in love', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'falling in love' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'love marriage', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'love marriage' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 11 - Question 11
SET @source_marker := 'JAMB 2024 Literature in English - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 11 - Question 11</small></p><p><strong>JAMB 2024 Literature in English - Question 11</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>The style of Chibuike&#39;s &quot;A Government Driver on His Retirement&quot; is&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'narrative', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'narrative' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'monologic', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'monologic' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reflective', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reflective' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'panegyric', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'panegyric' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 12 - Question 12
SET @source_marker := 'JAMB 2024 Literature in English - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 12 - Question 12</small></p><p><strong>JAMB 2024 Literature in English - Question 12</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>&quot;But a caged bird stands on the grave of dreams&quot;</p>\n\n<p>The excerpt above from Angelou&#39;s &quot;Caged Bird&quot; implies that caged bird</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'will die', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'will die' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'will be frustrated', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'will be frustrated' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'stands on its grave', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'stands on its grave' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'walks freely to actualise its dream', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'walks freely to actualise its dream' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 13 - Question 13
SET @source_marker := 'JAMB 2024 Literature in English - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 13 - Question 13</small></p><p><strong>JAMB 2024 Literature in English - Question 13</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>Lawrence&#39;s &quot;Bats&quot; is a&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sarcasm', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sarcasm' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'satire', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'satire' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dramatic dialogue', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dramatic dialogue' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'dramatic monolgue', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'dramatic monolgue' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 14 - Question 14
SET @source_marker := 'JAMB 2024 Literature in English - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 14 - Question 14</small></p><p><strong>JAMB 2024 Literature in English - Question 14</strong></p> From the novel; <strong>The Lion and the Jewel</strong><p><strong>This question is based on Wole Soyinka&#39;s&nbsp;<em>The Lion and the Jewel</em></strong></p>\n\n<p>Lakunle declines to pay bride price on Sidi because he sees tradition as&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'unholy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'unholy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'illegal', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'illegal' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'babaric', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'babaric' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'childish', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'childish' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 15 - Question 15
SET @source_marker := 'JAMB 2024 Literature in English - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 15 - Question 15</small></p><p><strong>JAMB 2024 Literature in English - Question 15</strong></p> From the novel; <strong>The Lion and the Jewel</strong><p><strong>The question is based on Wole Soyinka&#39;s&nbsp;<em>The Lion and the Jewel</em></strong></p>\n\n<p>The play is a</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Comedy', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Comedy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Tragi-comedy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Tragi-comedy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Farce', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Farce' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Melodrama', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Melodrama' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 16 - Question 16
SET @source_marker := 'JAMB 2024 Literature in English - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 16 - Question 16</small></p><p><strong>JAMB 2024 Literature in English - Question 16</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osborne&#39;s&nbsp;<em>Look Back in Anger</em></strong></p>\n\n<p>Alison and Jimmy are accommodated&nbsp;during the first month of their marriage by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hugh Tanner', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hugh Tanner' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nigel', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nigel' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cliff', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cliff' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Webster', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Webster' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 17 - Question 17
SET @source_marker := 'JAMB 2024 Literature in English - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 17 - Question 17</small></p><p><strong>JAMB 2024 Literature in English - Question 17</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osbourne&#39;s&nbsp;<em>Look Back in Anger</em></strong></p>\n\n<p>The protagonist in the play is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Alison Porter', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Alison Porter' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cliff Lewis', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cliff Lewis' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Jimmy Porter', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Jimmy Porter' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Colonel Redfern', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Colonel Redfern' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 18 - Question 18
SET @source_marker := 'JAMB 2024 Literature in English - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 18 - Question 18</small></p><p><strong>JAMB 2024 Literature in English - Question 18</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osbourne&#39;s&nbsp;<em>Look Back in Anger</em></strong></p>\n\n<p>The couple&#39;s marital crisis is aggravated by</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Jimmy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Jimmy' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Cliff', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Cliff' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Helena', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Helena' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hugh', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hugh' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 19 - Question 19
SET @source_marker := 'JAMB 2024 Literature in English - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 19 - Question 19</small></p><p><strong>JAMB 2024 Literature in English - Question 19</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osborne&#39;s&nbsp;<em>Look Back in Anger.</em></strong></p>\n\n<p>The reason why Jimmy easily gets along with Cliff is because</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'they both belong to the working class', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'they both belong to the working class' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Alison speaks well of Cliff', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Alison speaks well of Cliff' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'the relatives of Jimmy''s mother are rich', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'the relatives of Jimmy''s mother are rich' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'they are both from affluent backgrounds', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'they are both from affluent backgrounds' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 20 - Question 20
SET @source_marker := 'JAMB 2024 Literature in English - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 20 - Question 20</small></p><p><strong>JAMB 2024 Literature in English - Question 20</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osborne&#39;s&nbsp;<em>Look Back in Anger.</em></strong></p>\n\n<p>Jimmy&#39;s harmatia is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'infidelity', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'infidelity' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'anger', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'anger' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'pride', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'pride' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'jealousy', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'jealousy' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 21 - Question 21
SET @source_marker := 'JAMB 2024 Literature in English - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 21 - Question 21</small></p><p><strong>JAMB 2024 Literature in English - Question 21</strong></p> From the novel; <strong>Second Class Citizen</strong><p><strong>This question is based on Buchi Emecheta&#39;s&nbsp;<em>Second Class Citizen</em></strong></p>\n\n<p>Adah is so obsessed with the sleek woman at the hospital because the woman</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'has a doting husband', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'has a doting husband' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'has a high paying job', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'has a high paying job' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'gives birth to twins', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'gives birth to twins' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lives in a mansion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lives in a mansion' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 22 - Question 22
SET @source_marker := 'JAMB 2024 Literature in English - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 22 - Question 22</small></p><p><strong>JAMB 2024 Literature in English - Question 22</strong></p> From the novel; <strong>Second Class Citizen</strong><p><strong>This question is based on Buchi Emecheta&#39;s&nbsp;<em>Second Class Citizen.</em></strong></p>\n\n<p>Adah&#39;s&nbsp;disappointment is in the overwhelming&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'freedom for the blacks', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'freedom for the blacks' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'reception of the blacks', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'reception of the blacks' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'recognition given the blacks', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'recognition given the blacks' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'discrimination against the blacks', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'discrimination against the blacks' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 23 - Question 23
SET @source_marker := 'JAMB 2024 Literature in English - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 23 - Question 23</small></p><p><strong>JAMB 2024 Literature in English - Question 23</strong></p> From the novel; <strong>Second Class Citizen</strong><p><strong>This question is based on Buchi Emecheta&#39;s <em>Second Class Citizen</em></strong></p>\n\n<p>The main challenge Adah encounters in England is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'being a woman', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'being a woman' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'financial limitations', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'financial limitations' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'being half literate', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'being half literate' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'being a black person', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'being a black person' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 24 - Question 24
SET @source_marker := 'JAMB 2024 Literature in English - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 24 - Question 24</small></p><p><strong>JAMB 2024 Literature in English - Question 24</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>The question is based on Emily Bronte&#39;s&nbsp;<em>Wuthering Heights</em></strong></p>\n\n<p>The structure of the novel is based on two major conflicts of&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'love', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'love' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'passion', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'passion' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'emotion', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'emotion' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'romance', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'romance' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 25 - Question 25
SET @source_marker := 'JAMB 2024 Literature in English - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 25 - Question 25</small></p><p><strong>JAMB 2024 Literature in English - Question 25</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>This question is based on Emily Bronte&#39;s&nbsp;<em>Wuthering Heights</em></strong></p>\n\n<p>The setting of the novel is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mid 16th century', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mid 16th century' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mid 17th century', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mid 17th century' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mid 18th century', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mid 18th century' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Mid 19th century', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Mid 19th century' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 26 - Question 26
SET @source_marker := 'JAMB 2024 Literature in English - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 26 - Question 26</small></p><p><strong>JAMB 2024 Literature in English - Question 26</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>This question is based on Emily Bronte&#39;s&nbsp;<em>Wuthering Heights</em></strong></p>\n\n<p>The novel can be described as a&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Renaissance prose', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Renaissance prose' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Victorian novel', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Victorian novel' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'French fiction', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'French fiction' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'English autobiography', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'English autobiography' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 27 - Question 27
SET @source_marker := 'JAMB 2024 Literature in English - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 27 - Question 27</small></p><p><strong>JAMB 2024 Literature in English - Question 27</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>This question is based on Emily Bronte&#39;s&nbsp;<em>Wuthering Heights.</em></strong></p>\n\n<p>Heathcliff considered himself the second half of&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Nelly Dean', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Nelly Dean' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Isabella Linton', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Isabella Linton' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Hindley Earnshaw', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Hindley Earnshaw' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'Catherine Earnshaw', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'Catherine Earnshaw' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 28 - Question 28
SET @source_marker := 'JAMB 2024 Literature in English - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 28 - Question 28</small></p><p><strong>JAMB 2024 Literature in English - Question 28</strong></p><p><strong>This question is based on General Literary Principles.</strong></p>\n\n<p>The collection of images within a literary work is referred to as&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'imagery', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'imagery' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'images', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'images' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'symbolism', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'symbolism' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'caesura', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'caesura' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 29 - Question 29
SET @source_marker := 'JAMB 2024 Literature in English - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 29 - Question 29</small></p><p><strong>JAMB 2024 Literature in English - Question 29</strong></p><p><strong>This question is based on general literary principles</strong></p>\n\n<p>The leading character in a literary work is the&nbsp;<strong>&nbsp;</strong></p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'protagonist', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'protagonist' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'antagonist', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'antagonist' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'villain', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'villain' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'anti-hero', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'anti-hero' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 30 - Question 30
SET @source_marker := 'JAMB 2024 Literature in English - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 30 - Question 30</small></p><p><strong>JAMB 2024 Literature in English - Question 30</strong></p><p>A long narrative poem that relates heroic exploits is&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'panegyric', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'panegyric' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'lyric', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'lyric' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'ballad', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'ballad' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'epic', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'epic' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 31 - Question 31
SET @source_marker := 'JAMB 2024 Literature in English - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 31 - Question 31</small></p><p><strong>JAMB 2024 Literature in English - Question 31</strong></p><p><strong>This question is based on General Literary Principles.</strong></p>\n\n<p>A poem of eight rhyming lines is</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'quatrain', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'quatrain' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'octave', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'octave' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'sonnet', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'sonnet' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'limerick', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'limerick' AND deleted = 0);

-- JAMB 2024 Literature in English - Item 32 - Question 32
SET @source_marker := 'JAMB 2024 Literature in English - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @exam_body_id AND subject_id = @subject_id AND exam_year = 2024 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: JAMB 2024 Literature in English - Item 32 - Question 32</small></p><p><strong>JAMB 2024 Literature in English - Question 32</strong></p><p><strong>This question is based on General Literary Principles.</strong></p>\n\n<p>The events that make up the story is the&nbsp;</p>', @subject_id, 0, 'exam_body', @exam_body_id, 2024, 0, 'Medium', 'SSS3', '', '', '', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'plot', 1, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'plot' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'setting', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'setting' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'atmosphere', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'atmosphere' AND deleted = 0);

INSERT INTO question_bank_options (question_id, options, answer, deleted)
SELECT @question_id, 'theme', 0, 0
WHERE @question_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM question_bank_options WHERE question_id = @question_id AND BINARY options = BINARY 'theme' AND deleted = 0);

COMMIT;

SELECT
    COUNT(*) AS jamb_2024_literature-in-english_questions,
    SUM(review_status = 'approved') AS approved_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @exam_body_id
  AND subject_id = @subject_id
  AND exam_year = 2024
  AND question LIKE '%JAMB 2024 Literature in English - Item%';
