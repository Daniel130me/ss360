# WAEC 2024 Accounts Import Review

Source: myschool.ng classroom listing `https://myschool.ng/classroom/accounts-principles-of-accounts?exam_type=waec&exam_year=2024`
(collected via the public `api/web/v1/classroom/accounts-principles-of-accounts` JSON, all 12 listing
pages and every individual question page).

## Import Defaults

- Exam body: WAEC
- Exam year: 2024
- Subject: Principles of Accounts (resolved from candidates: Principles of Accounts, Financial Accounting, Accounts, Accounting)
- Source type: exam_body
- Recommended class: SSS3
- Question category: Principles of Accounts (generic fallback; no per-item topic invented)
- Difficulty: Medium (default; not rated from source)
- Review status: approved (matches existing exam-body imports)

## Extraction Summary

- Listing pages visited: 12 (5 questions each, 59 total)
- Individual question pages opened: 59 (plus 0 failed fetches, if any)
- Questions imported: 49
- Held for review: 10
- Duplicates detected: 0
- Images: 0 question diagram(s) downloaded from `myschool.ng/storage/classroom/`,
  verified (magic bytes + dimensions) and stored under
  `uploads/question_bank/waec_2024_accounts/`; referenced with the established
  `../uploads/...` relative path.
- Answer source: the `correct_option` object on each individual question page
  (never from explanations, comments, or own calculations). Listing-page flags
  agreed with individual-page flags for all 49 imported questions.

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
- `question_category` uses the generic subject fallback 'Principles of Accounts' because
  the source provides no per-question topic; assigning syllabus topics
  would have required inventing classifications.
- Questions: 49; options: 196; exactly one `answer = 1` per question.
- Non-objective source items (theory/practical, no selectable options) cannot be
  represented in the objective question schema and are held, not dropped silently.

## Held Items

- Item 4: correct flag != 1, no correct_option on individual page (https://myschool.ng/classroom/accounts-principles-of-accounts/72724?exam_type=waec&exam_year=2024)
- Item 51: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72796?exam_type=waec&exam_year=2024)
- Item 52: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72797?exam_type=waec&exam_year=2024)
- Item 53: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72798?exam_type=waec&exam_year=2024)
- Item 54: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72799?exam_type=waec&exam_year=2024)
- Item 55: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72803?exam_type=waec&exam_year=2024)
- Item 56: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72805?exam_type=waec&exam_year=2024)
- Item 57: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72808?exam_type=waec&exam_year=2024)
- Item 58: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72810?exam_type=waec&exam_year=2024)
- Item 59: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/accounts-principles-of-accounts/72825?exam_type=waec&exam_year=2024)
