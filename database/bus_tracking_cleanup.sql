-- Run periodically, for example weekly, to keep GPS history storage controlled.
-- Current bus positions are kept in bus_current_locations and are not affected.
DELETE bl
FROM bus_locations bl
INNER JOIN bus_tracking_settings bts ON bts.school_id = bl.school_id
WHERE bl.recorded_at < DATE_SUB(NOW(), INTERVAL bts.history_retention_days DAY);

-- Fallback for schools without an explicit settings row.
DELETE bl
FROM bus_locations bl
LEFT JOIN bus_tracking_settings bts ON bts.school_id = bl.school_id
WHERE bts.id IS NULL
AND bl.recorded_at < DATE_SUB(NOW(), INTERVAL 30 DAY);
