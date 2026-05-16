# Bus Tracking Test Checklist

## Access Control
- Staff from one school can only see buses, routes, assignments, trips, and locations for their own `school_id`.
- Parent requests are made with a selected `student_id`; changing the request to another student must return access denied or no bus.
- Driver location updates are accepted only from the assigned driver, assigned assistant, or transport admin staff.
- Transport management forms are visible only to staff types `1`, `2`, `3`, and `4`.

## Resource Usage
- Staff live dashboard uses `staff_snapshot`, one batched request for all visible buses.
- Parent live map uses `parent_snapshot` for the selected child and `trip_updates` with `since_id` for incremental movement.
- Normal dashboard reads use `bus_current_locations`, not the full `bus_locations` history table.
- Driver submissions are rejected or skipped when sent faster than `update_interval_seconds`, with low GPS accuracy, or with movement below `min_movement_meters`.
- Old GPS history can be cleaned with `database/bus_tracking_cleanup.sql`.

## User Experience
- Driver can start, resume GPS after reload, and stop a trip without location collection continuing in the background.
- Parents see bus identity, driver details, direction, assigned stop, live/stale status, and last update time.
- Staff see all registered school buses in a single map and table view.
- Empty states are shown when no buses, routes, stops, assignments, or parent bus assignment exists.

## Implementation Walkthrough Check
- Code is readable and grouped by responsibility: schema, helpers, backend endpoints, staff UI, parent UI, and cleanup documentation.
- Non-obvious logic is commented or named clearly, especially smart polling, permission checks, and history cleanup.
- Queries are school-scoped, indexed, and avoid loading location history for normal map refreshes.
- Defaults are configurable through `bus_tracking_settings` instead of hard-coded into the UI.
- The implementation avoids over-engineering and can be extended later for push notifications or Google Maps.
