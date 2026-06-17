-- Geometrical Construction topic questions for the global question bank.
-- Generated from: q_bank/geometrical_construction_final/questions.json
-- Expected payload: 50 questions and 200 options.
-- Repeat-safe: each question uses a stable source marker in question_bank.question.

SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS topics (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_id INT NOT NULL,
    class_id INT NOT NULL,
    topic_name VARCHAR(255) NOT NULL
);

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
    KEY idx_qb_topic_lookup (school_id, deleted, review_status, subject_id, topic_id, difficulty),
    KEY idx_qb_topic (topic_id)
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

SET @mathematics_subject_id := (SELECT id FROM subjects WHERE subject IN ('Mathematics', 'Maths', 'Math') ORDER BY FIELD(subject, 'Mathematics', 'Maths', 'Math'), id ASC LIMIT 1);

DROP PROCEDURE IF EXISTS ss360_require_geometrical_construction_refs;
DELIMITER $$
CREATE PROCEDURE ss360_require_geometrical_construction_refs()
BEGIN
    IF @mathematics_subject_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mathematics subject could not be resolved. Create the subject before running this migration.';
    END IF;
END$$
DELIMITER ;
CALL ss360_require_geometrical_construction_refs();
DROP PROCEDURE ss360_require_geometrical_construction_refs;

INSERT INTO topics (subject_id, class_id, topic_name)
SELECT @mathematics_subject_id, 0, 'Geometrical Construction'
WHERE NOT EXISTS (
    SELECT 1 FROM topics
    WHERE subject_id = @mathematics_subject_id
      AND class_id = 0
      AND topic_name = 'Geometrical Construction'
);

SET @geometrical_construction_topic_id := (
    SELECT id FROM topics
    WHERE subject_id = @mathematics_subject_id
      AND topic_name = 'Geometrical Construction'
    ORDER BY CASE WHEN class_id = 0 THEN 0 ELSE 1 END, id ASC
    LIMIT 1
);

START TRANSACTION;

-- Geometrical Construction Topic Bank - Item 1
SET @source_marker := 'Geometrical Construction Topic Bank - Item 1';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 1</small></p><p><strong>Geometrical Construction - Question 1</strong></p><p>Which instrument is mainly used for drawing circles and arcs?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Construction Instruments', 'A compass is used to draw circles and arcs.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Protractor', 0, 0),
(@question_id, 'Compass', 1, 0),
(@question_id, 'Ruler', 0, 0),
(@question_id, 'Set square', 0, 0);

-- Geometrical Construction Topic Bank - Item 2
SET @source_marker := 'Geometrical Construction Topic Bank - Item 2';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 2</small></p><p><strong>Geometrical Construction - Question 2</strong></p><p>Which instrument is used for measuring angles?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Construction Instruments', 'A protractor is used to measure angles.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Compass', 0, 0),
(@question_id, 'Divider', 0, 0),
(@question_id, 'Protractor', 1, 0),
(@question_id, 'Ruler', 0, 0);

-- Geometrical Construction Topic Bank - Item 3
SET @source_marker := 'Geometrical Construction Topic Bank - Item 3';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 3</small></p><p><strong>Geometrical Construction - Question 3</strong></p><p>Which instrument is best used for drawing straight line segments?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Construction Instruments', 'A ruler is used for drawing straight lines and measuring lengths.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Compass', 0, 0),
(@question_id, 'Ruler', 1, 0),
(@question_id, 'Protractor', 0, 0),
(@question_id, 'Divider', 0, 0);

-- Geometrical Construction Topic Bank - Item 4
SET @source_marker := 'Geometrical Construction Topic Bank - Item 4';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 4</small></p><p><strong>Geometrical Construction - Question 4</strong></p><p>A pair of set squares is mainly used to construct</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Construction Instruments', 'Set squares are commonly used to construct parallel and perpendicular lines.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Circles', 0, 0),
(@question_id, 'Curves', 0, 0),
(@question_id, 'Parallel and perpendicular lines', 1, 0),
(@question_id, 'Arcs only', 0, 0);

-- Geometrical Construction Topic Bank - Item 5
SET @source_marker := 'Geometrical Construction Topic Bank - Item 5';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 5</small></p><p><strong>Geometrical Construction - Question 5</strong></p><p>The perpendicular bisector of a line segment divides the line segment into</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Basic Construction', 'A perpendicular bisector cuts a line into two equal parts at 90°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Three equal parts', 0, 0),
(@question_id, 'Two equal parts at right angles', 1, 0),
(@question_id, 'Four equal parts', 0, 0),
(@question_id, 'Two unequal parts', 0, 0);

