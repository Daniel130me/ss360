-- Stem self-containment repair for JAMB 2025 English Language.
-- The student interface renders each question standalone (no passage pane), so the
-- source passage/book header shown above the question on myschool.ng must live
-- inside question_bank.question itself. This file re-inserts the headers that the
-- original import dropped (intro captured in a container variant the parser did
-- not handle at collection time).
-- Idempotent: every UPDATE matches the stable source marker embedded in the row.
-- Only question_bank.question changes; options and all other columns untouched.
SET NAMES utf8mb4;


UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 1 - Question 1</small></p><p><strong>JAMB 2025 English Language - Question 1</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the common ritual at the morning assembly at Stardom on Tuesdays and Thusdays?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 1 - Question 1%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 2 - Question 2</small></p><p><strong>JAMB 2025 English Language - Question 2</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How much was the boarding house fee per session at Stardom before it was reduced?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 2 - Question 2%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 3 - Question 3</small></p><p><strong>JAMB 2025 English Language - Question 3</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who instructed the Chemistry teacher to conclude the assembly after Mr Bepo burst into tears?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 3 - Question 3%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 4 - Question 4</small></p><p><strong>JAMB 2025 English Language - Question 4</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did the Vice Principal contact the MD after Mr Bepo&rsquo;s crying incident at the assembly?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 4 - Question 4%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 5 - Question 5</small></p><p><strong>JAMB 2025 English Language - Question 5</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>The principal was nicknamed &quot;The Lekki Headmaster&quot; because...</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 5 - Question 5%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 6 - Question 6</small></p><p><strong>JAMB 2025 English Language - Question 6</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which teachers were reprimanded because two of their candidates had Ds in their subjects?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 6 - Question 6%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 7 - Question 7</small></p><p><strong>JAMB 2025 English Language - Question 7</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who among the staff at Stardom School is also a pastor?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 7 - Question 7%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 8 - Question 8</small></p><p><strong>JAMB 2025 English Language - Question 8</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was given as a reward to teachers whose students scored distinctions in their subjects?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 8 - Question 8%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 9 - Question 9</small></p><p><strong>JAMB 2025 English Language - Question 9</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did the MD decide to send the principal home after the crying incident?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 9 - Question 9%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 10 - Question 10</small></p><p><strong>JAMB 2025 English Language - Question 10</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who accompanied the principal to his home on the day of the crying incident?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 10 - Question 10%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 11 - Question 11</small></p><p><strong>JAMB 2025 English Language - Question 11</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the student Ikenna Egbu&rsquo;s speech about?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 11 - Question 11%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 12 - Question 12</small></p><p><strong>JAMB 2025 English Language - Question 12</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why is Mr. Bepo reluctant to relocate to the United Kingdom?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 12 - Question 12%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 13 - Question 13</small></p><p><strong>JAMB 2025 English Language - Question 13</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What trait earned Mr. Bepo the nickname &ldquo;The Lekki Headmaster&rdquo;?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 13 - Question 13%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 14 - Question 14</small></p><p><strong>JAMB 2025 English Language - Question 14</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who coined the nickname &ldquo;The Lekki Headmaster&rdquo;?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 14 - Question 14%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 15 - Question 15</small></p><p><strong>JAMB 2025 English Language - Question 15</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How much does Seri earn monthly as a nurse in the United Kingdom?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 15 - Question 15%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 16 - Question 16</small></p><p><strong>JAMB 2025 English Language - Question 16</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was Mr. Bepo&rsquo;s monthly salary at Stardom Schools?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 16 - Question 16%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 17 - Question 17</small></p><p><strong>JAMB 2025 English Language - Question 17</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why do Mr. Bepo&rsquo;s colleagues find his reluctance to relocate amusing?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 17 - Question 17%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 18 - Question 18</small></p><p><strong>JAMB 2025 English Language - Question 18</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did the Fruitful Future school fail?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 18 - Question 18%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 19 - Question 19</small></p><p><strong>JAMB 2025 English Language - Question 19</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which factor makes Mr. Bepo cautious about entering the commercial transportation business?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 19 - Question 19%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 20 - Question 20</small></p><p><strong>JAMB 2025 English Language - Question 20</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What does the term <em>roforofos </em>that Mr Audu used when talking about Mr Bepo most likely refer to?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 20 - Question 20%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 21 - Question 21</small></p><p><strong>JAMB 2025 English Language - Question 21</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What does Mr. Bepo&rsquo;s reluctance to relocate reveal about his values?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 21 - Question 21%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 22 - Question 22</small></p><p><strong>JAMB 2025 English Language - Question 22</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>According to Bepo, why is the hourly payment system beneficial?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 22 - Question 22%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 23 - Question 23</small></p><p><strong>JAMB 2025 English Language - Question 23</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>According to the novel, what is the approximate annual migration rate of Nigerian doctors?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 23 - Question 23%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 24 - Question 24</small></p><p><strong>JAMB 2025 English Language - Question 24</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What unethical act did Mr. Nku engage in before relocating abroad?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 24 - Question 24%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 25 - Question 25</small></p><p><strong>JAMB 2025 English Language - Question 25</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did one of the school drivers attempt to sell the school bus?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 25 - Question 25%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 26 - Question 26</small></p><p><strong>JAMB 2025 English Language - Question 26</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>According to the novel, why do most Nigerians prefer relocating to the UK?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 26 - Question 26%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 27 - Question 27</small></p><p><strong>JAMB 2025 English Language - Question 27</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What proverb does Bepo recall from his Idoma co-tenant?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 27 - Question 27%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 28 - Question 28</small></p><p><strong>JAMB 2025 English Language - Question 28</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What lesson does Hope&rsquo;s story about relocating to the UK teach?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 28 - Question 28%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 29 - Question 29</small></p><p><strong>JAMB 2025 English Language - Question 29</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How much did Sola and her husband borrow to fund their relocation?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 29 - Question 29%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 30 - Question 30</small></p><p><strong>JAMB 2025 English Language - Question 30</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Where does Bepo live?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 30 - Question 30%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 31 - Question 31</small></p><p><strong>JAMB 2025 English Language - Question 31</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why does Mr Ignatius want to relocate with his family?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 31 - Question 31%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 32 - Question 32</small></p><p><strong>JAMB 2025 English Language - Question 32</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What skill did Mrs Ignatius begin learning to support her family abroad?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 32 - Question 32%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 33 - Question 33</small></p><p><strong>JAMB 2025 English Language - Question 33</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What disrupted the Ignatius family&#39;s relocation plans?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 33 - Question 33%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 34 - Question 34</small></p><p><strong>JAMB 2025 English Language - Question 34</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why was Mr Ayesoro transferred from his teaching role?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 34 - Question 34%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 35 - Question 35</small></p><p><strong>JAMB 2025 English Language - Question 35</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What nickname did students give to Mr Ayesoro because of his tribal marks?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 35 - Question 35%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 36 - Question 36</small></p><p><strong>JAMB 2025 English Language - Question 36</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did the school transfer Mr Ayesoro to Stardom Hub?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 36 - Question 36%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 37 - Question 37</small></p><p><strong>JAMB 2025 English Language - Question 37</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What does the MD discover about the land Stardom acquired two years ago?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 37 - Question 37%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 38 - Question 38</small></p><p><strong>JAMB 2025 English Language - Question 38</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How are the teachers and staff at Stardom able to afford cars?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 38 - Question 38%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 39 - Question 39</small></p><p><strong>JAMB 2025 English Language - Question 39</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How much money is in the account of the Stardom Cooperative Society, as discovered by the board?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 39 - Question 39%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 40 - Question 40</small></p><p><strong>JAMB 2025 English Language - Question 40</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What simile does the Chairman use to describe the potential risk of the cooperative funds?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 40 - Question 40%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 41 - Question 41</small></p><p><strong>JAMB 2025 English Language - Question 41</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What decision does the board make about loans from the cooperative?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 41 - Question 41%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 42 - Question 42</small></p><p><strong>JAMB 2025 English Language - Question 42</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>&nbsp;Why do some teachers at Stardom Schools dread Open Day?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 42 - Question 42%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 43 - Question 43</small></p><p><strong>JAMB 2025 English Language - Question 43</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What did Mr Guta demand in the MD&rsquo;s office regarding Mr Fafore?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 43 - Question 43%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 44 - Question 44</small></p><p><strong>JAMB 2025 English Language - Question 44</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why does the school no longer allow students to copy notes from the Class Prefect?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 44 - Question 44%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 45 - Question 45</small></p><p><strong>JAMB 2025 English Language - Question 45</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What reason did Mr Guta give for being angry with Mr Fafore?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 45 - Question 45%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 46 - Question 46</small></p><p><strong>JAMB 2025 English Language - Question 46</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What grammatical rule was the source of disagreement between the MD and the principal?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 46 - Question 46%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 47 - Question 47</small></p><p><strong>JAMB 2025 English Language - Question 47</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What did Mr Audu do after the MD felt deflated that she had wrongly sacked Mr Fafore?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 47 - Question 47%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 48 - Question 48</small></p><p><strong>JAMB 2025 English Language - Question 48</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What conclusion did the teachers draw from Mr Fafore&#39;s sack incident?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 48 - Question 48%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 49 - Question 49</small></p><p><strong>JAMB 2025 English Language - Question 49</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did Bepo leave Beesway Group of School?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 49 - Question 49%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 50 - Question 50</small></p><p><strong>JAMB 2025 English Language - Question 50</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What grammatical issue did Bepo raise about Beesway Group of School&#39;s&nbsp;name?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 50 - Question 50%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 51 - Question 51</small></p><p><strong>JAMB 2025 English Language - Question 51</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did the director of &quot;Beesway Group of School&quot;&nbsp;claim the ritual involving the cow was necessary?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 51 - Question 51%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 52 - Question 52</small></p><p><strong>JAMB 2025 English Language - Question 52</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What led to the closure of the school Bepo started?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 52 - Question 52%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 53 - Question 53</small></p><p><strong>JAMB 2025 English Language - Question 53</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the cost of the form for the position of Head Boy or Head Girl in the school election at Stardom?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 53 - Question 53%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 54 - Question 54</small></p><p><strong>JAMB 2025 English Language - Question 54</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What inappropriate remark did Banky make during Speech Day?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 54 - Question 54%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 55 - Question 55</small></p><p><strong>JAMB 2025 English Language - Question 55</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why was Tosh&#39;s father, Chief Ogba, detained for 36 months?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 55 - Question 55%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 56 - Question 56</small></p><p><strong>JAMB 2025 English Language - Question 56</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which of the following waterfalls is the highest in West Africa, according to the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 56 - Question 56%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 57 - Question 57</small></p><p><strong>JAMB 2025 English Language - Question 57</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the primary reason Mr Bepo organises excursions for the students at Stardom?&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 57 - Question 57%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 58 - Question 58</small></p><p><strong>JAMB 2025 English Language - Question 58</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which of the following festivals have the students attended?&nbsp;</p>\n\n<p>i. Calabar&nbsp;Carnival</p>\n\n<p>ii. Osun Oshogbo Festival</p>\n\n<p>iii. Argungu Festival</p>\n\n<p>iv. Abuja Carnival</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 58 - Question 58%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 59 - Question 59</small></p><p><strong>JAMB 2025 English Language - Question 59</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How did Mr Bepo inspire students after they visited areas like Mushin and Ajegunle&nbsp;during their excursions?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 59 - Question 59%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 60 - Question 60</small></p><p><strong>JAMB 2025 English Language - Question 60</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the source of the name &quot;Badagry&quot;,&nbsp;according to the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 60 - Question 60%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 61 - Question 61</small></p><p><strong>JAMB 2025 English Language - Question 61</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What does Mr Bepo mean by the term &quot;new slavery&quot;?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 61 - Question 61%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 62 - Question 62</small></p><p><strong>JAMB 2025 English Language - Question 62</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why was Mr Bepo moved during his visit to the Black Heritage Museum?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 62 - Question 62%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 63 - Question 63</small></p><p><strong>JAMB 2025 English Language - Question 63</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the meaning of the term &quot;japa&quot; as used in the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 63 - Question 63%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 64 - Question 64</small></p><p><strong>JAMB 2025 English Language - Question 64</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why was Mr Bepo initially reluctant to renew his passport?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 64 - Question 64%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 65 - Question 65</small></p><p><strong>JAMB 2025 English Language - Question 65</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How much was the official fee for a 10-year passport renewal (64 pages)?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 65 - Question 65%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 66 - Question 66</small></p><p><strong>JAMB 2025 English Language - Question 66</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did Bepo choose Ibadan for his passport renewal?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 66 - Question 66%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 67 - Question 67</small></p><p><strong>JAMB 2025 English Language - Question 67</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What can be inferred about Tai&#39;s role in the passport renewal process?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 67 - Question 67%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 68 - Question 68</small></p><p><strong>JAMB 2025 English Language - Question 68</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What does the phrase &quot;in cahoots&quot; most likely mean in the context of Tai and the immigration staff?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 68 - Question 68%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 69 - Question 69</small></p><p><strong>JAMB 2025 English Language - Question 69</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why does Mr Bepo delay his flight to the UK?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 69 - Question 69%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 70 - Question 70</small></p><p><strong>JAMB 2025 English Language - Question 70</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What Yoruba adage does Mr Bepo recall after the debate at the farewell celebration?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 70 - Question 70%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 71 - Question 71</small></p><p><strong>JAMB 2025 English Language - Question 71</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why does Mr Bepo yell &quot;Noooo!&quot; during the drama club performance at the farewell celebration?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 71 - Question 71%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 72 - Question 72</small></p><p><strong>JAMB 2025 English Language - Question 72</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the farewell gift presented to Mr Bepo?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 72 - Question 72%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 73 - Question 73</small></p><p><strong>JAMB 2025 English Language - Question 73</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>At what time is Mr Bepo&#39;s flight to the UK scheduled to depart?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 73 - Question 73%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 74 - Question 74</small></p><p><strong>JAMB 2025 English Language - Question 74</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who offers to drive Mr Bepo to the airport?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 74 - Question 74%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 75 - Question 75</small></p><p><strong>JAMB 2025 English Language - Question 75</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What did Mr Bepo&#39;s wife insist he should pack for his trip&nbsp;to the UK?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 75 - Question 75%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 76 - Question 76</small></p><p><strong>JAMB 2025 English Language - Question 76</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the primary setting of&nbsp;<em>The Lekki Headmaster</em>?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 76 - Question 76%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 77 - Question 77</small></p><p><strong>JAMB 2025 English Language - Question 77</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who is the protagonist of the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 77 - Question 77%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 78 - Question 78</small></p><p><strong>JAMB 2025 English Language - Question 78</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is Mr Bepo&#39;s profession?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 78 - Question 78%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 79 - Question 79</small></p><p><strong>JAMB 2025 English Language - Question 79</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the main&nbsp;challenge that Mr Bepo faces in the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 79 - Question 79%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 80 - Question 80</small></p><p><strong>JAMB 2025 English Language - Question 80</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What theme is predominantly explored in the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 80 - Question 80%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 81 - Question 81</small></p><p><strong>JAMB 2025 English Language - Question 81</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which teacher is known for the use of witty remarks in the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 81 - Question 81%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 82 - Question 82</small></p><p><strong>JAMB 2025 English Language - Question 82</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which two students have a rivalry that dates back to JSS 3?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 82 - Question 82%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 83 - Question 83</small></p><p><strong>JAMB 2025 English Language - Question 83</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>The novel explores the effects of migration under which term?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 83 - Question 83%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 84 - Question 84</small></p><p><strong>JAMB 2025 English Language - Question 84</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What led to the conflict during the prefect election speech?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 84 - Question 84%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 85 - Question 85</small></p><p><strong>JAMB 2025 English Language - Question 85</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What project was the school&#39;s Invention&nbsp;Club working on?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 85 - Question 85%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 86 - Question 86</small></p><p><strong>JAMB 2025 English Language - Question 86</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What significant historical location did the students visit in Badagry?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 86 - Question 86%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 87 - Question 87</small></p><p><strong>JAMB 2025 English Language - Question 87</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What tourist attractions in Bauchi did the students explore?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 87 - Question 87%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 88 - Question 88</small></p><p><strong>JAMB 2025 English Language - Question 88</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the major challenge that Bepo faced during his NIN validation?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 88 - Question 88%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 89 - Question 89</small></p><p><strong>JAMB 2025 English Language - Question 89</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What performances during the send-off caused Bepo to become deeply emotional?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 89 - Question 89%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 90 - Question 90</small></p><p><strong>JAMB 2025 English Language - Question 90</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What year was the Ikogosi Warm Sprigs discovered?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 90 - Question 90%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 91 - Question 91</small></p><p><strong>JAMB 2025 English Language - Question 91</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What lesson does the novel teach about migration?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 91 - Question 91%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 92 - Question 92</small></p><p><strong>JAMB 2025 English Language - Question 92</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was Bepo&#39;s relationship with Mrs Ibidun Gloss?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 92 - Question 92%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 93 - Question 93</small></p><p><strong>JAMB 2025 English Language - Question 93</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What caused Mr Bepo&#39;s emotional breakdown during the school assembly?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 93 - Question 93%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 94 - Question 94</small></p><p><strong>JAMB 2025 English Language - Question 94</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the boarding fee per session at Stardom Schools?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 94 - Question 94%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 95 - Question 95</small></p><p><strong>JAMB 2025 English Language - Question 95</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why was the boarding fee&nbsp;at Stardom Schools reduced?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 95 - Question 95%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 96 - Question 96</small></p><p><strong>JAMB 2025 English Language - Question 96</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>The theme central to the novel is</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 96 - Question 96%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 97 - Question 97</small></p><p><strong>JAMB 2025 English Language - Question 97</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How does&nbsp;<em>The Lekki Headmaster&nbsp;</em>portray the issue of &quot;Japa&quot;?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 97 - Question 97%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 98 - Question 98</small></p><p><strong>JAMB 2025 English Language - Question 98</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the central physical setting of the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 98 - Question 98%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 99 - Question 99</small></p><p><strong>JAMB 2025 English Language - Question 99</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which setting in the novel serves as a point of psychological conflict for Bepo?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 99 - Question 99%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 100 - Question 100</small></p><p><strong>JAMB 2025 English Language - Question 100</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What narrative technique is commonly used in&nbsp;<em>The Lekki Headmaster?</em></p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 100 - Question 100%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 101 - Question 101</small></p><p><strong>JAMB 2025 English Language - Question 101</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was Mr Bepo&#39;s long-term professional goal before considering migration?&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 101 - Question 101%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 102 - Question 102</small></p><p><strong>JAMB 2025 English Language - Question 102</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What does Chief Ogba demand after his son, Tosh, is publicly insulted?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 102 - Question 102%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 103 - Question 103</small></p><p><strong>JAMB 2025 English Language - Question 103</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How does the novel use irony to critique migration?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 103 - Question 103%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 104 - Question 104</small></p><p><strong>JAMB 2025 English Language - Question 104</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why does the MD call an emergency meeting after discovering the cars at the school&#39;s land?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 104 - Question 104%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 105 - Question 105</small></p><p><strong>JAMB 2025 English Language - Question 105</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who makes up the board of Stardom Schools?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 105 - Question 105%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 106 - Question 106</small></p><p><strong>JAMB 2025 English Language - Question 106</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What did Bepo do before meeting with the director of Beesway&nbsp;the morning after he encountered the ritual practice?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 106 - Question 106%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 107 - Question 107</small></p><p><strong>JAMB 2025 English Language - Question 107</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which poem came to Bepo&#39;s mind on his way to renew his passport?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 107 - Question 107%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 108 - Question 108</small></p><p><strong>JAMB 2025 English Language - Question 108</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was Mr. Fafore&rsquo;s strategy to ensure that he came early to school even though he lives far away?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 108 - Question 108%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 109 - Question 109</small></p><p><strong>JAMB 2025 English Language - Question 109</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which of the following is NOT one of Bepo&#39;s ideas about teaching?&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 109 - Question 109%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 110 - Question 110</small></p><p><strong>JAMB 2025 English Language - Question 110</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did Bepo choose to renew his passport in Ibadan?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 110 - Question 110%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 111 - Question 111</small></p><p><strong>JAMB 2025 English Language - Question 111</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did Stardom School stop the usual democratic election process for prefects?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 111 - Question 111%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 112 - Question 112</small></p><p><strong>JAMB 2025 English Language - Question 112</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did Bepo spend the electricity tariff money he collected from his tenants?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 112 - Question 112%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 113 - Question 113</small></p><p><strong>JAMB 2025 English Language - Question 113</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>The following were hairstyles that Mrs Ignatius learnt in preparation for her migration abroad except</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 113 - Question 113%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 114 - Question 114</small></p><p><strong>JAMB 2025 English Language - Question 114</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What did Bepo&#39;s&nbsp;fellow tenant, Iya Matthew,&nbsp;pour on his head after he had embezzled the compound&#39;s electricity tariff?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 114 - Question 114%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 115 - Question 115</small></p><p><strong>JAMB 2025 English Language - Question 115</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the topic of the debate at Bepo&#39;s send-off?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 115 - Question 115%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 116 - Question 116</small></p><p><strong>JAMB 2025 English Language - Question 116</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What eventually happened to Mr Ogo in the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 116 - Question 116%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 117 - Question 117</small></p><p><strong>JAMB 2025 English Language - Question 117</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>According to the novel, the Gurara Waterfall&nbsp;was actually discovered in which year?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 117 - Question 117%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 118 - Question 118</small></p><p><strong>JAMB 2025 English Language - Question 118</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>According to the novel, who built the first-storey&nbsp;building in Nigeria?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 118 - Question 118%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 119 - Question 119</small></p><p><strong>JAMB 2025 English Language - Question 119</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What does Bepo mean by the term &quot;new slavery&quot;?&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 119 - Question 119%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 120 - Question 120</small></p><p><strong>JAMB 2025 English Language - Question 120</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the name of the passport office that Bepo plans to visit to renew his passport?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 120 - Question 120%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 121 - Question 121</small></p><p><strong>JAMB 2025 English Language - Question 121</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was inscribed on the banner at Bepo&#39;s send-off?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 121 - Question 121%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 122 - Question 122</small></p><p><strong>JAMB 2025 English Language - Question 122</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What position did Bepo apply for when he first came to Stardom Schools?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 122 - Question 122%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 123 - Question 123</small></p><p><strong>JAMB 2025 English Language - Question 123</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Who did Bepo sell his car to as he planned to relocate?&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 123 - Question 123%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 124 - Question 124</small></p><p><strong>JAMB 2025 English Language - Question 124</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>How much did Bepo give his landlord&#39;s children as he left for the airport?&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 124 - Question 124%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 125 - Question 125</small></p><p><strong>JAMB 2025 English Language - Question 125</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What course did Bepo study at the University of Benin?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 125 - Question 125%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 126 - Question 126</small></p><p><strong>JAMB 2025 English Language - Question 126</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What subject was Sola teaching at Stardom Schools before she relocated to the UK?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 126 - Question 126%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 127 - Question 127</small></p><p><strong>JAMB 2025 English Language - Question 127</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which historical figure, according to the novel, translated the Bible into Yoruba?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 127 - Question 127%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 128 - Question 128</small></p><p><strong>JAMB 2025 English Language - Question 128</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What literary device is used in the expression &quot;under the world of tears&quot;?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 128 - Question 128%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 129 - Question 129</small></p><p><strong>JAMB 2025 English Language - Question 129</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was the mood at the beginning of the story when the principal walks to the podium?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 129 - Question 129%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 130 - Question 130</small></p><p><strong>JAMB 2025 English Language - Question 130</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>When Mr. Audu says, &quot;the MD is a witch and wizard rolled into one!&quot;, what figure of speech is this?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 130 - Question 130%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 131 - Question 131</small></p><p><strong>JAMB 2025 English Language - Question 131</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>&quot;You could see a rock carrying three other rocks on its head.&quot; What literary technique is being used?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 131 - Question 131%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 132 - Question 132</small></p><p><strong>JAMB 2025 English Language - Question 132</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What attitude do most teachers display towards Bepo&#39;s reluctance to relocate?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 132 - Question 132%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 133 - Question 133</small></p><p><strong>JAMB 2025 English Language - Question 133</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did the students expect comments from the principal after Ikenna&#39;s speech?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 133 - Question 133%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 134 - Question 134</small></p><p><strong>JAMB 2025 English Language - Question 134</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why is Jos described as &quot;acrobatic&quot; in Ikenna&#39;s speech?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 134 - Question 134%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 135 - Question 135</small></p><p><strong>JAMB 2025 English Language - Question 135</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What figure of speech is used in &ldquo;...the microphone dropped on the floor, sending a vexatious clatter out of the twin sound boxes&rdquo;?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 135 - Question 135%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 136 - Question 136</small></p><p><strong>JAMB 2025 English Language - Question 136</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>The overall tone of the story can be described as&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 136 - Question 136%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 137 - Question 137</small></p><p><strong>JAMB 2025 English Language - Question 137</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why did Mr. Bepo finally decide to leave Nigeria?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 137 - Question 137%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 138 - Question 138</small></p><p><strong>JAMB 2025 English Language - Question 138</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What was unique about Bepo&rsquo;s initial job interview at Stardom?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 138 - Question 138%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 139 - Question 139</small></p><p><strong>JAMB 2025 English Language - Question 139</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What is the name of the director of Beesway Group of School?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 139 - Question 139%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 140 - Question 140</small></p><p><strong>JAMB 2025 English Language - Question 140</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What shocking behaviour did a UK student allegedly exhibit toward a Nigerian teacher, according to the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 140 - Question 140%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 141 - Question 141</small></p><p><strong>JAMB 2025 English Language - Question 141</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What gesture impressed Sola when her daughter Betty was hospitalised in the UK?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 141 - Question 141%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 142 - Question 142</small></p><p><strong>JAMB 2025 English Language - Question 142</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What kind of job did Akindele, the older Nigerian migrant, do when he first arrived&nbsp;in the US?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 142 - Question 142%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 143 - Question 143</small></p><p><strong>JAMB 2025 English Language - Question 143</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What figure of speech is used in the expression &quot;...wouldn&#39;t have to clean &#39;dishes&#39;, as folks uncharitably say about washing corpses.&quot;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 143 - Question 143%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 144 - Question 144</small></p><p><strong>JAMB 2025 English Language - Question 144</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What city did Sola and her husband settle in within the UK?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 144 - Question 144%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 145 - Question 145</small></p><p><strong>JAMB 2025 English Language - Question 145</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What career did Bepo&#39;s wife Seri practice abroad?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 145 - Question 145%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 146 - Question 146</small></p><p><strong>JAMB 2025 English Language - Question 146</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>&ldquo;Tears trickled out of his eyes&hellip; More tears streamed from both eyes, competitively&hellip;&rdquo; is an example of&mdash;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 146 - Question 146%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 147 - Question 147</small></p><p><strong>JAMB 2025 English Language - Question 147</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>&ldquo;He brought his palms together like a supplicant&rdquo; is an example of&mdash;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 147 - Question 147%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 148 - Question 148</small></p><p><strong>JAMB 2025 English Language - Question 148</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>The Yoruba proverb &quot;The Oyingbo market never finds out a certain person did not even turn up&quot; means</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 148 - Question 148%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 150 - Question 150</small></p><p><strong>JAMB 2025 English Language - Question 150</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Why does the narrator employ a conversational tone in the narration of Bepo&#39;s story?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 150 - Question 150%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 151 - Question 151</small></p><p><strong>JAMB 2025 English Language - Question 151</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>When the director of Beesway&nbsp;references&nbsp;the Yoruba proverb about vegetables plucked from a dumpsite, what was he trying to communicate to Bepo?&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 151 - Question 151%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 152 - Question 152</small></p><p><strong>JAMB 2025 English Language - Question 152</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>What figure of speech is used in &quot;<em>He would look at the ceiling and at the faces before him, as though he had just returned from a dreamy wonderland&rdquo;?</em></p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 152 - Question 152%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 153 - Question 153</small></p><p><strong>JAMB 2025 English Language - Question 153</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p><em>&ldquo;Mr. Audu, the Fine Arts teacher, who was a bunch of biting humour&hellip;&rdquo;&nbsp;</em>What does this description of Mr Audu mean?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 153 - Question 153%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 154 - Question 154</small></p><p><strong>JAMB 2025 English Language - Question 154</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p><em>&ldquo;...his foot-dragging over the matter had pushed his marriage to the brink.&rdquo;&nbsp;</em>What does &quot;foot-dragging&quot; mean as used in the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 154 - Question 154%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 155 - Question 155</small></p><p><strong>JAMB 2025 English Language - Question 155</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Mrs. Ibidun Gloss expressed deep appreciation to<em>&nbsp;</em>Bepo for&nbsp;contributing what she called an &quot;unrivalled quota&quot; to the growth of Stardom. What does &quot;unrivalled quota&quot; as used in the novel mean?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 155 - Question 155%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 156 - Question 156</small></p><p><strong>JAMB 2025 English Language - Question 156</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>Which of the following is not a figure of speech used in J.P. Clark&#39;s poem &quot;Ibadan&quot; as referenced in the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 156 - Question 156%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 157 - Question 157</small></p><p><strong>JAMB 2025 English Language - Question 157</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabia Alabi Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>The following are current socio-economic realities depicted in the novel except</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 157 - Question 157%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 158 - Question 158</small></p><p><strong>JAMB 2025 English Language - Question 158</strong></p><p>Read the passage carefully and answer the question that follows.</p>\n\n<p>Birds are found almost everywhere, even in the hearts of the cities and because they are active creatures, they easily lend themselves to study. One of the first things that a child notices is how noisy many kinds of birds are. The guinea fowls are renowned for this. Even while they are feeding, many birds make characteristic calls, and with practice you can tell which species are in a wood just from these calls without seeing the birds at all. Clearly this continuous <em>chatting</em> is important to birds. When flocks of finches are looking for insects or seeds on the branches of trees, they could easily become separated and these calls must help keep the birds together.</p>\n\n<p>There are many other occasions when birds utter calls. For example, at the sight of a bird of prey, a small bird will give its <em>flying predator</em> call as an alarm to other birds in the neighbourhood.</p>\n\n<p>[<em>Adapted from (1985) Objectives Test in English Comprehension, Lexis and Structure. Great Britain: William Collins Sons and co Ltd.</em>]</p><p>One of the first things a child notices in birds is</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 158 - Question 158%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 159 - Question 159</small></p><p><strong>JAMB 2025 English Language - Question 159</strong></p><p>Read the passage carefully and answer the question that follows.</p>\n\n<p>Birds are found almost everywhere, even in the hearts of the cities and because they are active creatures, they easily lend themselves to study. One of the first things that a child notices is how noisy many kinds of birds are. The guinea fowls are renowned for this. Even while they are feeding, many birds make characteristic calls, and with practice you can tell which species are in a wood just from these calls without seeing the birds at all. Clearly this continuous <em>chatting</em> is important to birds. When flocks of finches are looking for insects or seeds on the branches of trees, they could easily become separated and these calls must help keep the birds together.</p>\n\n<p>There are many other occasions when birds utter calls. For example, at the sight of a bird of prey, a small bird will give its <em>flying predator</em> call as an alarm to other birds in the neighbourhood.</p>\n\n<p>[<em>Adapted from (1985) Objectives Test in English Comprehension, Lexis and Structure. Great Britain: William Collins Sons and co Ltd.</em>]</p><p>What makes it easy to identify a species of birds in the wood?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 159 - Question 159%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 160 - Question 160</small></p><p><strong>JAMB 2025 English Language - Question 160</strong></p><p>Read the passage carefully and answer the question that follows.</p>\n\n<p>Birds are found almost everywhere, even in the hearts of the cities and because they are active creatures, they easily lend themselves to study. One of the first things that a child notices is how noisy many kinds of birds are. The guinea fowls are renowned for this. Even while they are feeding, many birds make characteristic calls, and with practice you can tell which species are in a wood just from these calls without seeing the birds at all. Clearly this continuous <em>chatting</em> is important to birds. When flocks of finches are looking for insects or seeds on the branches of trees, they could easily become separated and these calls must help keep the birds together.</p>\n\n<p>There are many other occasions when birds utter calls. For example, at the sight of a bird of prey, a small bird will give its <em>flying predator</em> call as an alarm to other birds in the neighbourhood.</p>\n\n<p>[<em>Adapted from (1985) Objectives Test in English Comprehension, Lexis and Structure. Great Britain: William Collins Sons and co Ltd.</em>]</p><p>Flocks of finches could easily become separated</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 160 - Question 160%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 161 - Question 161</small></p><p><strong>JAMB 2025 English Language - Question 161</strong></p><p>Read the passage carefully and answer the question that follows.</p>\n\n<p>Birds are found almost everywhere, even in the hearts of the cities and because they are active creatures, they easily lend themselves to study. One of the first things that a child notices is how noisy many kinds of birds are. The guinea fowls are renowned for this. Even while they are feeding, many birds make characteristic calls, and with practice you can tell which species are in a wood just from these calls without seeing the birds at all. Clearly this continuous <em>chatting</em> is important to birds. When flocks of finches are looking for insects or seeds on the branches of trees, they could easily become separated and these calls must help keep the birds together.</p>\n\n<p>There are many other occasions when birds utter calls. For example, at the sight of a bird of prey, a small bird will give its <em>flying predator</em> call as an alarm to other birds in the neighbourhood.</p>\n\n<p>[<em>Adapted from (1985) Objectives Test in English Comprehension, Lexis and Structure. Great Britain: William Collins Sons and co Ltd.</em>]</p><p>The small birds have</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 161 - Question 161%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 162 - Question 162</small></p><p><strong>JAMB 2025 English Language - Question 162</strong></p><p>Read the passage carefully and answer the question that follows.</p>\n\n<p>Birds are found almost everywhere, even in the hearts of the cities and because they are active creatures, they easily lend themselves to study. One of the first things that a child notices is how noisy many kinds of birds are. The guinea fowls are renowned for this. Even while they are feeding, many birds make characteristic calls, and with practice you can tell which species are in a wood just from these calls without seeing the birds at all. Clearly this continuous <em>chatting</em> is important to birds. When flocks of finches are looking for insects or seeds on the branches of trees, they could easily become separated and these calls must help keep the birds together.</p>\n\n<p>There are many other occasions when birds utter calls. For example, at the sight of a bird of prey, a small bird will give its <em>flying predator</em> call as an alarm to other birds in the neighbourhood.</p>\n\n<p>[<em>Adapted from (1985) Objectives Test in English Comprehension, Lexis and Structure. Great Britain: William Collins Sons and co Ltd.</em>]</p><p>When a bird of prey is sighted, a small bird</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 162 - Question 162%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 163 - Question 163</small></p><p><strong>JAMB 2025 English Language - Question 163</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill the gap labelled 6</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 163 - Question 163%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 164 - Question 164</small></p><p><strong>JAMB 2025 English Language - Question 164</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill the gap labelled 7</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 164 - Question 164%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 165 - Question 165</small></p><p><strong>JAMB 2025 English Language - Question 165</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill the gap labelled 8</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 165 - Question 165%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 166 - Question 166</small></p><p><strong>JAMB 2025 English Language - Question 166</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill the gap labelled 9</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 166 - Question 166%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 167 - Question 167</small></p><p><strong>JAMB 2025 English Language - Question 167</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill the gap labelled 10</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 167 - Question 167%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 168 - Question 168</small></p><p><strong>JAMB 2025 English Language - Question 168</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill in the gap labelled 11</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 168 - Question 168%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 169 - Question 169</small></p><p><strong>JAMB 2025 English Language - Question 169</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill in the gap labelled 12</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 169 - Question 169%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 170 - Question 170</small></p><p><strong>JAMB 2025 English Language - Question 170</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill in the gap labelled 13</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 170 - Question 170%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 171 - Question 171</small></p><p><strong>JAMB 2025 English Language - Question 171</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill the gap labelled 14</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 171 - Question 171%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 172 - Question 172</small></p><p><strong>JAMB 2025 English Language - Question 172</strong></p><p>The passage below has gaps. Immediately following each gap, four options are provided. Choose the <strong>most appropriate option</strong> for each gap.</p>\n\n<p>The Security <strong>...6...</strong> (A. Unit B. Council C. Department D. Committee) has a primary responsibility, under the UN Charter, for the maintenance of international <strong>...7...</strong> (A. relation B. affairs C. peace D. relationship) and <strong>...8...</strong> (A. safety B. unity C. security D. progress). It has fifteen <strong>...9...</strong> (A. member B. personnel C. members D. states)&mdash;five permanent and ten non-permanent. Each Member has one <strong>...10...</strong> (A. assent B. vote C. consent D. voice). Under the <strong>...11...</strong> (A. charter B. league C. unit D. directorate), all Member States are obligated to comply with Council decisions. The Security Council takes the lead in determining the existence of a <strong>...12...</strong> (A. threat B. agitation C. violence D. fear) to the peace or act of aggression. It calls upon the <strong>...13...</strong> (A. people B. states C. entity D. parties) to a dispute to settle it by peaceful means and recommends methods of adjustment or terms of <strong>...14...</strong> (A. settlement B. agreement C. consent D. condition). In some cases, the Security Council can resort to imposing <strong>...15...</strong> (A. rules B. sanctions C. order D. discipline) or even authorise the use of force to maintain or restore international peace and security. The Security Council has a Presidency, which rotates and changes, every month.</p><p>Fill the gap labelled 15</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 172 - Question 172%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 173 - Question 173</small></p><p><strong>JAMB 2025 English Language - Question 173</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Alabi Garba&#39;s&nbsp;<em>The Lekki Headmaster</em></p>\n\n<p>The school nurse, Mrs Titi, fetched a handkerchief and offered it to him because</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 173 - Question 173%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 174 - Question 174</small></p><p><strong>JAMB 2025 English Language - Question 174</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Alabi Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>&quot;Red-tapism is found everywhere&quot; means</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 174 - Question 174%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 175 - Question 175</small></p><p><strong>JAMB 2025 English Language - Question 175</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster</em></p>\n\n<p>&#39;If you beat my height, you can&#39;t beat my eyes&#39; is a statement by</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 175 - Question 175%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 176 - Question 176</small></p><p><strong>JAMB 2025 English Language - Question 176</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>How did Sola and her husband travel to London from Manchester every day?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 176 - Question 176%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 177 - Question 177</small></p><p><strong>JAMB 2025 English Language - Question 177</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster</em></p>\n\n<p>&quot;Yes....That is what you paid the extra amount for. If you had followed the normal channel, you would still be there with them.&quot;</p>\n\n<p>To whom was this said?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 177 - Question 177%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 178 - Question 178</small></p><p><strong>JAMB 2025 English Language - Question 178</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>&quot;So, you have taken your madness to this level?&quot;</p>\n\n<p>Where was the statement made?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 178 - Question 178%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 179 - Question 179</small></p><p><strong>JAMB 2025 English Language - Question 179</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>Bepo considered establishing a school because</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 179 - Question 179%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 180 - Question 180</small></p><p><strong>JAMB 2025 English Language - Question 180</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>Bibi&#39;s scream diverted Mrs Ladele&#39;s attention from a movie on</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 180 - Question 180%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 181 - Question 181</small></p><p><strong>JAMB 2025 English Language - Question 181</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>Bepo&#39;s retirement plan suggests that he was</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 181 - Question 181%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 182 - Question 182</small></p><p><strong>JAMB 2025 English Language - Question 182</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>What did Bepo believe was crucial for success in the transportation business?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 182 - Question 182%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 183 - Question 183</small></p><p><strong>JAMB 2025 English Language - Question 183</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.&nbsp;</em></p>\n\n<p>What was the essence of open days at Stardom Schools?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 183 - Question 183%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 184 - Question 184</small></p><p><strong>JAMB 2025 English Language - Question 184</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>One of the challenges faced in General Hospitals cited in the novel is</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 184 - Question 184%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 185 - Question 185</small></p><p><strong>JAMB 2025 English Language - Question 185</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster</em></p>\n\n<p>The contestant for the position of a prefect must have spent ... in the school.&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 185 - Question 185%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 186 - Question 186</small></p><p><strong>JAMB 2025 English Language - Question 186</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>Bibi is always scared of Mr Ayesoro because of his</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 186 - Question 186%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 187 - Question 187</small></p><p><strong>JAMB 2025 English Language - Question 187</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>The stories of Nigerian migrants such as Sola, Hope, Riike and Akindele showed that, for thos who have &#39;ja pa&#39;</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 187 - Question 187%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 188 - Question 188</small></p><p><strong>JAMB 2025 English Language - Question 188</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>Why was the Government teacher named &#39;Owala&#39;?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 188 - Question 188%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 189 - Question 189</small></p><p><strong>JAMB 2025 English Language - Question 189</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster</em></p>\n\n<p>How did Stardom Schools curb late-coming?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 189 - Question 189%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 190 - Question 190</small></p><p><strong>JAMB 2025 English Language - Question 190</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s <em>The Lekki Headmaster.</em></p>\n\n<p>Bepo worked in Stardom for over</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 190 - Question 190%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 191 - Question 191</small></p><p><strong>JAMB 2025 English Language - Question 191</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>The question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>What joke did Bepo tell his students concerning his big eyes?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 191 - Question 191%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 English Language - Item 192 - Question 192</small></p><p><strong>JAMB 2025 English Language - Question 192</strong></p> From the novel; <strong>The Lekki Headmaster</strong><p>This question is based on Kabir Garba&#39;s&nbsp;<em>The Lekki Headmaster.</em></p>\n\n<p>&quot;It&#39;s like hanging a snake in the roof and going to bed&quot;. Who made this statement in&nbsp;<em>The Lekki Headmaster</em>?</p>'
WHERE question LIKE '%Source: JAMB 2025 English Language - Item 192 - Question 192%'
  AND deleted = 0;
