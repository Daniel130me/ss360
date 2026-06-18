-- WAEC 2025 Civic Education objective questions for the global question bank.
-- Generated from: q_bank/WAEC_2025_Civic_Education_Objective_Questions.md
-- Expected payload: 50 questions and 200 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS question_bank (
    id INT AUTO_INCREMENT PRIMARY KEY,
    question LONGTEXT NOT NULL,
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
SELECT 'WAEC', 'West African Examinations Council'
WHERE NOT EXISTS (SELECT 1 FROM exam_bodies WHERE name = 'WAEC');

SET @waec_exam_body_id := (SELECT id FROM exam_bodies WHERE name = 'WAEC' ORDER BY id ASC LIMIT 1);
SET @civic_subject_id := (SELECT id FROM subjects WHERE subject IN ('Civic Education', 'Civic') ORDER BY FIELD(subject, 'Civic Education', 'Civic'), id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_waec_2025_civic_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_waec_2025_civic_refs()
BEGIN
    IF @waec_exam_body_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'WAEC exam body could not be resolved.';
    END IF;
    IF @civic_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Civic Education subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_waec_2025_civic_refs();
DROP PROCEDURE ss360_require_waec_2025_civic_refs;

START TRANSACTION;

-- WAEC 2025 Civic Education - Item 1 - Question 1
SET @source_marker := 'WAEC 2025 Civic Education - Item 1 - Question 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 1 - Question 1</small></p><p><strong>WAEC 2025 Civic Education - Question 1</strong></p><p>Who among the following could be described as the founding father of Nigerian nationalism?</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Nationalism', 'Olayinka Herbert Samuel Macauley (14 November 1864 - 7 May 1946) was a Nigerian nationalist and musician and is
considered by many Nigerians as the founder/father of Nigerian nationalism.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Nnamdi Azikwe', 0, 0),
(@question_id, 'Herbert Macauley', 1, 0),
(@question_id, 'Obafemi Awolowo', 0, 0),
(@question_id, 'Ahmadu Bello', 0, 0);

-- WAEC 2025 Civic Education - Item 2 - Question 2
SET @source_marker := 'WAEC 2025 Civic Education - Item 2 - Question 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 2 - Question 2</small></p><p><strong>WAEC 2025 Civic Education - Question 2</strong></p><p>Rule of law means</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Rule of Law', 'Rule of law means supremacy of the law or constitution over and above everybody or citizens. It was propounded by A. V.
Dicey in 1885.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Absence of legal immunity', 0, 0),
(@question_id, 'Peace, order and stability', 0, 0),
(@question_id, 'Supremacy of the law', 1, 0),
(@question_id, 'Obedience to any authority', 0, 0);

-- WAEC 2025 Civic Education - Item 3 - Question 3
SET @source_marker := 'WAEC 2025 Civic Education - Item 3 - Question 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 3 - Question 3</small></p><p><strong>WAEC 2025 Civic Education - Question 3</strong></p><p>A major characteristic of civil society is</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civil Society', 'Social responsibility is an ethical framework and suggests that an entity, be it an organization or individual, has an
obligation to act for the benefit of society at large.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'political gerrymandering', 0, 0),
(@question_id, 'social responsibility', 1, 0),
(@question_id, 'corporate responsibility', 0, 0),
(@question_id, 'the desire to win election', 0, 0);

-- WAEC 2025 Civic Education - Item 4 - Question 4
SET @source_marker := 'WAEC 2025 Civic Education - Item 4 - Question 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 4 - Question 4</small></p><p><strong>WAEC 2025 Civic Education - Question 4</strong></p><p>Use the diagram above to answer this question
The marked pedestrian crossing shown in the diagram is</p><p><em>Diagram reference: image was marked present in the source file, but no image asset was supplied.</em></p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Road Safety', 'The marked pedestrian crossing showing is zebra crossing.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'zebra crossing', 1, 0),
(@question_id, 'amber crossing', 0, 0),
(@question_id, 'cobra crossing', 0, 0),
(@question_id, 'neon sign crossing', 0, 0);

-- WAEC 2025 Civic Education - Item 5 - Question 5
SET @source_marker := 'WAEC 2025 Civic Education - Item 5 - Question 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 5 - Question 5</small></p><p><strong>WAEC 2025 Civic Education - Question 5</strong></p><p>Use the diagram above to answer this question
In the above diagram, all vehicles stopped mainly because</p><p><em>Diagram reference: image was marked present in the source file, but no image asset was supplied.</em></p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Road Safety', 'Vehicle stopped mainly because the pedestrians have already stepped on the line as shown in the diagram', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'it is emergency crossing line', 0, 0),
(@question_id, 'the pedestrians have already stepped on the line', 1, 0),
(@question_id, 'the traffic wardens have instructed them to stop', 0, 0),
(@question_id, 'the traffic light has shown green', 0, 0);

-- WAEC 2025 Civic Education - Item 6 - Question 6
SET @source_marker := 'WAEC 2025 Civic Education - Item 6 - Question 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 6 - Question 6</small></p><p><strong>WAEC 2025 Civic Education - Question 6</strong></p><p>Citizenship status is acquired through</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Citizenship', 'Citizenship status can be acquired through several means, including birth, naturalization, honorary and registration.
Birth refers to being born within a country''s territory or to its citizens. Naturalization is the process by which a foreign
citizen becomes a citizen of another country. Honorary citizenship is granted by a country to a foreign individual in
recognition of their contributions or services. Registration can refer to the process of registering as a citizen, often
applicable to those who have a claim to citizenship through descent.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'birth, naturalization, honorary and registration', 1, 0),
(@question_id, 'association, convention, naturalization and incorporation', 0, 0),
(@question_id, 'registration, inter-relationship, integration and declaration', 0, 0),
(@question_id, 'birth, indigenization, colonization and referendum', 0, 0);