-- Geometrical Construction Topic Bank - Item 6
SET @source_marker := 'Geometrical Construction Topic Bank - Item 6';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 6</small></p><p><strong>Geometrical Construction - Question 6</strong></p><p>An angle bisector divides an angle into</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Basic Construction', 'An angle bisector divides an angle into two equal angles.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Three equal angles', 0, 0),
(@question_id, 'Two equal angles', 1, 0),
(@question_id, 'Four equal angles', 0, 0),
(@question_id, 'Two supplementary angles', 0, 0);

-- Geometrical Construction Topic Bank - Item 7
SET @source_marker := 'Geometrical Construction Topic Bank - Item 7';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 7</small></p><p><strong>Geometrical Construction - Question 7</strong></p><p>Which of the following angles can be constructed directly using an equilateral triangle?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Construction Angles', 'Each angle of an equilateral triangle measures 60°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '45°', 0, 0),
(@question_id, '60°', 1, 0),
(@question_id, '75°', 0, 0),
(@question_id, '135°', 0, 0);

-- Geometrical Construction Topic Bank - Item 8
SET @source_marker := 'Geometrical Construction Topic Bank - Item 8';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 8</small></p><p><strong>Geometrical Construction - Question 8</strong></p><p>A right angle measures</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Construction Angles', 'A right angle is 90°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '30°', 0, 0),
(@question_id, '45°', 0, 0),
(@question_id, '90°', 1, 0),
(@question_id, '180°', 0, 0);

-- Geometrical Construction Topic Bank - Item 9
SET @source_marker := 'Geometrical Construction Topic Bank - Item 9';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 9</small></p><p><strong>Geometrical Construction - Question 9</strong></p><p>How many sides of an equilateral triangle are equal?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Triangles', 'All three sides of an equilateral triangle are equal.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'One', 0, 0),
(@question_id, 'Two', 0, 0),
(@question_id, 'Three', 1, 0),
(@question_id, 'None', 0, 0);

-- Geometrical Construction Topic Bank - Item 10
SET @source_marker := 'Geometrical Construction Topic Bank - Item 10';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 10</small></p><p><strong>Geometrical Construction - Question 10</strong></p><p>The perpendicular bisector of a line segment is the locus of points that are</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Easy', 'JSS3', '', 'Locus', 'Every point on a perpendicular bisector is equally distant from the endpoints of the line segment.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Equidistant from the two endpoints', 1, 0),
(@question_id, 'On the line segment only', 0, 0),
(@question_id, 'Equidistant from three points', 0, 0),
(@question_id, 'Always inside a triangle', 0, 0);

-- Geometrical Construction Topic Bank - Item 11
SET @source_marker := 'Geometrical Construction Topic Bank - Item 11';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 11</small></p><p><strong>Geometrical Construction - Question 11</strong></p><p>To construct the perpendicular bisector of a line segment, the first step is to</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Construction Procedure', 'Equal arcs from both endpoints locate points through which the perpendicular bisector passes.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Measure the line with a protractor', 0, 0),
(@question_id, 'Draw equal arcs from both endpoints using the same compass radius', 1, 0),
(@question_id, 'Join the endpoints with a ruler twice', 0, 0),
(@question_id, 'Construct a right angle at one endpoint', 0, 0);

-- Geometrical Construction Topic Bank - Item 12
SET @source_marker := 'Geometrical Construction Topic Bank - Item 12';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 12</small></p><p><strong>Geometrical Construction - Question 12</strong></p><p>When constructing the bisector of an angle, the compass radius used for the second pair of arcs should be</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Construction Procedure', 'Equal radii are required to locate the point through which the angle bisector passes.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Different for each arm', 0, 0),
(@question_id, 'Equal on both arms of the angle', 1, 0),
(@question_id, 'Zero', 0, 0),
(@question_id, 'Twice the length of one arm', 0, 0);

-- Geometrical Construction Topic Bank - Item 13
SET @source_marker := 'Geometrical Construction Topic Bank - Item 13';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 13</small></p><p><strong>Geometrical Construction - Question 13</strong></p><p>Which set of information is sufficient to construct a unique triangle?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Triangles', 'A triangle can be uniquely constructed when all three sides are known (SSS).', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'One side only', 0, 0),
(@question_id, 'Two angles only', 0, 0),
(@question_id, 'Three sides', 1, 0),
(@question_id, 'One angle only', 0, 0);

