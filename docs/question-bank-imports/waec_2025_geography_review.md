# WAEC 2025 Geography Import Review

Source: myschool.ng classroom listing `https://myschool.ng/classroom/geography?exam_type=waec&exam_year=2025`
(collected via the public `api/web/v1/classroom/geography` JSON, all 7 listing
pages and every individual question page).

## Import Defaults

- Exam body: WAEC
- Exam year: 2025
- Subject: Geography
- Source type: exam_body
- Recommended class: SSS3
- Question category: Geography (generic fallback; no per-item topic invented)
- Difficulty: Medium (default; not rated from source)
- Review status: approved (matches existing exam-body imports)

## Extraction Summary

- Listing pages visited: 7 (5 questions each, 34 total)
- Individual question pages opened: 34 (plus 0 failed fetches, if any)
- Questions imported: 31
- Held for review: 3
- Duplicates detected: 0
- Images: 11 question diagram(s) downloaded from `myschool.ng/storage/classroom/`,
  verified (magic bytes + dimensions) and stored under
  `uploads/question_bank/waec_2025_geography/`; referenced with the established
  `../uploads/...` relative path.
- Answer images (`answer_image` from `myschool.ng/storage/classroom_answers/`):
  0 embedded after manual live-page review confirmed the stem requires
  the image.
- Answer source: the `correct_option` object on each individual question page
  (never from explanations, comments, or own calculations). Listing-page flags
  agreed with individual-page flags for all 31 imported questions.

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
- `question_category` uses the generic subject fallback 'Geography' because
  the source provides no per-question topic; assigning syllabus topics
  would have required inventing classifications.
- Questions: 31; options: 124; exactly one `answer = 1` per question.
- Non-objective source items (theory/practical, no selectable options) cannot be
  represented in the objective question schema and are held, not dropped silently.

## Held Items

- Item 2: correct flag != 1, no correct_option on individual page (https://myschool.ng/classroom/geography/77190?exam_type=waec&exam_year=2025)
- Item 4: correct flag != 1, no correct_option on individual page (https://myschool.ng/classroom/geography/77192?exam_type=waec&exam_year=2025)
- Item 16: correct flag != 1, no correct_option on individual page (https://myschool.ng/classroom/geography/77288?exam_type=waec&exam_year=2025)
