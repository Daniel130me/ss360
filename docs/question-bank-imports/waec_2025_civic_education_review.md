# WAEC 2025 Civic Education Review

This file records the WAEC 2025 Civic Education objective-question import review.

## Source

- File: `q_bank/WAEC_2025_Civic_Education_Objective_Questions.md`
- Exam body: WAEC
- Subject: Civic Education
- Exam year: 2025
- Intended bank source type: `exam_body`
- Intended recommended class: `SSS3`

## Parser Validation

- Total questions found: 50
- Objective MCQs found: 50
- Objective option groups found: 200
- Questions missing one or more A-D options: 1 (Question 34)
- Questions missing valid answer: 0
- Questions missing explanations: 0
- Image-dependent questions: 4, 5, 30, 31
- Migration file: `database/waec_2025_civic_education_question_bank.sql`

## Image Notes

- The source marks questions 4, 5, 30, 31 as containing images, but no image asset files were supplied with the Markdown.
- The migration keeps those questions but adds a visible missing-diagram note to avoid confusing teachers and students.
- If the image assets are later supplied, update those four question bodies to replace the note with the proper `<img>` tag.

## Option Notes

- Question 34 is missing option B in the source file. It is imported with `[Missing option in source file]` as option B while preserving the supplied correct answer, option D.

## Category Distribution

- Nationalism: 1
- Rule of Law: 2
- Civil Society: 1
- Road Safety: 4
- Citizenship: 1
- Human Rights: 3
- Interpersonal Relationships: 1
- Cultism: 3
- Civic Education: 13
- Political Participation: 6
- Responsible Parenthood: 2
- Communal Relationships: 4
- Drug Abuse: 7
- Youth Empowerment: 2

## Formatting Notes

- Shared statements, dialogues, and stories were split into readable paragraphs where the source text had run-on extraction.
- Correct answers and source explanations were preserved.
- The migration is repeat-safe and uses stable source markers in the question body.
