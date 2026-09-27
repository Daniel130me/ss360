-- Stem self-containment repair for JAMB 2025 Literature in English.
-- The student interface renders each question standalone (no passage pane), so the
-- source passage/book header shown above the question on myschool.ng must live
-- inside question_bank.question itself. This file re-inserts the headers that the
-- original import dropped (intro captured in a container variant the parser did
-- not handle at collection time).
-- Idempotent: every UPDATE matches the stable source marker embedded in the row.
-- Only question_bank.question changes; options and all other columns untouched.
SET NAMES utf8mb4;


UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 1 - Question 1</small></p><p><strong>JAMB 2025 Literature in English - Question 1</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>This question is based on Emily Bront&euml;&#39;s&nbsp;<em>Wuthering Heights.</em></strong></p>\n\n<p>The overriding depiction of mystery and terror in the novel accounts for its classification as a&nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 1 - Question 1%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 2 - Question 2</small></p><p><strong>JAMB 2025 Literature in English - Question 2</strong></p> From the novel; <strong>The Lion and the Jewel</strong><p><strong>This question is based on Wole Soyinka&#39;s&nbsp;<em>The Lion and the Jewel.</em></strong></p>\n\n<p>The chief of Ilujinle village is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 2 - Question 2%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 3 - Question 3</small></p><p><strong>JAMB 2025 Literature in English - Question 3</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is&nbsp;based on John Osborne&#39;s&nbsp;<em>Look Back in Anger.</em></strong></p>\n\n<p>Jimmy&#39;s feeling&nbsp;about Alison&#39;s upper-class status is that of</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 3 - Question 3%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 5 - Question 5</small></p><p><strong>JAMB 2025 Literature in English - Question 5</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>The subject matter of Angelou&#39;s &quot;<strong>Caged Bird&quot;</strong><em>&nbsp;</em>is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 5 - Question 5%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 6 - Question 6</small></p><p><strong>JAMB 2025 Literature in English - Question 6</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>The experience of the persona in Eliot&#39;s &quot;<strong>The Journey of the Magi</strong>&quot; is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 6 - Question 6%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 7 - Question 7</small></p><p><strong>JAMB 2025 Literature in English - Question 7</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>Beauty in Donne&#39;s &quot;<strong>The Good Morrow</strong>&quot; represents the poet&#39;s persona&#39;s</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 7 - Question 7%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 8 - Question 8</small></p><p><strong>JAMB 2025 Literature in English - Question 8</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>This question is based on Emily Bronte&#39;s <em>Wuthering Heights</em></strong></p>\n\n<p><em>Take my colt, gipsy, then! said young Earnshaw...and wheedle my father out of all he has</em></p>\n\n<p>The statement&nbsp; above exemplifies</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 8 - Question 8%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 10 - Question 10</small></p><p><strong>JAMB 2025 Literature in English - Question 10</strong></p> From the novel; <strong>Second Class Citizen</strong><p><strong>This question is based on Buchi Emecheta&#39;s&nbsp;<em>Second Class Citizen</em></strong></p>\n\n<p>The narrative of the novel centres around</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 10 - Question 10%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 13 - Question 13</small></p><p><strong>JAMB 2025 Literature in English - Question 13</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>This question is based on Emily Bronte&#39;s&nbsp;Wuthering Heights.</strong></p>\n\n<p><em>I&#39;m trying to settle how I shall pay Hindley back.<br>\nI don&#39;t care how long I will wait, if I can only do it at last. I hope he will not die before I do!</em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<br>\nWho made the statement?&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 13 - Question 13%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 15 - Question 15</small></p><p><strong>JAMB 2025 Literature in English - Question 15</strong></p> From the novel; <strong>The Lion and the Jewel</strong><p><strong>This question is based on Wole Soyinka&#39;s&nbsp;<em>The Lion and the Jewel</em></strong></p>\n\n<p><em>I was there when it happened to your father</em></p>\n\n<p>The line above is in reference to</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 15 - Question 15%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 17 - Question 17</small></p><p><strong>JAMB 2025 Literature in English - Question 17</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>The spatial setting of Senghor&#39;s &quot;<strong>Black Woman</strong>&quot; is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 17 - Question 17%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 19 - Question 19</small></p><p><strong>JAMB 2025 Literature in English - Question 19</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osborne&#39;s&nbsp;<em>Look Back in Anger</em></strong></p>\n\n<p>Jimmy&#39;s first love, who is ten years older than him, is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 19 - Question 19%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 20 - Question 20</small></p><p><strong>JAMB 2025 Literature in English - Question 20</strong></p> From the novel; <strong>The Lion and the Jewel</strong><p>This question is based on Wole Soyinka&#39;s&nbsp;<em>The Lion and the Jewel.</em></p>\n\n<p><em>No one? Do you mean there was no one<br>\nTo bar unwanted strangers from my privacy?</em><br>\nWho made&nbsp;this statement?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 20 - Question 20%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 22 - Question 22</small></p><p><strong>JAMB 2025 Literature in English - Question 22</strong></p> From the novel; <strong>Unexpected Joy at Dawn</strong><p><strong>This question is based on Alex Agyei-Agyiri&#39;s&nbsp;<em>Unexpected Joy at Dawn</em></strong></p>\n\n<p>The narrative technique employed in the novel is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 22 - Question 22%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 23 - Question 23</small></p><p><strong>JAMB 2025 Literature in English - Question 23</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osborne&#39;s&nbsp;<em>Look Back in Anger</em></strong></p>\n\n<p>The setting of the play is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 23 - Question 23%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 24 - Question 24</small></p><p><strong>JAMB 2025 Literature in English - Question 24</strong></p> From the novel; <strong>Wuthering Heights</strong><p><strong>This question is based on Emily Bronte&#39;s <em>Wuthering Heights.</em></strong></p>\n\n<p>From the events in the novel, one can conclude that Joseph is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 24 - Question 24%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 25 - Question 25</small></p><p><strong>JAMB 2025 Literature in English - Question 25</strong></p> From the novel; <strong>Unexpected Joy at Dawn</strong><p><strong>This question is based on Alex Agyei-Agyiri&nbsp;<em>Unexpected Joy at Dawn.</em></strong></p>\n\n<p>The main conflict in the novel is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 25 - Question 25%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 26 - Question 26</small></p><p><strong>JAMB 2025 Literature in English - Question 26</strong></p> From the novel; <strong>The Lion and the Jewel</strong><p><strong>This question is based on Wole Soyinka&#39;s&nbsp;<em>The Lion and the Jewel</em></strong></p>\n\n<p>Lakunle is portrayed as the foil of</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 26 - Question 26%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 27 - Question 27</small></p><p><strong>JAMB 2025 Literature in English - Question 27</strong></p> From the novel; <strong>Second Class Citizen</strong><p><strong>This question is based on Buchi Emecheta&#39;s&nbsp;<em>Second Class CItizen.</em></strong></p>\n\n<p>Adah faces discrimination based on</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 27 - Question 27%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 28 - Question 28</small></p><p><strong>JAMB 2025 Literature in English - Question 28</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>Niyi Osundare&#39;s &quot;<strong>The Leader and the Led</strong>&quot; is a fable because of the</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 28 - Question 28%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 29 - Question 29</small></p><p><strong>JAMB 2025 Literature in English - Question 29</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>The persona in Lade Worsonu&#39;s &quot;<strong>Raider of the Treasure Trove</strong>&quot; warns against</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 29 - Question 29%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 30 - Question 30</small></p><p><strong>JAMB 2025 Literature in English - Question 30</strong></p> From the novel; <strong>Unexpected Joy at Dawn</strong><p><strong>This question is based on Alex Agyei-Agyiri&#39;s&nbsp;<em>Unexpected Joy at Dawn</em></strong></p>\n\n<p>The temporal setting of the novel is in</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 30 - Question 30%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 31 - Question 31</small></p><p><strong>JAMB 2025 Literature in English - Question 31</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p><em>I shall booze and zoom myself home</em></p>\n\n<p>The diction used in the above excerpt in Onu&#39;s &quot;<strong>A Government Driver on His Retirement</strong>&quot; is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 31 - Question 31%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 32 - Question 32</small></p><p><strong>JAMB 2025 Literature in English - Question 32</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>In Lawrence&#39;s &quot;<strong>Bat</strong>&quot;, the poetic persona concludes the poem by stating</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 32 - Question 32%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 33 - Question 33</small></p><p><strong>JAMB 2025 Literature in English - Question 33</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p>Sesay&#39;s &quot;<strong>The Song of the Women of my Land</strong>&quot; is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 33 - Question 33%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 34 - Question 34</small></p><p><strong>JAMB 2025 Literature in English - Question 34</strong></p> From the novel; <strong>Second Class Citizen</strong><p><strong>This question is based on Buchi Emecheta&#39;s&nbsp;<em>Second Class Citizen</em></strong></p>\n\n<p><em>It all began like a dream. You know, that sort of dream which seems to have originated from nowhere, yet one was always aware of its existence...</em></p>\n\n<p>The technique used in the line above is</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 34 - Question 34%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 35 - Question 35</small></p><p><strong>JAMB 2025 Literature in English - Question 35</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This novel is based on John Osborne&#39;s&nbsp;<em>Look Back in Anger</em></strong></p>\n\n<p>The bear in the novel symbolically represents</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 35 - Question 35%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 36 - Question 36</small></p><p><strong>JAMB 2025 Literature in English - Question 36</strong></p> From the novel; <strong>The Lion and the Jewel</strong><p><strong>This question is based on Wole Soyinka&#39;s&nbsp;<em>The Lion and the Jewel.</em></strong></p>\n\n<p>The division of the play into morning, noon and night signifies unity of</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 36 - Question 36%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 37 - Question 37</small></p><p><strong>JAMB 2025 Literature in English - Question 37</strong></p> From the novel; <strong>Selected Poems from: Exam Focus: Literature-in-English: 2021-25</strong><p><em>Decked with dances by baobabs over balances</em></p>\n\n<p>The above line in Neto&#39;s&nbsp;<strong>The Grieved Lands&nbsp;</strong>is an example of</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 37 - Question 37%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 38 - Question 38</small></p><p><strong>JAMB 2025 Literature in English - Question 38</strong></p> From the novel; <strong>Look Back in Anger</strong><p><strong>This question is based on John Osborne&#39;s&nbsp;<em>Look Back in Anger</em></strong></p>\n\n<p>Bullying in the play is revenge tactics on</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 38 - Question 38%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 39 - Question 39</small></p><p><strong>JAMB 2025 Literature in English - Question 39</strong></p><p>This question is based on General Literature Principles and Literary Appreciation</p>\n\n<p>...Akosua Nowa has touched my manhood;</p>\n\n<p>Tell her, red ant upon the tree;</p>\n\n<p>If she passes this way, I am gone,</p>\n\n<p>I am gone to load my gun</p>\n\n<p>No matter how hidden deep her treasure,</p>\n\n<p>By my father&#39;s coffin</p>\n\n<p>I swear I&#39;ll shoot my way to it this day;</p>\n\n<p>Son of the hunter King</p>\n\n<p>There is liquid fire in my gun!&nbsp;</p>\n\n<p>&#39;Akosua Nowa&#39; by Joe de Graft</p><p>The beauty of this poem is built upon its</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 39 - Question 39%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 40 - Question 40</small></p><p><strong>JAMB 2025 Literature in English - Question 40</strong></p> From the novel; <strong>So the Path Does Not Die</strong><p>This question is based on <strong>SO THE PATH DOES NOT DIE</strong>.</p>\n\n<p>Fina&#39;s character is best described as:</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 40 - Question 40%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 45 - Question 45</small></p><p><strong>JAMB 2025 Literature in English - Question 45</strong></p> From the novel; <strong>Antony & Cleopatra</strong><p>This question is based on <strong>ANTONY AND CLEOPATRA</strong>.</p>\n\n<p><strong>Antony:</strong> &quot;I will be / A bridegroom in my death, and run into&#39;t / As to a lover&#39;s bed.&quot;</p>\n\n<p><strong>Eros:</strong> &quot;Draw that thy honest sword, which thou hast worn / Most useful for thy country.&quot;</p>\n\n<p><strong>Antony:</strong> &quot;When I did make thee free, sworest thou not then / To do this when I bade thee?&quot; What does this moment between Antony and Eros represent?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 45 - Question 45%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 46 - Question 46</small></p><p><strong>JAMB 2025 Literature in English - Question 46</strong></p> From the novel; <strong>So the Path Does Not Die</strong><p>This question is based on SO THE PATH DOES NOT DIE.</p>\n\n<p>What is the narrative function of the Kumba Kargbo legend at the beginning of the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 46 - Question 46%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 47 - Question 47</small></p><p><strong>JAMB 2025 Literature in English - Question 47</strong></p> From the novel; <strong>Redemption Road</strong><p>This question is based on REDEMPTION ROAD.</p>\n\n<p>In what way does Bendu&#39;s relationship with Calvin challenge gender norms?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 47 - Question 47%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 48 - Question 48</small></p><p><strong>JAMB 2025 Literature in English - Question 48</strong></p> From the novel; <strong>So the Path Does Not Die</strong><p>This question is based on&nbsp;<strong>SO THE PATH DOES NOT DIE</strong>.</p>\n\n<p>Which element best classifies&nbsp;<em>So the Path Does Not Die</em>&nbsp;as a postcolonial feminist novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 48 - Question 48%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 49 - Question 49</small></p><p><strong>JAMB 2025 Literature in English - Question 49</strong></p> From the novel; <strong>Path of Lucas: The Journey He Endured</strong><p>This question is based on PATH OF LUCAS.</p>\n\n<p>Which narrative technique best defines the structure of the novel?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 49 - Question 49%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 50 - Question 50</small></p><p><strong>JAMB 2025 Literature in English - Question 50</strong></p> From the novel; <strong>Redemption Road</strong><p>This question is based on REDEMPTION ROAD.</p>\n\n<p>What does the character of Calvin represent in contrast to Terrance Clarke?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 50 - Question 50%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 51 - Question 51</small></p><p><strong>JAMB 2025 Literature in English - Question 51</strong></p> From the novel; <strong>The Marriage of Anansewa</strong><p>&nbsp;This question is based on MARRIAGE OF ANANSEWA.</p>\n\n<p>Who serves as a moral voice and critic of Ananse&#39;s schemes?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 51 - Question 51%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 52 - Question 52</small></p><p><strong>JAMB 2025 Literature in English - Question 52</strong></p> From the novel; <strong>The Marriage of Anansewa</strong><p>&nbsp;This question is based on MARRIAGE OF ANANSEWA.</p>\n\n<p>Which of these best describes Ananse?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 52 - Question 52%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 53 - Question 53</small></p><p><strong>JAMB 2025 Literature in English - Question 53</strong></p> From the novel; <strong>Antony & Cleopatra</strong><p>This question is based on <strong>ANTONY AND CLEOPATRA</strong>.</p>\n\n<p><strong>Caesar:</strong> &quot;She shall be buried by her Antony: / No grave upon the earth shall clip in it / A pair so famous.&quot;</p>\n\n<p><strong>Dolabella:</strong> &quot;Caesar, thy thoughts / Touch their effects in this: thyself art coming / To see perform&#39;d the dreaded act which thou / So sought&#39;st to hinder.&quot;</p>\n\n<p>From the excerpt above, Caesar&rsquo;s statement primarily reveals his</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 53 - Question 53%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 54 - Question 54</small></p><p><strong>JAMB 2025 Literature in English - Question 54</strong></p> From the novel; <strong>The Marriage of Anansewa</strong><p>This question is based on <strong>MARRIAGE OF ANANSEWA</strong>.</p>\n\n<p>What theme is emphasised when bride prices are accepted from multiple chiefs?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 54 - Question 54%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 56 - Question 56</small></p><p><strong>JAMB 2025 Literature in English - Question 56</strong></p> From the novel; <strong>Redemption Road</strong><p>This question is based on <strong>REDEMPTION ROAD</strong>.</p>\n\n<p>What is the significance of Cobra&#39;s polite and religious demeanour after the war?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 56 - Question 56%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 57 - Question 57</small></p><p><strong>JAMB 2025 Literature in English - Question 57</strong></p> From the novel; <strong>So the Path Does Not Die</strong><p>This question is based on <strong>SO THE PATH DOES NOT DIE</strong>.</p>\n\n<p>Which of the following characters consistently defends African traditions?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 57 - Question 57%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 59 - Question 59</small></p><p><strong>JAMB 2025 Literature in English - Question 59</strong></p> From the novel; <strong>Path of Lucas: The Journey He Endured</strong><p>This question is based on <strong>PATH OF LUCAS</strong>.</p>\n\n<p>What is the deeper symbolic implication of Lucy&#39;s coma?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 59 - Question 59%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 61 - Question 61</small></p><p><strong>JAMB 2025 Literature in English - Question 61</strong></p> From the novel; <strong>Redemption Road</strong><p>This question is based on <strong>REDEMPTION ROAD</strong>.</p>\n\n<p>What does Benji&#39;s story reveal about the long-term consequences of political silence?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 61 - Question 61%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 63 - Question 63</small></p><p><strong>JAMB 2025 Literature in English - Question 63</strong></p> From the novel; <strong>Path of Lucas: The Journey He Endured</strong><p>This question is based on&nbsp;<strong>PATH OF LUCAS</strong>.</p>\n\n<p>What does Lucas&#39;s refusal to remarry after Isabelle&#39;s death reveal about his core values?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 63 - Question 63%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 66 - Question 66</small></p><p><strong>JAMB 2025 Literature in English - Question 66</strong></p> From the novel; <strong>Antony & Cleopatra</strong><p>This question is based on <strong>ANTONY AND CLEOPATRA</strong>.</p>\n\n<p><strong>Enobarbus:</strong> &quot;Caesar&#39;s whole fleet&#39;s at sea: / Well spread and almost yare. For he&#39;s not dumb, / That tells my departure.&quot;</p>\n\n<p><strong>Agrippa:</strong> &quot;Let&#39;s grant it is not / Amiss to tumble on the bed of Ptolemy; / To give a kingdom for a mirth, to sit / And keep the turn of tippling with a slave...&quot;</p>\n\n<p>What tone is used in the above excerpt and why?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 66 - Question 66%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 69 - Question 69</small></p><p><strong>JAMB 2025 Literature in English - Question 69</strong></p> From the novel; <strong>Path of Lucas: The Journey He Endured</strong><p>This question is based on&nbsp;<strong>PATH OF LUCAS</strong>.</p>\n\n<p>What deeper meaning can be attached to Lucas&#39;s work on the farm?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 69 - Question 69%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 72 - Question 72</small></p><p><strong>JAMB 2025 Literature in English - Question 72</strong></p> From the novel; <strong>The Marriage of Anansewa</strong><p>This question is based on&nbsp;<strong>MARRIAGE OF ANANSEWA</strong>.</p>\n\n<p>Who is Aya in relation to Ananse?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 72 - Question 72%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 77 - Question 77</small></p><p><strong>JAMB 2025 Literature in English - Question 77</strong></p> From the novel; <strong>Redemption Road</strong><p>This question is based on&nbsp;<strong>REDEMPTION ROAD</strong>.</p>\n\n<p>The temporal setting of the novel is?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 77 - Question 77%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 80 - Question 80</small></p><p><strong>JAMB 2025 Literature in English - Question 80</strong></p> From the novel; <strong>Path of Lucas: The Journey He Endured</strong><p>This question is based on&nbsp;<strong>PATH OF LUCAS</strong>.</p>\n\n<p>What does Lucy&#39;s awakening at the novel&#39;s end most strongly symbolise?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 80 - Question 80%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 81 - Question 81</small></p><p><strong>JAMB 2025 Literature in English - Question 81</strong></p> From the novel; <strong>Redemption Road</strong><p>In the end, what core message does&nbsp;<em>Redemption Road</em>&nbsp;leave the reader with?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 81 - Question 81%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 83 - Question 83</small></p><p><strong>JAMB 2025 Literature in English - Question 83</strong></p> From the novel; <strong>Path of Lucas: The Journey He Endured</strong><p>This question is based on&nbsp;<strong>PATH OF LUCAS</strong>.</p>\n\n<p>How does the novel challenge conventional ideas of masculinity?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 83 - Question 83%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 85 - Question 85</small></p><p><strong>JAMB 2025 Literature in English - Question 85</strong></p> From the novel; <strong>Redemption Road</strong><p>This question is based on&nbsp;<strong>REDEMPTION ROAD</strong>.</p>\n\n<p>Why is Bendu&#39;s abandonment of her child in the Duluma camp significant?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 85 - Question 85%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 88 - Question 88</small></p><p><strong>JAMB 2025 Literature in English - Question 88</strong></p> From the novel; <strong>So the Path Does Not Die</strong><p>This question is based on&nbsp;<strong>SO THE PATH DOES NOT DIE</strong>.</p>\n\n<p>Fina&#39;s insistence on supporting her sister Isa, despite Cammy&#39;s protest, stems from:</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 88 - Question 88%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 89 - Question 89</small></p><p><strong>JAMB 2025 Literature in English - Question 89</strong></p> From the novel; <strong>The Marriage of Anansewa</strong><p>This question is based on&nbsp;<strong>MARRIAGE OF ANANSEWA</strong>.</p>\n\n<p>Where is the play primarily set?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 89 - Question 89%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 91 - Question 91</small></p><p><strong>JAMB 2025 Literature in English - Question 91</strong></p> From the novel; <strong>Path of Lucas: The Journey He Endured</strong><p>This question is based on PATH OF LUCAS.</p>\n\n<p>Which best reflects Lucas&#39;s leadership style within his family?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 91 - Question 91%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 94 - Question 94</small></p><p><strong>JAMB 2025 Literature in English - Question 94</strong></p> From the novel; <strong>Antony & Cleopatra</strong><p>This question is based on&nbsp;<strong>ANTONY AND CLEOPATRA</strong>.</p>\n\n<p><strong>Enobarbus</strong>:</p>\n\n<p>I am alone the villain of the earth, And feel I am so most.</p>\n\n<p>O Antony, Thou mine of bounty, how wouldst thou have paid</p>\n\n<p>My better service, when my turpitude Thou dost so crown with gold!</p>\n\n<p>What emotion primarily drives Enobarbus in this speech?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 94 - Question 94%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 98 - Question 98</small></p><p><strong>JAMB 2025 Literature in English - Question 98</strong></p> From the novel; <strong>The Marriage of Anansewa</strong><p>This question is based on&nbsp;<strong>MARRIAGE OF ANANSEWA</strong>.</p>\n\n<p>What style of performance influences the structure of the play?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 98 - Question 98%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 101 - Question 101</small></p><p><strong>JAMB 2025 Literature in English - Question 101</strong></p> From the novel; <strong>So the Path Does Not Die</strong><p>This question is based on&nbsp;<strong>SO THE PATH DOES NOT DIE</strong>.</p>\n\n<p>Which action by Amadu is viewed as a cultural sacrilege?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 101 - Question 101%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 103 - Question 103</small></p><p><strong>JAMB 2025 Literature in English - Question 103</strong></p> From the novel; <strong>Antony & Cleopatra</strong><p>This question is based on&nbsp;<strong>ANTONY AND CLEOPATRA</strong>.</p>\n\n<p><strong>Cleopatra</strong>:</p>\n\n<p>O, wither&#39;d is the garland of the war,</p>\n\n<p>The soldier&#39;s pole is fall&#39;n: young boys and girls</p>\n\n<p>Are level now with men; the odds is gone,</p>\n\n<p>And there is nothing left remarkable</p>\n\n<p>Beneath the visiting moon.</p>\n\n<p>What is Cleopatra lamenting in this passage?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 103 - Question 103%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 104 - Question 104</small></p><p><strong>JAMB 2025 Literature in English - Question 104</strong></p> From the novel; <strong>So the Path Does Not Die</strong><p>This question is based on&nbsp;<strong>SO THE PATH DOES NOT DIE</strong>.</p>\n\n<p>The abandonment of Musudugu by many women before Kumba Kargbo&#39;s birth reflects:</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 104 - Question 104%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 105 - Question 105</small></p><p><strong>JAMB 2025 Literature in English - Question 105</strong></p> From the novel; <strong>Redemption Road</strong><p>This question is based on <strong>REDEMPTION ROAD</strong>.</p>\n\n<p>How does the novel critique the role of international aid in post-conflict settings?</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 105 - Question 105%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: JAMB 2025 Literature in English - Item 106 - Question 106</small></p><p><strong>JAMB 2025 Literature in English - Question 106</strong></p> From the novel; <strong>Antony & Cleopatra</strong><p>This question is based on&nbsp;<strong>ANTONY AND CLEOPATRA</strong>.</p>\n\n<p>Which character says: &quot;The nature of bad news infects the teller.&quot;</p>'
WHERE question LIKE '%Source: JAMB 2025 Literature in English - Item 106 - Question 106%'
  AND deleted = 0;
