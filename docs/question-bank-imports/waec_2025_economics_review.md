# WAEC 2025 Economics Import Review

Source: myschool.ng classroom listing `https://myschool.ng/classroom/economics?exam_type=waec&exam_year=2025`
(collected via the public `api/web/v1/classroom/economics` JSON, all 12 listing
pages and every individual question page).

## Import Defaults

- Exam body: WAEC
- Exam year: 2025
- Subject: Economics
- Source type: exam_body
- Recommended class: SSS3
- Question category: Economics (generic fallback; no per-item topic invented)
- Difficulty: Medium (default; not rated from source)
- Review status: approved (matches existing exam-body imports)

## Extraction Summary

- Listing pages visited: 12 (5 questions each, 58 total)
- Individual question pages opened: 58 (plus 0 failed fetches, if any)
- Questions imported: 0
- Held for review: 58
- Duplicates detected: 50
- Images: 0 question diagram(s) downloaded from `myschool.ng/storage/classroom/`,
  verified (magic bytes + dimensions) and stored under
  `uploads/question_bank/waec_2025_economics/`; referenced with the established
  `../uploads/...` relative path.
- Answer source: the `correct_option` object on each individual question page
  (never from explanations, comments, or own calculations). Listing-page flags
  agreed with individual-page flags for all 0 imported questions.

## Notation Policy

- Source inline math `\(...\)` fragments are converted to
  `<span contenteditable="false" class="math-editor-rendered" data-latex="..."></span>`
  with MathQuill-compatible LaTeX:
  - bare sub/superscripts attach to their trailing base
    (`SO\(_2\)` -> `SO` + span `SO_{2}`; `1.33 x 10\(^{-19}\)` -> span `10^{-19}`),
    chaining consecutive fragments into one span and merging parenthesised groups;
  - complete expressions (`\frac{a}{b}`, `\sqrt{...}`, `\Omega`, `\circ`, `\mu`)
    become one span each carrying the expression;
  - HTML entities and unicode inside math fragments are translated to the LaTeX
    they denote (`&epsilon;` -> `\epsilon`, `&pi;` -> `\pi`, `₀` -> `_{0}`).
- Unicode `&nbsp;` collapsed to plain spaces; bare `<` escaped as `&lt;`;
  apostrophes stored as `&#039;` to match established records.
- No source markup was copied blindly; every produced span has balanced braces
  and a non-empty LaTeX value.

## Decisions and Flags

