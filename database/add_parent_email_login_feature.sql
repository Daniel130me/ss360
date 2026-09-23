-- Enable opt-in parent email login without changing existing schools.
ALTER TABLE school
    ADD COLUMN IF NOT EXISTS parent_email_login_enabled TINYINT(1) NOT NULL DEFAULT 0
    AFTER hidden_skills;

-- Enable the feature for one school after replacing the ID:
-- UPDATE school SET parent_email_login_enabled = 1 WHERE id = YOUR_SCHOOL_ID;