-- WAEC 2025 Civic Education - Item 7 - Question 7
SET @source_marker := 'WAEC 2025 Civic Education - Item 7 - Question 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 7 - Question 7</small></p><p><strong>WAEC 2025 Civic Education - Question 7</strong></p><p>Human Rights are basic natural rights which people enjoy primarily because they are</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Human Rights', 'Human rights are basic natural right which people enjoy primarily because they are human beings. Human rights are
rights exercised by human beings.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'members of a community', 0, 0),
(@question_id, 'human beings', 1, 0),
(@question_id, 'international citizens', 0, 0),
(@question_id, 'members of a political party', 0, 0);

-- WAEC 2025 Civic Education - Item 8 - Question 8
SET @source_marker := 'WAEC 2025 Civic Education - Item 8 - Question 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 8 - Question 8</small></p><p><strong>WAEC 2025 Civic Education - Question 8</strong></p><p>Interpersonal relationship exists when</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Interpersonal Relationships', 'Interpersonal relationship refers to a strong association among individuals working together in the same organization.
Individuals working together are likely to develop interpersonal relationships. One of the most important interpersonal
relationships is social interaction in a social setting.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'group share social interest and communal aspiration', 0, 0),
(@question_id, 'citizens are politically conscious and participate in voting', 0, 0),
(@question_id, 'citizens pay their taxes regularly to inland revenue service', 0, 0),
(@question_id, 'there is interaction between persons in a social setting', 1, 0);

-- WAEC 2025 Civic Education - Item 9 - Question 9
SET @source_marker := 'WAEC 2025 Civic Education - Item 9 - Question 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 9 - Question 9</small></p><p><strong>WAEC 2025 Civic Education - Question 9</strong></p><p>Cultism can be described to be</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Cultism', 'Cultism is a social vice that involves a group of people who share a common belief and are involved in secret practices.
These practices are often harmful and dangerous to both members of the cult and non-members. Therefore, cultism can be described as dangerous.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'dangerous', 1, 0),
(@question_id, 'amiable', 0, 0),
(@question_id, 'harmless', 0, 0),
(@question_id, 'attractive', 0, 0);

-- WAEC 2025 Civic Education - Item 10 - Question 10
SET @source_marker := 'WAEC 2025 Civic Education - Item 10 - Question 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 10 - Question 10</small></p><p><strong>WAEC 2025 Civic Education - Question 10</strong></p><p>Use the statements below to answer this question</p><p>NEWS: &#039;Rival cult Group Killed Ten on Campus&#039;
STUDENT: I will definitely need a bullet proof vest before I can go back to the Campus.</p><p>Based on the statement above, the decision of the student on having a bullet proof vest shows that cultism</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Cultism', 'The decision of the student on having a bullet proof vest shows that cultism spreads or creates fear and terror on the campus', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'is a training ground for armed forces.', 0, 0),
(@question_id, 'spreads fear and terror.', 1, 0),
(@question_id, 'propagates self-defence.', 0, 0),
(@question_id, 'breed courageous graduates.', 0, 0);

-- WAEC 2025 Civic Education - Item 11 - Question 11
SET @source_marker := 'WAEC 2025 Civic Education - Item 11 - Question 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 11 - Question 11</small></p><p><strong>WAEC 2025 Civic Education - Question 11</strong></p><p>Use the statements below to answer this question</p><p>NEWS: &#039;Rival cult Group Killed Ten on Campus&#039;
STUDENT: I will definitely need a bullet proof vest before I can go back to the Campus.</p><p>It could be inferred from the statements above that cultism in schools could lead to</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Cultism', 'The statement ''Rival cult Group Killed Ten on Campus'' implies that cultism in schools can lead to violence and death.
The student''s response further emphasizes the danger, as they feel they would need a bulletproof vest to return to
campus. Therefore, the inference that can be drawn from these statements is that cultism in schools could lead to
''untimely death'', which is option 4.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'untimely death.', 1, 0),
(@question_id, 'popularity on campus.', 0, 0),
(@question_id, 'uninterrupted academic calendar.', 0, 0),
(@question_id, 'sudden prosperity.', 0, 0);

-- WAEC 2025 Civic Education - Item 12 - Question 12
SET @source_marker := 'WAEC 2025 Civic Education - Item 12 - Question 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 12 - Question 12</small></p><p><strong>WAEC 2025 Civic Education - Question 12</strong></p><p>Victims of human trafficking are usually compelled to engage in</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Road Safety', 'Victims of human trafficking are usually compelled to engage in forced labour.
Human trafficking simply means the trade of humans for the purpose of forced labour, sexual slavery or commercial
sexual exploitation for the trafficker or others.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'visiting tourist sites.', 0, 0),
(@question_id, 'part-time studies.', 0, 0),
(@question_id, 'forced labour.', 1, 0),
(@question_id, 'lucrative employment.', 0, 0);

-- WAEC 2025 Civic Education - Item 13 - Question 13
SET @source_marker := 'WAEC 2025 Civic Education - Item 13 - Question 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 13 - Question 13</small></p><p><strong>WAEC 2025 Civic Education - Question 13</strong></p><p>One habit which People Living With HIV/AIDS (PLWHAs) must avoid to remain healthy and productive is</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'People living with HIV/AIDS must avoid to remain healthy and productive, they should avoid self pity or self-
medication.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'regular contact with healthy people', 0, 0),
(@question_id, 'pursuit of academic studies', 0, 0),
(@question_id, 'participation in profitable ventures', 0, 0),
(@question_id, 'self-pity and self-medication', 1, 0);

-- WAEC 2025 Civic Education - Item 14 - Question 14
SET @source_marker := 'WAEC 2025 Civic Education - Item 14 - Question 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 14 - Question 14</small></p><p><strong>WAEC 2025 Civic Education - Question 14</strong></p><p>The National Assembly Presidency and Court which are inter-related and interdependent in our democracy constitute the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'The National Assembly, Presidency, and Court are the three arms of government in a democratic system. The National
Assembly (Legislature) makes the laws, the Presidency (Executive) implements the laws, and the Court (Judiciary)
interprets the laws. They are inter-related and interdependent, each performing its functions to maintain checks and
balances in the system.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'tiers of government', 0, 0),
(@question_id, 'types of democracy', 0, 0),
(@question_id, 'arms of government', 1, 0),
(@question_id, 'forms of government', 0, 0);

