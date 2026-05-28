-- Make saved report-card formats school-wide instead of session-specific.
-- Run this once after deploying the school-wide template behavior.

UPDATE report_templates
SET session_id = NULL
WHERE school_id <> 0;