-- Geometrical Construction Topic Bank - Item 14
SET @source_marker := 'Geometrical Construction Topic Bank - Item 14';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 14</small></p><p><strong>Geometrical Construction - Question 14</strong></p><p>A student uses different compass widths when drawing the two arcs needed to construct a perpendicular bisector. What is the likely result?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Error Detection', 'The compass radius must remain the same for both arcs to obtain an accurate perpendicular bisector.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The construction will still produce a correct perpendicular bisector.', 0, 0),
(@question_id, 'The arcs may fail to locate the correct bisector.', 1, 0),
(@question_id, 'A circle will automatically be formed.', 0, 0),
(@question_id, 'The line segment will become shorter.', 0, 0);

-- Geometrical Construction Topic Bank - Item 15
SET @source_marker := 'Geometrical Construction Topic Bank - Item 15';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 15</small></p><p><strong>Geometrical Construction - Question 15</strong></p><p>A surveyor wants to locate a point that is exactly the same distance from two boundary pegs. Which construction should be used?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Application', 'Every point on the perpendicular bisector of a line segment is equidistant from its endpoints.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Angle bisector', 0, 0),
(@question_id, 'Perpendicular bisector', 1, 0),
(@question_id, 'Parallel line', 0, 0),
(@question_id, 'Circle tangent', 0, 0);

-- Geometrical Construction Topic Bank - Item 16
SET @source_marker := 'Geometrical Construction Topic Bank - Item 16';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 16</small></p><p><strong>Geometrical Construction - Question 16</strong></p><p>Which construction is used to draw a line at right angles to a given line from a point on the line?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Construction Procedure', 'A perpendicular line meets another line at 90°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Construction of a perpendicular line', 1, 0),
(@question_id, 'Construction of an angle bisector', 0, 0),
(@question_id, 'Construction of a parallel line', 0, 0),
(@question_id, 'Construction of a circle', 0, 0);

-- Geometrical Construction Topic Bank - Item 17
SET @source_marker := 'Geometrical Construction Topic Bank - Item 17';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 17</small></p><p><strong>Geometrical Construction - Question 17</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_017.png" alt="Diagram for Geometrical Construction Question 17" style="max-width:100%;height:auto;"></p><p>In the diagram, line PQ passes through the midpoint of AB and meets AB at 90°. What is PQ?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Diagram Interpretation', 'A perpendicular bisector cuts a line segment into two equal parts at right angles.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Angle bisector of AB', 0, 0),
(@question_id, 'Perpendicular bisector of AB', 1, 0),
(@question_id, 'Parallel line to AB', 0, 0),
(@question_id, 'Radius of AB', 0, 0);

-- Geometrical Construction Topic Bank - Item 18
SET @source_marker := 'Geometrical Construction Topic Bank - Item 18';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 18</small></p><p><strong>Geometrical Construction - Question 18</strong></p><p>Which angle can be constructed by bisecting a 90° angle?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Construction Angles', 'Half of 90° is 45°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '30°', 0, 0),
(@question_id, '45°', 1, 0),
(@question_id, '60°', 0, 0),
(@question_id, '120°', 0, 0);

-- Geometrical Construction Topic Bank - Item 19
SET @source_marker := 'Geometrical Construction Topic Bank - Item 19';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 19</small></p><p><strong>Geometrical Construction - Question 19</strong></p><p>Which angle can be constructed by bisecting a 60° angle?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Construction Angles', 'Half of 60° is 30°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '15°', 0, 0),
(@question_id, '30°', 1, 0),
(@question_id, '45°', 0, 0),
(@question_id, '90°', 0, 0);

-- Geometrical Construction Topic Bank - Item 20
SET @source_marker := 'Geometrical Construction Topic Bank - Item 20';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 20</small></p><p><strong>Geometrical Construction - Question 20</strong></p><p>To construct triangle ABC with AB = 6 cm, AC = 5 cm and BC = 4 cm, which construction condition is being used?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Triangles', 'All three sides are given, so the triangle is constructed using SSS.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'ASA', 0, 0),
(@question_id, 'SAS', 0, 0),
(@question_id, 'SSS', 1, 0),
(@question_id, 'RHS', 0, 0);

-- Geometrical Construction Topic Bank - Item 21
SET @source_marker := 'Geometrical Construction Topic Bank - Item 21';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 21</small></p><p><strong>Geometrical Construction - Question 21</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_021.png" alt="Diagram for Geometrical Construction Question 21" style="max-width:100%;height:auto;"></p><p>In the diagram, ray OM divides angle AOB into two equal angles. What is OM?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Diagram Interpretation', 'An angle bisector divides an angle into two equal parts.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Perpendicular bisector', 0, 0),
(@question_id, 'Angle bisector', 1, 0),
(@question_id, 'Parallel line', 0, 0),
(@question_id, 'Median', 0, 0);