-- WAEC 2025 Civic Education - Item 15 - Question 15
SET @source_marker := 'WAEC 2025 Civic Education - Item 15 - Question 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 15 - Question 15</small></p><p><strong>WAEC 2025 Civic Education - Question 15</strong></p><p>A system of government that listens to public opinion and tolerates opposition is</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'In democratic regime is a system of government that listens to the view or opinion of the people and tolerates
opposition in the country.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'socialist regime', 0, 0),
(@question_id, 'dictatorial regime', 0, 0),
(@question_id, 'capitalist regime', 0, 0),
(@question_id, 'democratic regime', 1, 0);

-- WAEC 2025 Civic Education - Item 16 - Question 16
SET @source_marker := 'WAEC 2025 Civic Education - Item 16 - Question 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 16 - Question 16</small></p><p><strong>WAEC 2025 Civic Education - Question 16</strong></p><p>A situation where most citizens fail to vote in elections coud be described as political</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Political Participation', 'Political apathy is a situation where most citizens do not show interest in politics or fails to vote during the elections.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'apathy.', 1, 0),
(@question_id, 'culture.', 0, 0),
(@question_id, 'legitimacy.', 0, 0),
(@question_id, 'socialization.', 0, 0);

-- WAEC 2025 Civic Education - Item 17 - Question 17
SET @source_marker := 'WAEC 2025 Civic Education - Item 17 - Question 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 17 - Question 17</small></p><p><strong>WAEC 2025 Civic Education - Question 17</strong></p><p>The division of Nigeria into various constituencies with each electing a person to represent it in the National Assemblyis a demonstration of</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'The division of Nigeria into various constituencies with each electing a person to represent it in the National assembly is
a demonstration of popular participation.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'popular participation.', 1, 0),
(@question_id, 'political rivalry among the constituents.', 0, 0),
(@question_id, 'checks and balances.', 0, 0),
(@question_id, 'drive towards succession in the country.', 0, 0);

-- WAEC 2025 Civic Education - Item 18 - Question 18
SET @source_marker := 'WAEC 2025 Civic Education - Item 18 - Question 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 18 - Question 18</small></p><p><strong>WAEC 2025 Civic Education - Question 18</strong></p><p>In Nigeria, public servants are expected to be</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Political Participation', 'In Nigeria, public servants are expected to be non-partisan. This means they should not show support for any political
party or be involved in political activities. This is to ensure that they serve all citizens equally without any bias or
favoritism. Being non-partisan is a key principle of public service, not just in Nigeria, but in many countries around the
world.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'non-partisan.', 1, 0),
(@question_id, 'political.', 0, 0),
(@question_id, 'apolitical.', 0, 0),
(@question_id, 'ambitious.', 0, 0);

-- WAEC 2025 Civic Education - Item 19 - Question 19
SET @source_marker := 'WAEC 2025 Civic Education - Item 19 - Question 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 19 - Question 19</small></p><p><strong>WAEC 2025 Civic Education - Question 19</strong></p><p>The principle that public servants cannot be held responsible for their official actions denotes</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'Anonymity is a principle that states that public servants can not be held responsible for their official actions.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'neutrality', 0, 0),
(@question_id, 'anonymity', 1, 0),
(@question_id, 'accountability', 0, 0),
(@question_id, 'impartiality', 0, 0);

-- WAEC 2025 Civic Education - Item 20 - Question 20
SET @source_marker := 'WAEC 2025 Civic Education - Item 20 - Question 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 20 - Question 20</small></p><p><strong>WAEC 2025 Civic Education - Question 20</strong></p><p>Universal Declaration of Human Rights (UDHR) is based on the resolution of the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Human Rights', 'Universal Declaration of Human Rights is based on the resolution of the United Nations Organisation (UNO).', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Human Rights Watch', 0, 0),
(@question_id, 'United Nations Organisation', 1, 0),
(@question_id, 'Amnesty International', 0, 0),
(@question_id, 'League of Nations', 0, 0);

-- WAEC 2025 Civic Education - Item 21 - Question 21
SET @source_marker := 'WAEC 2025 Civic Education - Item 21 - Question 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 21 - Question 21</small></p><p><strong>WAEC 2025 Civic Education - Question 21</strong></p><p>Use the story below to answer this questionImoh lived with her parents in Kakuri. They were good citizens who detested all forms of immoral acts. Both at homeand in school, Imoh had been taught the virtues and values of a good citizen. However, while in a bus on her way homefrom school, the conductor forgot to ask her fare. She knew that the right thing to do was to pay even when theconductor had forgotten to collect the fare. She also knew that there were other things she could do with the money ifit was not paid, but she did what was expected by informing the conductor and paying the fare.According to the story, Imoh&#039;s parents were</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'From the story, it is clear that Imoh''s parents have instilled in her the values of honesty and responsibility. They are
described as good citizens who detest all forms of immoral acts. This suggests that they are honest and responsible
individuals, not necessarily wealthy, prominent politicians, or religious fanatics.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'wealthy couple.', 0, 0),
(@question_id, 'religious fanatics.', 0, 0),
(@question_id, 'honest and responsible.', 1, 0),
(@question_id, 'prominent politicians.', 0, 0);

