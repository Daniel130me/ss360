-- Run once before deploying the hardened assessment editor code.
ALTER TABLE assessment
    MODIFY COLUMN class_ids VARCHAR(255) NULL,
    ADD COLUMN save_token CHAR(32) NULL AFTER round_off_decimal,
    ADD UNIQUE KEY uq_assessment_school_save_token (school_id, save_token);

ALTER TABLE questions
    ADD KEY idx_questions_assessment_deleted (ass_id, deleted);

ALTER TABLE options
    ADD KEY idx_options_question_deleted (question_id, deleted);