-- Geometrical Construction Topic Bank - Item 22
SET @source_marker := 'Geometrical Construction Topic Bank - Item 22';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 22</small></p><p><strong>Geometrical Construction - Question 22</strong></p><p>When constructing a line parallel to a given line through a point, which pair of instruments is most suitable?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Parallel Lines', 'A pair of set squares can be used to draw accurate parallel lines.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Compass and protractor', 0, 0),
(@question_id, 'Pair of set squares', 1, 0),
(@question_id, 'Divider only', 0, 0),
(@question_id, 'Compass only', 0, 0);

-- Geometrical Construction Topic Bank - Item 23
SET @source_marker := 'Geometrical Construction Topic Bank - Item 23';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 23</small></p><p><strong>Geometrical Construction - Question 23</strong></p><p>The locus of points at a fixed distance from a given point is</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Locus', 'All points at a fixed distance from a point form a circle.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'A straight line', 0, 0),
(@question_id, 'A circle', 1, 0),
(@question_id, 'A triangle', 0, 0),
(@question_id, 'A perpendicular line', 0, 0);

-- Geometrical Construction Topic Bank - Item 24
SET @source_marker := 'Geometrical Construction Topic Bank - Item 24';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 24</small></p><p><strong>Geometrical Construction - Question 24</strong></p><p>A student wants to construct a 60° angle but draws it using only estimation by eye. What is the main error?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Error Detection', 'Geometrical construction requires accurate use of instruments, not guessing by eye.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The angle may not be accurate.', 1, 0),
(@question_id, 'The angle will always be 90°.', 0, 0),
(@question_id, 'The line will become curved.', 0, 0),
(@question_id, 'The compass cannot draw arcs.', 0, 0);

-- Geometrical Construction Topic Bank - Item 25
SET @source_marker := 'Geometrical Construction Topic Bank - Item 25';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 25</small></p><p><strong>Geometrical Construction - Question 25</strong></p><p>A carpenter wants to divide a wooden strip into two equal parts and mark a line at right angles through the middle. Which construction should be used?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Application', 'A perpendicular bisector divides a line segment into two equal parts at right angles.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Angle bisector', 0, 0),
(@question_id, 'Perpendicular bisector', 1, 0),
(@question_id, 'Parallel line', 0, 0),
(@question_id, 'Circle construction', 0, 0);

-- Geometrical Construction Topic Bank - Item 26
SET @source_marker := 'Geometrical Construction Topic Bank - Item 26';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 26</small></p><p><strong>Geometrical Construction - Question 26</strong></p><p>Which method can be used to construct an angle of 120°?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Construction Angles', 'Two successive angles of 60° give 60° + 60° = 120°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Bisect a 60° angle', 0, 0),
(@question_id, 'Construct two successive angles of 60°', 1, 0),
(@question_id, 'Bisect a 90° angle', 0, 0),
(@question_id, 'Subtract 60° from 90°', 0, 0);

-- Geometrical Construction Topic Bank - Item 27
SET @source_marker := 'Geometrical Construction Topic Bank - Item 27';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 27</small></p><p><strong>Geometrical Construction - Question 27</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_027.png" alt="Diagram for Geometrical Construction Question 27" style="max-width:100%;height:auto;"></p><p>In the diagram, C and D are equally distant from P on line AB. Arcs drawn from C and D intersect at Q. What is the relationship between PQ and AB?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Diagram Interpretation', 'The equal arcs locate Q directly above P, making PQ perpendicular to AB.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'PQ is parallel to AB.', 0, 0),
(@question_id, 'PQ is perpendicular to AB.', 1, 0),
(@question_id, 'PQ is equal in length to AB.', 0, 0),
(@question_id, 'PQ bisects angle A.', 0, 0);

-- Geometrical Construction Topic Bank - Item 28
SET @source_marker := 'Geometrical Construction Topic Bank - Item 28';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 28</small></p><p><strong>Geometrical Construction - Question 28</strong></p><p>A triangle is to be constructed with one side measuring 7 cm and the two angles at its endpoints measuring 50° and 70°. Which construction condition is used?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Triangles', 'Two angles and the included side are given, so the ASA condition is used.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'SSS', 0, 0),
(@question_id, 'SAS', 0, 0),
(@question_id, 'ASA', 1, 0),
(@question_id, 'RHS', 0, 0);