-- WAEC 2025 Civic Education - Item 22 - Question 22
SET @source_marker := 'WAEC 2025 Civic Education - Item 22 - Question 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 22 - Question 22</small></p><p><strong>WAEC 2025 Civic Education - Question 22</strong></p><p>Use the story below to answer this questionImoh lived with her parents in Kakuri. They were good citizens who detested all forms of immoral acts. Both at homeand in school, Imoh had been taught the virtues and values of a good citizen. However, while in a bus on her way homefrom school, the conductor forgot to ask her fare. She knew that the right thing to do was to pay even when theconductor had forgotten to collect the fare. She also knew that there were other things she could do with the money ifit was not paid, but she did what was expected by informing the conductor and paying the fare.What value did Imoh demonstrate?</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'Imoh demonstrated honesty. honesty is a virtue that involves being truthful and sincere. in the story, imh was transparent by informing the conductor about the unpaid fare and paying it, even though the conductor had forgotten to collect it.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Fair play.', 0, 0),
(@question_id, 'Honesty.', 1, 0),
(@question_id, 'Confidence.', 0, 0),
(@question_id, 'Tolerance.', 0, 0);

-- WAEC 2025 Civic Education - Item 23 - Question 23
SET @source_marker := 'WAEC 2025 Civic Education - Item 23 - Question 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 23 - Question 23</small></p><p><strong>WAEC 2025 Civic Education - Question 23</strong></p><p>Conflicts are better resolved in the society through</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'Conflicts are better resolved in the society through dialogue. Dialogue is a method of conflict resolution that involves
open, honest, and respectful communication between parties involved in a conflict. It allows for understanding,
compromise, and peaceful resolution of conflicts. While tribunal, litigation, and court are also methods of conflict
resolution, they are often more adversarial and may not lead to the best resolution for all parties involved.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'litigation.', 0, 0),
(@question_id, 'tribunal.', 0, 0),
(@question_id, 'dialogue.', 1, 0),
(@question_id, 'the court.', 0, 0);

-- WAEC 2025 Civic Education - Item 24 - Question 24
SET @source_marker := 'WAEC 2025 Civic Education - Item 24 - Question 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 24 - Question 24</small></p><p><strong>WAEC 2025 Civic Education - Question 24</strong></p><p>To prevent the spread of HIV/AIDS, people should be encouraged to</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'HIV/AIDS is primarily spread through unprotected sexual intercourse with an infected person. Therefore, avoiding casual
sexual activities can significantly reduce the risk of contracting or spreading the virus. This does not necessarily mean
that people should marry early in life, engage in gainful employment, or pursue higher education. These options may
have other benefits, but they do not directly prevent the spread of HIV/AIDS.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'pursue high education.', 0, 0),
(@question_id, 'engage in gainful employment.', 0, 0),
(@question_id, 'avoid casual sexual activities.', 1, 0),
(@question_id, 'marry very early in life.', 0, 0);

-- WAEC 2025 Civic Education - Item 25 - Question 25
SET @source_marker := 'WAEC 2025 Civic Education - Item 25 - Question 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 25 - Question 25</small></p><p><strong>WAEC 2025 Civic Education - Question 25</strong></p><p>The nearest government to the people and an important means of promoting grassroots development is the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'Local government is the nearest government that is close to the grass root people and promote government at grass root', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'state government', 0, 0),
(@question_id, 'unitary government', 0, 0),
(@question_id, 'local government', 1, 0),
(@question_id, 'federal government', 0, 0);

-- WAEC 2025 Civic Education - Item 26 - Question 26
SET @source_marker := 'WAEC 2025 Civic Education - Item 26 - Question 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 26 - Question 26</small></p><p><strong>WAEC 2025 Civic Education - Question 26</strong></p><p>Democratic governance is usually characterized by</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Political Participation', 'Democratic governance is characterized by free, fair, and credible elections. This is because democracy is a system of
government where citizens exercise power by voting. In a democratic system, the citizens have the right to vote in order
to choose their representatives in the government. The process of voting should be free, fair, and credible to ensure that
the will of the people is accurately represented.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'accessible employment opportunities.', 0, 0),
(@question_id, 'youth participation in governance.', 0, 0),
(@question_id, 'buoyant and competitive economy.', 0, 0),
(@question_id, 'free, fair and credible elections.', 1, 0);

-- WAEC 2025 Civic Education - Item 27 - Question 27
SET @source_marker := 'WAEC 2025 Civic Education - Item 27 - Question 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 27 - Question 27</small></p><p><strong>WAEC 2025 Civic Education - Question 27</strong></p><p>Political apathy often leads to</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Political Participation', 'Political apathy is when the citizens of a country are not interested or involved in politics and this lead to low level of
participation.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'good governance.', 0, 0),
(@question_id, 'low literacy level.', 0, 0),
(@question_id, 'low level of participation.', 1, 0),
(@question_id, 'political stability.', 0, 0);

-- WAEC 2025 Civic Education - Item 28 - Question 28
SET @source_marker := 'WAEC 2025 Civic Education - Item 28 - Question 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 28 - Question 28</small></p><p><strong>WAEC 2025 Civic Education - Question 28</strong></p><p>Which of the following is not necessary for public servants to perform effectively?</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'The effectiveness of public servants is not directly influenced by the acceptance of foreign aid by the government. Public
servants'' performance is more related to their skills, training, resources, and the institutional framework within which
they operate. Acceptance of foreign aid by the government is a policy decision that may indirectly affect public service
by providing additional resources or imposing certain conditions, but it is not a necessary condition for publie servants
to perform effectively.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Periodic review of the constitution by government.', 0, 0),
(@question_id, 'Acceptance of foreign aid by the government.', 1, 0),
(@question_id, 'Declaration of state of emergency by government.', 0, 0),
(@question_id, 'Improvement in literacy level of the citizens.', 0, 0);

