# Student class history deployment

This migration is non-destructive: it creates history/audit tables and indexes,
but it does not rewrite scores, comments, attendance, payments, or the current
`students.class_id` value.

## Production rollout

1. Back up the current production database.
2. Import `database/student_class_history.sql` in phpMyAdmin. It is safe to run
   before the code deployment and is repeatable.
3. Deploy the application files in the same release.
4. For the 23 September 2026 production export, import the private generated file
   `database/recovery-private/production_class_history_recovery_20260923.sql` once.
   It contains the audit evidence and only the confirmed enrolments recovered from
   that export. The directory is intentionally ignored by Git.

If command-line PHP is available, step 4 can instead be rebuilt from the current
production database:

```text
php scripts/recover_student_class_history.php --database=ss360 --write-audit --apply-confirmed
```

Supply database credentials through `SS360_DB_HOST`, `SS360_DB_PORT`,
`SS360_DB_USER`, and `SS360_DB_PASSWORD`. Do not place a password in the command
or commit it to a file.

## Review unresolved periods

Confirmed rows are applied automatically only when at least two unambiguous,
non-score sources agree. Inferred and conflicting rows remain in
`student_class_recovery_audit` for review.

To accept a reviewed proposal, set its `proposed_class_id`, `review_status` to
`accepted`, `reviewedby`, and `reviewed_at`. Then run:

```text
php scripts/recover_student_class_history.php --database=ss360 --apply-reviewed
```

The recovery script deliberately does not read the older database dump. Evidence
comes from the current database's comments, behaviour comments, attendance,
payment records, and scores. Every source gets one vote per student/session/term;
row volume does not create extra votes.

## Verification

Run:

```text
php tests/student_class_history_integration_test.php
php tests/report_score_comparison_test.php
```

For the integration test, set `SS360_TEST_DB` when the test database is not named
`ss360`.