-- Geometrical Construction Topic Bank - Item 29
SET @source_marker := 'Geometrical Construction Topic Bank - Item 29';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 29</small></p><p><strong>Geometrical Construction - Question 29</strong></p><p>The locus of points equidistant from two parallel lines is</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Locus', 'A line halfway between two parallel lines is equally distant from both lines.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'A circle between the lines', 0, 0),
(@question_id, 'A line parallel to and midway between them', 1, 0),
(@question_id, 'A perpendicular bisector of either line', 0, 0),
(@question_id, 'Two intersecting lines', 0, 0);

-- Geometrical Construction Topic Bank - Item 30
SET @source_marker := 'Geometrical Construction Topic Bank - Item 30';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 30</small></p><p><strong>Geometrical Construction - Question 30</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_030.png" alt="Diagram for Geometrical Construction Question 30" style="max-width:100%;height:auto;"></p><p>In the diagram, the dashed lines are perpendicular bisectors of sides of triangle ABC and meet at O. What is special about point O?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Diagram Interpretation', 'The perpendicular bisectors of a triangle meet at the circumcentre, which is equidistant from all three vertices.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'It is equidistant from the three sides of the triangle.', 0, 0),
(@question_id, 'It is equidistant from vertices A, B and C.', 1, 0),
(@question_id, 'It divides each side in the ratio 2:1.', 0, 0),
(@question_id, 'It lies on side AB.', 0, 0);

-- Geometrical Construction Topic Bank - Item 31
SET @source_marker := 'Geometrical Construction Topic Bank - Item 31';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 31</small></p><p><strong>Geometrical Construction - Question 31</strong></p><p>Which information is sufficient to construct a rhombus uniquely?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Quadrilaterals', 'A side length and a diagonal determine the positions of the remaining vertices of a rhombus.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'One side only', 0, 0),
(@question_id, 'One angle only', 0, 0),
(@question_id, 'The length of one side and one diagonal', 1, 0),
(@question_id, 'The lengths of two adjacent equal sides only', 0, 0);

-- Geometrical Construction Topic Bank - Item 32
SET @source_marker := 'Geometrical Construction Topic Bank - Item 32';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 32</small></p><p><strong>Geometrical Construction - Question 32</strong></p><p>While constructing an angle bisector, a student draws arcs from the two arms using different compass radii. Why is the construction unreliable?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Error Detection', 'The arcs drawn from the two arms must have equal radii to locate a point equidistant from both arms.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The two arms of the angle will become parallel.', 0, 0),
(@question_id, 'The intersection of the arcs may not lie on the true angle bisector.', 1, 0),
(@question_id, 'The angle will automatically become 90°.', 0, 0),
(@question_id, 'The compass cannot be used inside an angle.', 0, 0);

-- Geometrical Construction Topic Bank - Item 33
SET @source_marker := 'Geometrical Construction Topic Bank - Item 33';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 33</small></p><p><strong>Geometrical Construction - Question 33</strong></p><p>How can an angle of 135° be constructed from a straight angle and a perpendicular line?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Construction Angles', 'The angle midway between 90° and 180° is (90° + 180°) ÷ 2 = 135°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Bisect the angle between 90° and 180°.', 1, 0),
(@question_id, 'Bisect a 60° angle.', 0, 0),
(@question_id, 'Add 30° to 60°.', 0, 0),
(@question_id, 'Bisect a straight angle twice.', 0, 0);

-- Geometrical Construction Topic Bank - Item 34
SET @source_marker := 'Geometrical Construction Topic Bank - Item 34';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 34</small></p><p><strong>Geometrical Construction - Question 34</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_034.png" alt="Diagram for Geometrical Construction Question 34" style="max-width:100%;height:auto;"></p><p>In the diagram, the three dashed lines are angle bisectors of triangle ABC and meet at I. Which statement about I is correct?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Diagram Interpretation', 'The angle bisectors of a triangle meet at the incentre, which is equidistant from the three sides.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'I is equidistant from the three vertices.', 0, 0),
(@question_id, 'I is equidistant from the three sides.', 1, 0),
(@question_id, 'I is the midpoint of AB.', 0, 0),
(@question_id, 'I lies outside every triangle.', 0, 0);

