-- Stem self-containment repair for JAMB 2023 English Language.
-- The student interface renders each question standalone (no passage pane), so the
-- source passage/book header shown above the question on myschool.ng must live
-- inside question_bank.question itself. This file re-inserts the headers that the
-- original import dropped (intro captured in a container variant the parser did
-- not handle at collection time).
-- Idempotent: every UPDATE matches the stable source marker embedded in the row.
-- Only question_bank.question changes; options and all other columns untouched.
SET NAMES utf8mb4;


UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 3 - Question 3</small></p><p><strong>JAMB 2023 English Language - Question 3</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nDr. Samuel Johnson is also known as_____</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 3 - Question 3%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 14 - Question 14</small></p><p><strong>JAMB 2023 English Language - Question 14</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\n_________ is the euphemism use for Cheat notes.</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 14 - Question 14%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 15 - Question 15</small></p><p><strong>JAMB 2023 English Language - Question 15</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nwhy did Omar say he passed his SSCE by no means a small feat?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 15 - Question 15%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 18 - Question 18</small></p><p><strong>JAMB 2023 English Language - Question 18</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWho among Salma&#39;s roommate was reserved and withdrawn yet generous to a fault?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 18 - Question 18%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 26 - Question 26</small></p><p><strong>JAMB 2023 English Language - Question 26</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nUmmi is an Arabic word that is directly translated to mean_____</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 26 - Question 26%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 29 - Question 29</small></p><p><strong>JAMB 2023 English Language - Question 29</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nIn Lafayette, before a stranger is hosted or accommodated, permission must be requested and granted by_______</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 29 - Question 29%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 36 - Question 36</small></p><p><strong>JAMB 2023 English Language - Question 36</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nSalma was looking more stunning on the last day of her exams because_______</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 36 - Question 36%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 37 - Question 37</small></p><p><strong>JAMB 2023 English Language - Question 37</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWhy was it a double celebration for Ummi and members of her community when she gained admission into the university?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 37 - Question 37%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 49 - Question 49</small></p><p><strong>JAMB 2023 English Language - Question 49</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nAccording to the novel, which of these characters had a nasty experience on the account of using social media?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 49 - Question 49%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 51 - Question 51</small></p><p><strong>JAMB 2023 English Language - Question 51</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nBint was encouraged to take French at the primary level because _____</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 51 - Question 51%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 61 - Question 61</small></p><p><strong>JAMB 2023 English Language - Question 61</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWhat appellation was given to Talle for all his amazing show of personality.</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 61 - Question 61%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 64 - Question 64</small></p><p><strong>JAMB 2023 English Language - Question 64</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWhose reticent nature while growing up earned him the title: &quot;The quiet one&quot;.?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 64 - Question 64%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 68 - Question 68</small></p><p><strong>JAMB 2023 English Language - Question 68</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nSalma stayed at the most coveted and famous ______ hostel.</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 68 - Question 68%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 69 - Question 69</small></p><p><strong>JAMB 2023 English Language - Question 69</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWho called the attention of the district head when it was discovered that Talle buys more than he could consume from the supermarket?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 69 - Question 69%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 76 - Question 76</small></p><p><strong>JAMB 2023 English Language - Question 76</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nHow old is Bint?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 76 - Question 76%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 103 - Question 103</small></p><p><strong>JAMB 2023 English Language - Question 103</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWhat were Ummi&#39;s children waiting for when Bint narrates her encounter with Mr. Salihu?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 103 - Question 103%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 105 - Question 105</small></p><p><strong>JAMB 2023 English Language - Question 105</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWhere did the police apprehend Talle?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 105 - Question 105%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 106 - Question 106</small></p><p><strong>JAMB 2023 English Language - Question 106</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\n_____ was always on the first row during prayer at his office.</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 106 - Question 106%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 118 - Question 118</small></p><p><strong>JAMB 2023 English Language - Question 118</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nWhy did Habib call Tomiwa instead of Salma that he gave a ride?</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 118 - Question 118%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2023 English Language - Item 119 - Question 119</small></p><p><strong>JAMB 2023 English Language - Question 119</strong></p> From the novel; <strong>The Life Changer</strong><p>This question is based on &quot;The Life Changer&quot; novel.<br>\n<br>\nAda and Ngozi were from the Imo state and Benue state, while Salma and Tomiwa were from______ and ______.</p>'
WHERE question LIKE '%Source: JAMB 2023 English Language - Item 119 - Question 119%'
  AND deleted = 0;