-- WAEC 2025 Civic Education - Item 29 - Question 29
SET @source_marker := 'WAEC 2025 Civic Education - Item 29 - Question 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 29 - Question 29</small></p><p><strong>WAEC 2025 Civic Education - Question 29</strong></p><p>One of the conditions which can limit the enjoyment of Human Rights in Nigeria is the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Human Rights', 'The declaration of a state of emergency by the government can limit the enjoyment of human rights. During a state of
emergency, certain civil liberties can be suspended, such as freedom of assembly, freedom of movement, and the right to
a fair trial. This is done to maintain order and security during a crisis. Therefore, the declaration of a state of emergency
is a condition that can limit the enjoyment of human rights in Nigeria.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'improvement in literacy level of the citizens.', 0, 0),
(@question_id, 'acceptance of foreign aid by the government.', 0, 0),
(@question_id, 'periodic review of the constitution by government.', 0, 0),
(@question_id, 'declaration of state of emergency by government.', 1, 0);

-- WAEC 2025 Civic Education - Item 30 - Question 30
SET @source_marker := 'WAEC 2025 Civic Education - Item 30 - Question 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 30 - Question 30</small></p><p><strong>WAEC 2025 Civic Education - Question 30</strong></p><p>The drunkard as depicted in the picture will not likely perform his parental role because</p><p><em>Diagram reference: image was marked present in the source file, but no image asset was supplied.</em></p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Responsible Parenthood', 'The drunkard as depicted in the picture will not likely perform his parental role because his action constitutes bad
influence', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'drinking problem is associated with the poor.', 0, 0),
(@question_id, 'rehabilitation facilities are not available.', 0, 0),
(@question_id, 'he has a large family to cater for.', 0, 0),
(@question_id, 'his action constitutes bad influence.', 1, 0);

-- WAEC 2025 Civic Education - Item 31 - Question 31
SET @source_marker := 'WAEC 2025 Civic Education - Item 31 - Question 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 31 - Question 31</small></p><p><strong>WAEC 2025 Civic Education - Question 31</strong></p><p>The above picture portrays drunkenness mainly as</p><p><em>Diagram reference: image was marked present in the source file, but no image asset was supplied.</em></p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Responsible Parenthood', 'The picture portrays drunkenness mainly as an environmental nuisance.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'a challenge to responsible parenting.', 0, 0),
(@question_id, 'an individual habit in the society.', 0, 0),
(@question_id, 'an environmental nuisance.', 1, 0),
(@question_id, 'a potential health hazard.', 0, 0);

-- WAEC 2025 Civic Education - Item 32 - Question 32
SET @source_marker := 'WAEC 2025 Civic Education - Item 32 - Question 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 32 - Question 32</small></p><p><strong>WAEC 2025 Civic Education - Question 32</strong></p><p>The implication of positive communal relationships is that it</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Communal Relationships', 'Positive communal relationships promotes solidarity and love. It also promote diplomatic relationships among the
people.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'promotes rural-urban drift.', 0, 0),
(@question_id, 'promotes solidarity and love.', 1, 0),
(@question_id, 'encourages ethnic diversity.', 0, 0),
(@question_id, 'ensures obedience to constituted authority.', 0, 0);

-- WAEC 2025 Civic Education - Item 33 - Question 33
SET @source_marker := 'WAEC 2025 Civic Education - Item 33 - Question 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 33 - Question 33</small></p><p><strong>WAEC 2025 Civic Education - Question 33</strong></p><p>One major factor that attracts some Nigerians into human trafficking is</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Road Safety', 'The major factor that attracts some Nigerians into human trafficking is insatiable quest for quick wealth.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'influx of foreigners into the country.', 0, 0),
(@question_id, 'influence of Western and social media.', 0, 0),
(@question_id, 'insatiable quest for quick wealth.', 1, 0),
(@question_id, 'over-population related issues.', 0, 0);

-- WAEC 2025 Civic Education - Item 34 - Question 34
SET @source_marker := 'WAEC 2025 Civic Education - Item 34 - Question 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 34 - Question 34</small></p><p><strong>WAEC 2025 Civic Education - Question 34</strong></p><p>One of the reasons most HIV/AIDS patients are reluctant to disclose their status is because of</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'Fear of social stigmatization is one of the reasons most HIV/AIDS patients are reluctant to disclose their status.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'lack of sufficient public awareness.', 0, 0),
(@question_id, '[Missing option in source file]', 0, 0),
(@question_id, 'shortage of health counselors.', 0, 0),
(@question_id, 'fear of social stigmatization.', 1, 0);

-- WAEC 2025 Civic Education - Item 35 - Question 35
SET @source_marker := 'WAEC 2025 Civic Education - Item 35 - Question 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 35 - Question 35</small></p><p><strong>WAEC 2025 Civic Education - Question 35</strong></p><p>Use the report below to answer this question.The Bawali High Court has ordered the police in Area Z Command to produce Mr. Zeb, who is in police custody for analleged offence. The court insists that Mr. Zeb cannot be punished until he is found guilty of breach of any law of theland by a court of competent jurisdiction.The position of the court on this matter justifies the essence of the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Rule of Law', 'The position of the Court on this matter justifies the essence of the rule of law. A person or an accused person is
presume innocent until it is found guilty by the court of law.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'police command.', 0, 0),
(@question_id, 'rule of law.', 1, 0),
(@question_id, 'legislature.', 0, 0),
(@question_id, 'separation of power', 0, 0);

-- WAEC 2025 Civic Education - Item 36 - Question 36
SET @source_marker := 'WAEC 2025 Civic Education - Item 36 - Question 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 36 - Question 36</small></p><p><strong>WAEC 2025 Civic Education - Question 36</strong></p><p>Leaders can best protect the interest of their followers by</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Civic Education', 'Creating Conducive atmosphere for participation is one of the way a leader can protect the interest of their followers.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'embarking on periodic constitutional review.', 1, 0),
(@question_id, 'rewarding supports with contracts.', 0, 0),
(@question_id, 'creating socio-economic opportunities for foreigners.', 0, 0),
(@question_id, 'creating conducive atmosphere for participation.', 0, 0);