-- Geometrical Construction Topic Bank - Item 35
SET @source_marker := 'Geometrical Construction Topic Bank - Item 35';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 35</small></p><p><strong>Geometrical Construction - Question 35</strong></p><p>A circular fountain is to be placed inside a triangular park so that it is equally distant from the three boundary lines. Which point should be constructed as its centre?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Medium', 'JSS3', '', 'Application', 'The angle bisectors meet at the incentre, which is equally distant from all three sides.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The intersection of the perpendicular bisectors', 0, 0),
(@question_id, 'The intersection of the angle bisectors', 1, 0),
(@question_id, 'The midpoint of the longest side', 0, 0),
(@question_id, 'The intersection of two parallel lines', 0, 0);

-- Geometrical Construction Topic Bank - Item 36
SET @source_marker := 'Geometrical Construction Topic Bank - Item 36';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 36</small></p><p><strong>Geometrical Construction - Question 36</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_036.png" alt="Diagram for Geometrical Construction Question 36" style="max-width:100%;height:auto;"></p><p>The diagram shows rays forming 60° and 90° at O, with another ray bisecting the angle between them. What angle does the bisecting ray make with OA?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Diagram Interpretation', 'The angle halfway between 60° and 90° is (60° + 90°) ÷ 2 = 75°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, '70°', 0, 0),
(@question_id, '75°', 1, 0),
(@question_id, '80°', 0, 0),
(@question_id, '85°', 0, 0);

-- Geometrical Construction Topic Bank - Item 37
SET @source_marker := 'Geometrical Construction Topic Bank - Item 37';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 37</small></p><p><strong>Geometrical Construction - Question 37</strong></p><p>A student attempts to construct a triangle with sides 4 cm, 5 cm and 10 cm. Why will the construction fail?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Error Detection', 'For a triangle to exist, the sum of any two sides must be greater than the third side. Here, 4 + 5 < 10.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'A triangle cannot have a side measuring 10 cm.', 0, 0),
(@question_id, 'The sum of 4 cm and 5 cm is less than 10 cm.', 1, 0),
(@question_id, 'All three sides of a triangle must be equal.', 0, 0),
(@question_id, 'Only right-angled triangles can be constructed.', 0, 0);

-- Geometrical Construction Topic Bank - Item 38
SET @source_marker := 'Geometrical Construction Topic Bank - Item 38';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 38</small></p><p><strong>Geometrical Construction - Question 38</strong></p><p>To construct a tangent to a circle at a point T on its circumference, which line should first be drawn?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Circle Construction', 'The radius to the point of contact is drawn first, and the tangent is constructed perpendicular to it at T.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'A chord through T', 0, 0),
(@question_id, 'The radius joining the centre to T', 1, 0),
(@question_id, 'A diameter not passing through T', 0, 0),
(@question_id, 'A line parallel to the radius', 0, 0);

-- Geometrical Construction Topic Bank - Item 39
SET @source_marker := 'Geometrical Construction Topic Bank - Item 39';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 39</small></p><p><strong>Geometrical Construction - Question 39</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_039.png" alt="Diagram for Geometrical Construction Question 39" style="max-width:100%;height:auto;"></p><p>In the diagram, the dashed line is the perpendicular bisector of AB, while the circle has centre A. Which points satisfy both conditions of being equidistant from A and B and being a fixed distance from A?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Locus', 'P and Q lie on both the perpendicular bisector of AB and the circle centred at A.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'A and B', 0, 0),
(@question_id, 'P and Q', 1, 0),
(@question_id, 'A and P', 0, 0),
(@question_id, 'B and Q', 0, 0);

-- Geometrical Construction Topic Bank - Item 40
SET @source_marker := 'Geometrical Construction Topic Bank - Item 40';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 40</small></p><p><strong>Geometrical Construction - Question 40</strong></p><p>When constructing the perpendicular bisector of a line segment AB, a student uses a compass radius shorter than half of AB. What will most likely happen?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Error Detection', 'The compass radius must be greater than half the length of AB for the arcs from A and B to intersect above and below the segment.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The arcs from A and B will not intersect.', 1, 0),
(@question_id, 'The arcs will intersect at the midpoint only.', 0, 0),
(@question_id, 'A correct angle bisector will be formed.', 0, 0),
(@question_id, 'The line segment will be divided into three equal parts.', 0, 0);

-- Geometrical Construction Topic Bank - Item 41
SET @source_marker := 'Geometrical Construction Topic Bank - Item 41';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 41</small></p><p><strong>Geometrical Construction - Question 41</strong></p><p>Triangle ABC is to be constructed with AB = 8 cm, BC = 6 cm and ∠ABC = 70°. Which construction condition is being applied?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Triangle Construction', 'Two sides and the included angle are given, so the construction uses SAS.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'ASA', 0, 0),
(@question_id, 'SSS', 0, 0),
(@question_id, 'SAS', 1, 0),
(@question_id, 'RHS', 0, 0);

