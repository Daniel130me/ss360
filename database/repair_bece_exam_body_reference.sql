-- Restore the BECE exam-body record and reconnect any orphaned BECE questions.
-- The repair resolves the ID by name, so it is safe when IDs differ by database.

START TRANSACTION;

INSERT INTO exam_bodies (name, description)
SELECT 'BECE', 'Basic Education Certificate Examination'
WHERE NOT EXISTS (
    SELECT 1
    FROM exam_bodies
    WHERE UPPER(TRIM(name)) = 'BECE'
);

SET @bece_exam_body_id := (
    SELECT id
    FROM exam_bodies
    WHERE UPPER(TRIM(name)) = 'BECE'
    ORDER BY id ASC
    LIMIT 1
);

UPDATE question_bank q
LEFT JOIN exam_bodies current_exam_body ON current_exam_body.id = q.exam_body_id
SET q.exam_body_id = @bece_exam_body_id
WHERE q.source_type = 'exam_body'
  AND current_exam_body.id IS NULL
  AND q.question LIKE '%BECE %';

COMMIT;
