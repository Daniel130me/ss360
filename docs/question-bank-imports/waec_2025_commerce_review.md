# WAEC 2025 Commerce Import Review

Source: myschool.ng classroom listing `https://myschool.ng/classroom/commerce?exam_type=waec&exam_year=2025`
(collected via the public `api/web/v1/classroom/commerce` JSON, all 12 listing
pages and every individual question page).

## Import Defaults

- Exam body: WAEC
- Exam year: 2025
- Subject: Commerce
- Source type: exam_body
- Recommended class: SSS3
- Question category: Commerce (generic fallback; no per-item topic invented)
- Difficulty: Medium (default; not rated from source)
- Review status: approved (matches existing exam-body imports)

## Extraction Summary

- Listing pages visited: 12 (5 questions each, 58 total)
- Individual question pages opened: 58 (plus 0 failed fetches, if any)
- Questions imported: 47
- Held for review: 11
- Duplicates detected: 0
- Images: 0 question diagram(s) downloaded from `myschool.ng/storage/classroom/`,
  verified (magic bytes + dimensions) and stored under
  `uploads/question_bank/waec_2025_commerce/`; referenced with the established
  `../uploads/...` relative path.
- Answer source: the `correct_option` object on each individual question page
  (never from explanations, comments, or own calculations). Listing-page flags
  agreed with individual-page flags for all 47 imported questions.

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
- `question_category` uses the generic subject fallback 'Commerce' because
  the source provides no per-question topic; assigning syllabus topics
  would have required inventing classifications.
- Questions: 47; options: 188; exactly one `answer = 1` per question.
- Non-objective source items (theory/practical, no selectable options) cannot be
  represented in the objective question schema and are held, not dropped silently.

## Held Items

- Item 11: correct flag != 1 (https://myschool.ng/classroom/commerce/77482?exam_type=waec&exam_year=2025)
- Item 45: option tags not a-d: ['a', 'a', 'b', 'c'] (https://myschool.ng/classroom/commerce/77559?exam_type=waec&exam_year=2025)
- Item 47: option tags not a-d: ['a', 'b', 'c', 'c'] (https://myschool.ng/classroom/commerce/77562?exam_type=waec&exam_year=2025)
- Item 51: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77569?exam_type=waec&exam_year=2025)
- Item 52: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77570?exam_type=waec&exam_year=2025)
- Item 53: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77571?exam_type=waec&exam_year=2025)
- Item 54: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77572?exam_type=waec&exam_year=2025)
- Item 55: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77573?exam_type=waec&exam_year=2025)
- Item 56: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77574?exam_type=waec&exam_year=2025)
- Item 57: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77575?exam_type=waec&exam_year=2025)
- Item 58: 0 options (theory), option tags not a-d: [], correct flag != 1, no correct_option on individual page, type=theory (https://myschool.ng/classroom/commerce/77576?exam_type=waec&exam_year=2025)