-- Geometrical Construction Topic Bank - Item 42
SET @source_marker := 'Geometrical Construction Topic Bank - Item 42';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 42</small></p><p><strong>Geometrical Construction - Question 42</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_042.png" alt="Diagram for Geometrical Construction Question 42" style="max-width:100%;height:auto;"></p><p>The diagram shows a circle with centre O and a tangent touching it at T. Which statement is always true?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Diagram Interpretation', 'A tangent to a circle is perpendicular to the radius drawn to the point of contact.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'OT is parallel to the tangent.', 0, 0),
(@question_id, 'OT is perpendicular to the tangent.', 1, 0),
(@question_id, 'OT bisects the tangent.', 0, 0),
(@question_id, 'OT is longer than the tangent.', 0, 0);

-- Geometrical Construction Topic Bank - Item 43
SET @source_marker := 'Geometrical Construction Topic Bank - Item 43';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 43</small></p><p><strong>Geometrical Construction - Question 43</strong></p><p>Which of the following is the correct first step when constructing the perpendicular bisector of a line segment AB?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Construction Procedure', 'The compass opening must be greater than half the length of AB so that the arcs intersect.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Mark the midpoint by estimation.', 0, 0),
(@question_id, 'Open the compass to a radius greater than half of AB.', 1, 0),
(@question_id, 'Measure AB with a protractor.', 0, 0),
(@question_id, 'Draw a perpendicular from A.', 0, 0);

-- Geometrical Construction Topic Bank - Item 44
SET @source_marker := 'Geometrical Construction Topic Bank - Item 44';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 44</small></p><p><strong>Geometrical Construction - Question 44</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_044.png" alt="Diagram for Geometrical Construction Question 44" style="max-width:100%;height:auto;"></p><p>In the diagram, point P is equidistant from lines l₁ and l₂. Which construction produced point P?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Diagram Interpretation', 'Every point on the angle bisector is equidistant from the two arms of the angle.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Perpendicular bisector of a line segment', 0, 0),
(@question_id, 'Angle bisector of the angle formed by l₁ and l₂', 1, 0),
(@question_id, 'Construction of a parallel line', 0, 0),
(@question_id, 'Construction of a circle', 0, 0);

-- Geometrical Construction Topic Bank - Item 45
SET @source_marker := 'Geometrical Construction Topic Bank - Item 45';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 45</small></p><p><strong>Geometrical Construction - Question 45</strong></p><p>A circle passes through vertices A, B and C of a triangle. The centre of the circle is the</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Circle Construction', 'The circumcentre is the point where the perpendicular bisectors of the sides meet and is the centre of the circumcircle.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Centroid', 0, 0),
(@question_id, 'Orthocentre', 0, 0),
(@question_id, 'Circumcentre', 1, 0),
(@question_id, 'Incentre', 0, 0);

-- Geometrical Construction Topic Bank - Item 46
SET @source_marker := 'Geometrical Construction Topic Bank - Item 46';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 46</small></p><p><strong>Geometrical Construction - Question 46</strong></p><p><img src="../uploads/question_bank/geometrical_construction/gc_046.png" alt="Diagram for Geometrical Construction Question 46" style="max-width:100%;height:auto;"></p><p>The diagram shows a triangle with a circle touching all three sides internally. The centre of the circle is point I. What is point I called?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Diagram Interpretation', 'The centre of the inscribed circle of a triangle is the incentre.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Circumcentre', 0, 0),
(@question_id, 'Centroid', 0, 0),
(@question_id, 'Orthocentre', 0, 0),
(@question_id, 'Incentre', 1, 0);

-- Geometrical Construction Topic Bank - Item 47
SET @source_marker := 'Geometrical Construction Topic Bank - Item 47';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 47</small></p><p><strong>Geometrical Construction - Question 47</strong></p><p>An engineer wants to locate a point that is exactly 5 cm from point A and also exactly 5 cm from point B. Which construction should be used?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Application', 'The required point lies at the intersection of two circles having equal radii of 5 cm centred at A and B.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Draw two circles of radius 5 cm centred at A and B.', 1, 0),
(@question_id, 'Draw the perpendicular bisector only.', 0, 0),
(@question_id, 'Draw a tangent to a circle.', 0, 0),
(@question_id, 'Construct an angle bisector.', 0, 0);

