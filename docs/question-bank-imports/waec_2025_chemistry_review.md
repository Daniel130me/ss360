# WAEC 2025 Chemistry Import Review

Source: myschool.ng classroom listing `https://myschool.ng/classroom/chemistry?exam_type=waec&exam_year=2025`
(collected via the public page payload / `api/web/v1/classroom/chemistry` JSON, all 50 listing pages and every individual question page).

## Import Defaults

- Exam body: WAEC
- Exam year: 2025
- Subject: Chemistry
- Source type: exam_body
- Recommended class: SSS3
- Question category: Chemistry (generic fallback; no per-item topic invented)
- Difficulty: Medium (default; not rated from source)
- Review status: approved (matches existing exam-body imports)

## Extraction Summary

- Listing pages visited: 10 (5 questions each, 50 total)
- Individual question pages opened: 50
- Questions imported: 50
- Held for review: 0
- Duplicates detected: 0
- Images: the source set contains no diagram questions (checked stems, options,
  `image`/`answer_image`/`editor_images` fields and text references to
  diagrams/figures); no files were downloaded.
- Answer source: the `correct_option` object on each individual question page
  (never from explanations, comments, or own calculations). Listing-page flags
  agreed with individual-page flags for all 50 questions.

## Notation Policy

- Source inline math `\(...\)` fragments are converted to
  `<span contenteditable="false" class="math-editor-rendered" data-latex="..."></span>`
  with MathQuill-compatible LaTeX, e.g. `SO\(_2\)` -> `SO` + span `SO_{2}`;
  `NH\(_4\)\(^{+}\)` -> one span `NH_{4}^{+}`;
  `(NH\(_4\))\(_2\)CO\(_3\)` -> span `(NH_{4})_{2}` + `CO` + span `CO_{3}`.
- Unicode `&nbsp;` collapsed to plain spaces; bare `<` escaped as `&lt;`;
  apostrophes stored as `&#039;` to match established records.
- No source markup was copied blindly; every produced span has balanced braces
  and a non-empty, base-attached LaTeX value.

## Decisions and Flags

- Source explanations are available on myschool.ng but are community/AI
  contributed and were deliberately NOT imported (existing exam-body records
  carry empty explanations; answers come from the page's own answer flag only).
- `question_category` uses the generic subject fallback 'Chemistry' because
  the source provides no per-question topic; assigning WAEC syllabus topics
  would have required inventing classifications.
- Questions: 50; options: 200; exactly one `answer = 1` per question.

## Rendering Verification (performed)

- All 50 distinct `data-latex` values were rendered in a headless browser using
  the application's own MathJax pipeline (the `student_practice.php`
  `normalizeStoredMathSpans()` path, which reads `data-latex` from
  `span.math-editor-rendered`): 50/50 rendered, 0 math errors.
- Full end-to-end render of all 50 stored questions (stems + options):
  94 math containers, 0 errors. Screenshots:
  `download/waec_2025_chemistry_math_render_check.png` (all 50 latex values)
  and `download/waec_2025_chemistry_e2e_sample.png` (rendered questions).
- MathQuill 0.10.1 (the editor-side renderer in `dist/js/examination.js`)
  could not be loaded in the sandbox's Chromium (the 0.10.1 CDN build throws
  a pre-existing JS incompatibility in modern Chromium, independent of this
  import). All values used are a strict subset of the MathQuill grammar
  already present in previously imported working records (`10^{-4}`,
  `\frac{3}{10}`, `log_{2}a =`), consisting only of letters, digits,
  `_`/`^{...}` sub/superscripts and `\Delta`, so MathQuill compatibility is
  inherited from those records. Recommend a one-time spot check in the live
  admin UI before publishing to students.

## Structural Validation (performed)

- 50 question blocks, 200 option rows, unique source markers, balanced
  transaction, guard procedure present.
- Per question: exactly 4 options, exactly one `answer = 1`, flag position
  matches the individual page's `correct_option` tag, option order a-d
  preserved.
- SQL literal round-trip (escape/unescape) verified for every question and
  option; visible text of every option/stem matches the source content
  token-for-token; no leftover `\(...\)` delimiters, `&nbsp;`, or empty latex.
- No image references (source set has no diagrams); no hardcoded
  subject/exam-body IDs (resolved by name at run time).