-- WAEC 2025 Civic Education - Item 37 - Question 37
SET @source_marker := 'WAEC 2025 Civic Education - Item 37 - Question 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 37 - Question 37</small></p><p><strong>WAEC 2025 Civic Education - Question 37</strong></p><p>Civil societies are vital for the promotion of popular participation because they are</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Political Participation', 'Civil societies are non-profit organizations that are involved in promoting political education among the citizens. They
are not profit-oriented organizations, they are not necessarily engaged in developmental programmes, and they are not
formidable oppositions to government. They are involved in political education because they help to educate the citizens
about their rights, responsibilities, and the workings of the government. This helps to promote popular participation in
the political process as more informed citizens are more likely to participate actively in the political process.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'formidable oppositions to government.', 0, 0),
(@question_id, 'engaged in developmental programmes.', 0, 0),
(@question_id, 'profit-oriented organizations.', 0, 0),
(@question_id, 'involved in political education.', 1, 0);

-- WAEC 2025 Civic Education - Item 38 - Question 38
SET @source_marker := 'WAEC 2025 Civic Education - Item 38 - Question 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 38 - Question 38</small></p><p><strong>WAEC 2025 Civic Education - Question 38</strong></p><p>Use the dialogue below to answer this question.</p><p>Ada: Wanja, where are you going to in this ungodly hour of the night?
Wanja: I am heading towards my usual joint to enjoy myself.
Ada: Which joint?
Wanja: XYZ Night Club, where I take marijuana and alcoholic beverages. I really want to be high tonight so that when people see me tomorrow, they will fear and respect me.
Ada: Remember, people who work under the influence of hard drugs and alcoholic beverages are prone to either psychiatric problems or premature death.
Ada: Softly young man, imbibe good-natured character, you have the world at your feet and a destiny to fulfill. Pray you will not be the architect of your own misfortune.From this dialogue, it is very likely that Wanja will be exhibiting the following characters except</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Drug Abuse', 'From this dialogue, it is very likely that Wanja will not exhibit the character of hospitable attitude towards people.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'hospitable attitude towards people.', 1, 0),
(@question_id, 'arrogance and unruly behavior.', 0, 0),
(@question_id, 'disobedience to constituted authority.', 0, 0),
(@question_id, 'truancy and perpetual lateness to school.', 0, 0);

-- WAEC 2025 Civic Education - Item 39 - Question 39
SET @source_marker := 'WAEC 2025 Civic Education - Item 39 - Question 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 39 - Question 39</small></p><p><strong>WAEC 2025 Civic Education - Question 39</strong></p><p>Use the dialogue below to answer this question.</p><p>Ada: Wanja, where are you going to in this ungodly hour of the night?
Wanja: I am heading towards my usual joint to enjoy myself.
Ada: Which joint?
Wanja: XYZ Night Club, where I take marijuana and alcoholic beverages. I really want to be high tonight so that when people see me tomorrow, they will fear and respect me.
Ada: Remember, people who work under the influence of hard drugs and alcoholic beverages are prone to either psychiatric problems or premature death.
Ada: Softly young man, imbibe good-natured character, you have the world at your feet and a destiny to fulfill. Pray you will not be the architect of your own misfortune.Which of the following may result from Wanja&#039;s habit?</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Drug Abuse', 'Criminality in the society may result from Wanja''s habit smoking and alcohols result in bad friendstand this lead to
criminality in the society.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Humility for elders.', 0, 0),
(@question_id, 'Excellent performance in school.', 0, 0),
(@question_id, 'Advocacy for hard drugs by NGOs.', 0, 0),
(@question_id, 'Criminality in the society.', 1, 0);

-- WAEC 2025 Civic Education - Item 40 - Question 40
SET @source_marker := 'WAEC 2025 Civic Education - Item 40 - Question 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 40 - Question 40</small></p><p><strong>WAEC 2025 Civic Education - Question 40</strong></p><p>Use the dialogue below to answer this question.</p><p>Ada: Wanja, where are you going to in this ungodly hour of the night?
Wanja: I am heading towards my usual joint to enjoy myself.
Ada: Which joint?
Wanja: XYZ Night Club, where I take marijuana and alcoholic beverages. I really want to be high tonight so that when people see me tomorrow, they will fear and respect me.
Ada: Remember, people who work under the influence of hard drugs and alcoholic beverages are prone to either psychiatric problems or premature death.
Ada: Softly young man, imbibe good-natured character, you have the world at your feet and a destiny to fulfill. Pray you will not be the architect of your own misfortune.From Ada&#039;s admonition, it could be deduced that taking hard drugs could</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Drug Abuse', 'From Ada''s admonition, it could be deduced that taking hard drugs could lead to insanity of thetaddictss', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'lead to insanity of the addicts.', 1, 0),
(@question_id, 'make people to adore the drug addicts.', 0, 0),
(@question_id, 'make people respect the addicts.', 0, 0),
(@question_id, 'ensure courteous behavior by the addicts.', 0, 0);

-- WAEC 2025 Civic Education - Item 41 - Question 41
SET @source_marker := 'WAEC 2025 Civic Education - Item 41 - Question 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 41 - Question 41</small></p><p><strong>WAEC 2025 Civic Education - Question 41</strong></p><p>Use the dialogue below to answer this question.</p><p>Ada: Wanja, where are you going to in this ungodly hour of the night?
Wanja: I am heading towards my usual joint to enjoy myself.
Ada: Which joint?
Wanja: XYZ Night Club, where I take marijuana and alcoholic beverages. I really want to be high tonight so that when people see me tomorrow, they will fear and respect me.
Ada: Remember, people who work under the influence of hard drugs and alcoholic beverages are prone to either psychiatric problems or premature death.
Ada: Softly young man, imbibe good-natured character, you have the world at your feet and a destiny to fulfill. Pray you will not be the architect of your own misfortune.From the above dialogue, Wanja&#039;s behavior could be curtailed by</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Drug Abuse', 'From the dialogue, Wanja is involved in substance abuse and this behavior can be curtailed through re-orientation and
rehabilitation. Re-orientation involves changing his perspective about substance abuse and its effects, while
rehabilitation involves helping him overcome his addiction. Sending him abroad for further studies or indulging him
with expensive gifts may not necessarily change his behavior. Financial inducement may even worsen the situation as
he may use the money to buy more drugs.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Re-orientation and rehabilitation.', 1, 0),
(@question_id, 'Sending him abroad for further studies.', 0, 0),
(@question_id, 'Financial inducement.', 0, 0),
(@question_id, 'Indulging him with expensive gifts.', 0, 0);