-- Geometrical Construction Topic Bank - Item 48
SET @source_marker := 'Geometrical Construction Topic Bank - Item 48';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 48</small></p><p><strong>Geometrical Construction - Question 48</strong></p><p>Which sequence of constructions can be used to obtain an angle of 15° accurately?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Construction Angles', 'Half of 30° is 15°.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'Construct 45° and bisect it.', 0, 0),
(@question_id, 'Construct 60° and bisect it.', 0, 0),
(@question_id, 'Construct 30° and bisect it.', 1, 0),
(@question_id, 'Construct 90° and bisect it.', 0, 0);

-- Geometrical Construction Topic Bank - Item 49
SET @source_marker := 'Geometrical Construction Topic Bank - Item 49';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 49</small></p><p><strong>Geometrical Construction - Question 49</strong></p><p>A student joins the intersection points of two construction arcs with one endpoint of the line segment instead of joining the two arc intersections. What is the result?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Error Detection', 'The perpendicular bisector must pass through the two arc intersection points.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'A correct perpendicular bisector is obtained.', 0, 0),
(@question_id, 'The construction is inaccurate because the required bisector is not drawn.', 1, 0),
(@question_id, 'A correct angle bisector is produced.', 0, 0),
(@question_id, 'The line segment is divided into three equal parts.', 0, 0);

-- Geometrical Construction Topic Bank - Item 50
SET @source_marker := 'Geometrical Construction Topic Bank - Item 50';
SET @existing_question_id := (SELECT id FROM question_bank WHERE source_type = 'topic' AND school_id = 0 AND subject_id = @mathematics_subject_id AND topic_id = @geometrical_construction_topic_id AND question LIKE CONCAT('%', @source_marker, '%') ORDER BY id ASC LIMIT 1);
INSERT INTO question_bank (question, subject_id, class_id, source_type, exam_body_id, exam_year, topic_id, difficulty, recommended_class, term_tag, question_category, explanation, review_status, quality_score, times_used, school_id, createdby, datecreated, deleted)
SELECT '<p><small>Source: Geometrical Construction Topic Bank - Item 50</small></p><p><strong>Geometrical Construction - Question 50</strong></p><p>A telecommunications mast is to be erected at a point that is equally distant from three villages represented by the vertices of a triangular map. Which point should be constructed?</p>', @mathematics_subject_id, 0, 'topic', 0, 0, @geometrical_construction_topic_id, 'Hard', 'JSS3', '', 'Application', 'The circumcentre is equidistant from the three vertices of a triangle.', 'approved', 0, 0, 0, 0, NOW(), 0
WHERE @existing_question_id IS NULL;
SET @question_id := COALESCE(@existing_question_id, LAST_INSERT_ID());
DELETE FROM question_bank_options WHERE question_id = @question_id;
INSERT INTO question_bank_options (question_id, options, answer, deleted) VALUES
(@question_id, 'The incentre', 0, 0),
(@question_id, 'The centroid', 0, 0),
(@question_id, 'The circumcentre', 1, 0),
(@question_id, 'The midpoint of the longest side', 0, 0);

COMMIT;

SELECT COUNT(*) AS imported_questions
FROM question_bank
WHERE source_type = 'topic'
  AND school_id = 0
  AND subject_id = @mathematics_subject_id
  AND topic_id = @geometrical_construction_topic_id
  AND question LIKE '%Geometrical Construction Topic Bank - Item%';

SELECT COUNT(*) AS imported_options
FROM question_bank_options
WHERE question_id IN (
    SELECT id
    FROM question_bank
    WHERE source_type = 'topic'
      AND school_id = 0
      AND subject_id = @mathematics_subject_id
      AND topic_id = @geometrical_construction_topic_id
      AND question LIKE '%Geometrical Construction Topic Bank - Item%'
);

SELECT COUNT(*) AS bad_option_groups
FROM (
    SELECT qb.id
    FROM question_bank qb
    LEFT JOIN question_bank_options qbo ON qbo.question_id = qb.id
    WHERE qb.source_type = 'topic'
      AND qb.school_id = 0
      AND qb.subject_id = @mathematics_subject_id
      AND qb.topic_id = @geometrical_construction_topic_id
      AND qb.question LIKE '%Geometrical Construction Topic Bank - Item%'
    GROUP BY qb.id
    HAVING COUNT(qbo.id) <> 4 OR SUM(qbo.answer = 1) <> 1
) invalid_groups;