- Source explanations are available on myschool.ng but are community/AI
  contributed and were deliberately NOT imported (existing exam-body records
  carry empty explanations; answers come from the page's own answer flag only).
- `question_category` uses the generic subject fallback 'Economics' because
  the source provides no per-question topic; assigning syllabus topics
  would have required inventing classifications.
- Questions: 0; options: 0; exactly one `answer = 1` per question.
- Non-objective source items (theory/practical, no selectable options) cannot be
  represented in the objective question schema and are held, not dropped silently.

## Held Items

- Item 51: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77551?exam_type=waec&exam_year=2025)
- Item 52: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77553?exam_type=waec&exam_year=2025)
- Item 53: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77556?exam_type=waec&exam_year=2025)
- Item 54: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77558?exam_type=waec&exam_year=2025)
- Item 55: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77560?exam_type=waec&exam_year=2025)
- Item 56: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77564?exam_type=waec&exam_year=2025)
- Item 57: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77567?exam_type=waec&exam_year=2025)
- Item 58: 0 options (theory), correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/economics/77568?exam_type=waec&exam_year=2025)
- Item 1: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77255?exam_type=waec&exam_year=2025)
- Item 2: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77256?exam_type=waec&exam_year=2025)
- Item 3: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77257?exam_type=waec&exam_year=2025)
- Item 4: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77258?exam_type=waec&exam_year=2025)
- Item 5: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77259?exam_type=waec&exam_year=2025)
- Item 6: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77260?exam_type=waec&exam_year=2025)
- Item 7: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77261?exam_type=waec&exam_year=2025)
- Item 8: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77262?exam_type=waec&exam_year=2025)
- Item 9: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77263?exam_type=waec&exam_year=2025)
- Item 10: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77264?exam_type=waec&exam_year=2025)
- Item 11: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77265?exam_type=waec&exam_year=2025)
- Item 12: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77266?exam_type=waec&exam_year=2025)
- Item 13: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77267?exam_type=waec&exam_year=2025)
- Item 14: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77269?exam_type=waec&exam_year=2025)
- Item 15: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77270?exam_type=waec&exam_year=2025)
- Item 16: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77271?exam_type=waec&exam_year=2025)
- Item 17: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77272?exam_type=waec&exam_year=2025)
- Item 18: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77273?exam_type=waec&exam_year=2025)
- Item 19: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77275?exam_type=waec&exam_year=2025)
- Item 20: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77276?exam_type=waec&exam_year=2025)
- Item 21: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77329?exam_type=waec&exam_year=2025)
- Item 22: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77333?exam_type=waec&exam_year=2025)
- Item 23: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77338?exam_type=waec&exam_year=2025)
- Item 24: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77342?exam_type=waec&exam_year=2025)
- Item 25: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77344?exam_type=waec&exam_year=2025)
- Item 26: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77353?exam_type=waec&exam_year=2025)
- Item 27: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77358?exam_type=waec&exam_year=2025)
- Item 28: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77361?exam_type=waec&exam_year=2025)
- Item 29: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77365?exam_type=waec&exam_year=2025)
- Item 30: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77368?exam_type=waec&exam_year=2025)
- Item 31: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77372?exam_type=waec&exam_year=2025)
- Item 32: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77373?exam_type=waec&exam_year=2025)
- Item 33: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77375?exam_type=waec&exam_year=2025)
- Item 34: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77378?exam_type=waec&exam_year=2025)
- Item 35: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77382?exam_type=waec&exam_year=2025)
- Item 36: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77385?exam_type=waec&exam_year=2025)
- Item 37: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77388?exam_type=waec&exam_year=2025)
- Item 38: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77395?exam_type=waec&exam_year=2025)
- Item 39: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77398?exam_type=waec&exam_year=2025)
- Item 40: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77401?exam_type=waec&exam_year=2025)
- Item 41: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77405?exam_type=waec&exam_year=2025)
- Item 42: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77410?exam_type=waec&exam_year=2025)
- Item 43: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77414?exam_type=waec&exam_year=2025)
- Item 44: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77419?exam_type=waec&exam_year=2025)
- Item 45: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77422?exam_type=waec&exam_year=2025)
- Item 46: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77426?exam_type=waec&exam_year=2025)
- Item 47: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77429?exam_type=waec&exam_year=2025)
- Item 48: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77431?exam_type=waec&exam_year=2025)
- Item 49: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77437?exam_type=waec&exam_year=2025)
- Item 50: duplicate of existing record in question_bank (2).sql (match: source-marker) (https://myschool.ng/classroom/economics/77440?exam_type=waec&exam_year=2025)

## Potential Duplicates

- Item 1: ~source-marker match with question_bank (2).sql
- Item 2: ~source-marker match with question_bank (2).sql
- Item 3: ~source-marker match with question_bank (2).sql
- Item 4: ~source-marker match with question_bank (2).sql
- Item 5: ~source-marker match with question_bank (2).sql
- Item 6: ~source-marker match with question_bank (2).sql
- Item 7: ~source-marker match with question_bank (2).sql
- Item 8: ~source-marker match with question_bank (2).sql
- Item 9: ~source-marker match with question_bank (2).sql
- Item 10: ~source-marker match with question_bank (2).sql
- Item 11: ~source-marker match with question_bank (2).sql
- Item 12: ~source-marker match with question_bank (2).sql
- Item 13: ~source-marker match with question_bank (2).sql
- Item 14: ~source-marker match with question_bank (2).sql
- Item 15: ~source-marker match with question_bank (2).sql
- Item 16: ~source-marker match with question_bank (2).sql
- Item 17: ~source-marker match with question_bank (2).sql
- Item 18: ~source-marker match with question_bank (2).sql
- Item 19: ~source-marker match with question_bank (2).sql
- Item 20: ~source-marker match with question_bank (2).sql
- Item 21: ~source-marker match with question_bank (2).sql
- Item 22: ~source-marker match with question_bank (2).sql
- Item 23: ~source-marker match with question_bank (2).sql
- Item 24: ~source-marker match with question_bank (2).sql
- Item 25: ~source-marker match with question_bank (2).sql
- Item 26: ~source-marker match with question_bank (2).sql
- Item 27: ~source-marker match with question_bank (2).sql
- Item 28: ~source-marker match with question_bank (2).sql
- Item 29: ~source-marker match with question_bank (2).sql
- Item 30: ~source-marker match with question_bank (2).sql
- Item 31: ~source-marker match with question_bank (2).sql
- Item 32: ~source-marker match with question_bank (2).sql
- Item 33: ~source-marker match with question_bank (2).sql
- Item 34: ~source-marker match with question_bank (2).sql
- Item 35: ~source-marker match with question_bank (2).sql
- Item 36: ~source-marker match with question_bank (2).sql
- Item 37: ~source-marker match with question_bank (2).sql
- Item 38: ~source-marker match with question_bank (2).sql
- Item 39: ~source-marker match with question_bank (2).sql
- Item 40: ~source-marker match with question_bank (2).sql
- Item 41: ~source-marker match with question_bank (2).sql
- Item 42: ~source-marker match with question_bank (2).sql
- Item 43: ~source-marker match with question_bank (2).sql
- Item 44: ~source-marker match with question_bank (2).sql
- Item 45: ~source-marker match with question_bank (2).sql
- Item 46: ~source-marker match with question_bank (2).sql
- Item 47: ~source-marker match with question_bank (2).sql
- Item 48: ~source-marker match with question_bank (2).sql
- Item 49: ~source-marker match with question_bank (2).sql
- Item 50: ~source-marker match with question_bank (2).sql

## Investigator Note - Table Questions (Items 19, 20, 26, 27)

These four source items embed a data table (`<table>`) in the stem (production-cost
table; age-distribution table). The already-imported records in
`database/questionbank/question_bank (2).sql` carry the same source markers but
their stored stems have lost the table markup (cells flattened), which makes the
stored versions hard to answer from. No new rows were inserted for them (the
duplicate rule takes precedence); a small repair migration could restore table
markup on those four existing records if the owner approves - flagged here
rather than repaired silently.