-- WAEC 2025 Civic Education - Item 42 - Question 42
SET @source_marker := 'WAEC 2025 Civic Education - Item 42 - Question 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 42 - Question 42</small></p><p><strong>WAEC 2025 Civic Education - Question 42</strong></p><p>Use the dialogue below to answer this question.</p><p>Ada: Wanja, where are you going to in this ungodly hour of the night?
Wanja: I am heading towards my usual joint to enjoy myself.
Ada: Which joint?
Wanja: XYZ Night Club, where I take marijuana and alcoholic beverages. I really want to be high tonight so that when people see me tomorrow, they will fear and respect me.
Ada: Remember, people who work under the influence of hard drugs and alcoholic beverages are prone to either psychiatric problems or premature death.
Ada: Softly young man, imbibe good-natured character, you have the world at your feet and a destiny to fulfill. Pray you will not be the architect of your own misfortune.Which of the following governmental agencies is the most capable of controlling the activities of Wanja and his group?</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Drug Abuse', 'National Drug Law Enforcement Agency (NDLEA) is governmental agencies that is capable of controlling the activities
of Wanja and his group. NDLEA are charge with the responsibility of orientate the drug addicts.to', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'National Emergency Management Agency (NEMA)', 0, 0),
(@question_id, 'National Agency for Food and Drug Administration and Control (NAFDAC)', 0, 0),
(@question_id, 'National Orientation Agency (NOA)', 0, 0),
(@question_id, 'National Drug Law Enforcement Agency (NDLEA)', 1, 0);

-- WAEC 2025 Civic Education - Item 43 - Question 43
SET @source_marker := 'WAEC 2025 Civic Education - Item 43 - Question 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 43 - Question 43</small></p><p><strong>WAEC 2025 Civic Education - Question 43</strong></p><p>Use the dialogue below to answer this question.</p><p>Ada: Wanja, where are you going to in this ungodly hour of the night?
Wanja: I am heading towards my usual joint to enjoy myself.
Ada: Which joint?
Wanja: XYZ Night Club, where I take marijuana and alcoholic beverages. I really want to be high tonight so that when people see me tomorrow, they will fear and respect me.
Ada: Remember, people who work under the influence of hard drugs and alcoholic beverages are prone to either psychiatric problems or premature death.
Ada: Softly young man, imbibe good-natured character, you have the world at your feet and a destiny to fulfill. Pray you will not be the architect of your own misfortune.One of the major barriers to national development is the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Drug Abuse', 'The dialogue suggests that drug and alcohol abuse, which can be seen as a form of social corruptiontis a major barrier
to national development.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'low poverty level.', 0, 0),
(@question_id, 'persistent rural-urban migration.', 0, 0),
(@question_id, 'prevalence of corrupt practices.', 1, 0),
(@question_id, 'existence of multi-party system.', 0, 0);

-- WAEC 2025 Civic Education - Item 44 - Question 44
SET @source_marker := 'WAEC 2025 Civic Education - Item 44 - Question 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 44 - Question 44</small></p><p><strong>WAEC 2025 Civic Education - Question 44</strong></p><p>Use the dialogue below to answer this question.</p><p>Ada: Wanja, where are you going to in this ungodly hour of the night?
Wanja: I am heading towards my usual joint to enjoy myself.
Ada: Which joint?
Wanja: XYZ Night Club, where I take marijuana and alcoholic beverages. I really want to be high tonight so that when people see me tomorrow, they will fear and respect me.
Ada: Remember, people who work under the influence of hard drugs and alcoholic beverages are prone to either psychiatric problems or premature death.
Ada: Softly young man, imbibe good-natured character, you have the world at your feet and a destiny to fulfill. Pray you will not be the architect of your own misfortune.The quotation above shows that the speaker is concerned about</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Drug Abuse', 'The dialogue shows that Ada is concerned about Wanja''s welfare, which is why she warns him about the dangers of
drug and alcohol abuse and advises him to lead a good life.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'nationalism.', 0, 0),
(@question_id, 'revolution.', 0, 0),
(@question_id, 'tourism.', 0, 0),
(@question_id, 'welfarism.', 1, 0);

-- WAEC 2025 Civic Education - Item 45 - Question 45
SET @source_marker := 'WAEC 2025 Civic Education - Item 45 - Question 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 45 - Question 45</small></p><p><strong>WAEC 2025 Civic Education - Question 45</strong></p><p>A major benefit of youth empowerment is</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Youth Empowerment', 'Reduction in crime rate is a major benefit of Youth empowerment. It is believed that when youths are engaged the crime
rate reduced.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'discouragement of patriotism.', 0, 0),
(@question_id, 'negation to national prosperity.', 0, 0),
(@question_id, 'dependence on foreign aid.', 0, 0),
(@question_id, 'reduction in crime rate.', 1, 0);

-- WAEC 2025 Civic Education - Item 46 - Question 46
SET @source_marker := 'WAEC 2025 Civic Education - Item 46 - Question 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 46 - Question 46</small></p><p><strong>WAEC 2025 Civic Education - Question 46</strong></p><p>Use the story below to answer this question.</p><p>Chief Bilisi was prominent politician and honourable minister in Kantogo Republic. He had sponsored several candidates to power and made them to swear oath of allegiance to him. In return, they awarded contracts and offered financial and material assistance to him at the expense of the public. This had resulted in the non-provision of social amenities. These were some of the grievances the community had against him for which a mob gathered in front of his house shouting and hurling abusive words at him. They did not stop at that as they vandalized property and obstructedvehicular movement.</p><p>When leaders like Chief Bilisi place self interest above public goods, the result is that</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Communal Relationships', 'When leaders like Chief Bilisi place self interest above public goods, the result is that rebellion becomes inevitable.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'cooperation of citizens is guaranteed.', 0, 0),
(@question_id, 'rebellion becomes inevitable.', 1, 0),
(@question_id, 'international support for the regime is ensured.', 0, 0),
(@question_id, '.society becomes more peaceful and orderly.', 0, 0);

-- WAEC 2025 Civic Education - Item 47 - Question 47
SET @source_marker := 'WAEC 2025 Civic Education - Item 47 - Question 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 47 - Question 47</small></p><p><strong>WAEC 2025 Civic Education - Question 47</strong></p><p>Use the story below to answer this question.</p><p>Chief Bilisi was prominent politician and honourable minister in Kantogo Republic. He had sponsored several candidates to power and made them to swear oath of allegiance to him. In return, they awarded contracts and offered financial and material assistance to him at the expense of the public. This had resulted in the non-provision of social amenities. These were some of the grievances the community had against him for which a mob gathered in front of his house shouting and hurling abusive words at him. They did not stop at that as they vandalized property and obstructedvehicular movement.</p><p>The condition of disorderly behaviour exhibited by the mob in the story best describes the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Communal Relationships', 'The condition of disorderly behaviour exhibited by the mob in the story best describes the breakdown of law and
order in the society or country.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'importance of ministerial position.', 0, 0),
(@question_id, 'ineffectiveness of the police.', 0, 0),
(@question_id, 'breakdown of law and order.', 1, 0),
(@question_id, 'need for stiffer security measures.', 0, 0);

-- WAEC 2025 Civic Education - Item 48 - Question 48
SET @source_marker := 'WAEC 2025 Civic Education - Item 48 - Question 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 48 - Question 48</small></p><p><strong>WAEC 2025 Civic Education - Question 48</strong></p><p>Use the story below to answer this question.</p><p>Chief Bilisi was prominent politician and honourable minister in Kantogo Republic. He had sponsored several candidates to power and made them to swear oath of allegiance to him. In return, they awarded contracts and offered financial and material assistance to him at the expense of the public. This had resulted in the non-provision of social amenities. These were some of the grievances the community had against him for which a mob gathered in front of his house shouting and hurling abusive words at him. They did not stop at that as they vandalized property and obstructedvehicular movement.</p><p>A major lesson Nigerians could learn from the story is that</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Communal Relationships', 'A major lesson Nigerians could learn from the story is that greed and related vices can cause serious breach of the law', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'the underprivileged should not vie for elective positions.', 0, 0),
(@question_id, 'leaders can empower voters by giving them money', 0, 0),
(@question_id, 'security officials should use brutal force on citizens.', 0, 0),
(@question_id, 'greed and related vices can cause serious breach of the law.', 1, 0);

-- WAEC 2025 Civic Education - Item 49 - Question 49
SET @source_marker := 'WAEC 2025 Civic Education - Item 49 - Question 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 49 - Question 49</small></p><p><strong>WAEC 2025 Civic Education - Question 49</strong></p><p>Youth empowerment is best described as the</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Youth Empowerment', 'Youth empowerment is described as the training given individuals for acquiring means of livelihood to earn a living.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'mobilization of citizens for political rally.', 0, 0),
(@question_id, 'practice of engaging in prospective career.', 0, 0),
(@question_id, 'provision of subsidized meals to the citizen by government.', 0, 0),
(@question_id, 'training given individuals for acquiring means of livelihood.', 1, 0);

-- WAEC 2025 Civic Education - Item 50 - Question 50
SET @source_marker := 'WAEC 2025 Civic Education - Item 50 - Question 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'exam_body' AND exam_body_id = @waec_exam_body_id AND subject_id = @civic_subject_id AND exam_year = 2025 AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: WAEC 2025 Civic Education - Item 50 - Question 50</small></p><p><strong>WAEC 2025 Civic Education - Question 50</strong></p><p>The most popular means through which citizens of a country can participate in politics is by</p>', @civic_subject_id, 0, 'exam_body', @waec_exam_body_id, 2025, 0, 'Medium', 'SSS3', '', 'Political Participation', 'Voting in elections is one of the ways a citizen of a country participate in politics. Citizens participate in politics by
exercising his franchise right.

----------------------------------------------------------------------', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'voting in elections.', 1, 0),
(@question_id, 'engaging in political debates.', 0, 0),
(@question_id, 'being members of political parties.', 0, 0),
(@question_id, 'engaging in constructive criticisms.', 0, 0);

COMMIT;

SELECT COUNT(*) AS imported_questions
FROM question_bank
WHERE source_type = 'exam_body'
  AND exam_body_id = @waec_exam_body_id
  AND subject_id = @civic_subject_id
  AND exam_year = 2025
  AND question LIKE '%WAEC 2025 Civic Education - Item%';

SELECT COUNT(*) AS imported_options
FROM question_bank_options
WHERE question_id IN (
    SELECT id
    FROM question_bank
    WHERE source_type = 'exam_body'
      AND exam_body_id = @waec_exam_body_id
      AND subject_id = @civic_subject_id
      AND exam_year = 2025
      AND question LIKE '%WAEC 2025 Civic Education - Item%'
);

SELECT COUNT(*) AS bad_option_groups
FROM (
    SELECT qb.id
    FROM question_bank qb
    LEFT JOIN question_bank_options qbo ON qbo.question_id = qb.id
    WHERE qb.source_type = 'exam_body'
      AND qb.exam_body_id = @waec_exam_body_id
      AND qb.subject_id = @civic_subject_id
      AND qb.exam_year = 2025
      AND qb.question LIKE '%WAEC 2025 Civic Education - Item%'
    GROUP BY qb.id
    HAVING COUNT(qbo.id) <> 4 OR SUM(qbo.answer = 1) <> 1
) invalid_groups;
