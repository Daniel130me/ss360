-- Stem self-containment repair for WAEC 2025 Literature in English.
-- The student interface renders each question standalone (no passage pane), so the
-- source intro blocks shown above each question on myschool.ng (play/poem extracts,
-- 'read the passage below' instructions, book headers e.g.
-- 'From the novel; A Midsummer Night's Dream') must live inside
-- question_bank.question itself. This file re-inserts the intro blocks that the
-- original import dropped (intros were rendered in prevent-copy containers the
-- collection parser did not capture at the time).
-- Idempotent: every UPDATE matches the stable source marker embedded in the row.
-- Only question_bank.question changes; options and all other columns untouched.
-- Coverage: 36 UPDATE statements (Items 6-9, 16-17, 21-50).
-- Every UPDATE validated: new body == intro + old body, intro text matches the
-- source page's prevent-copy intro blocks exactly.
SET NAMES utf8mb4;


UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 6 - Question 6</small></p><p><strong>WAEC 2025 Literature in English - Question 6</strong></p><p>Read the passage below and answer the following question:</p>\n\n<p><strong>(In the Town Hall)</strong></p>\n\n<p><strong>Jonsey:</strong> (By himself, centre right, looking skulky) How does anyone keep faith with himself In such an ill made place? Bassy, Ba-a-ssy!</p>\n\n<p><strong>Bassy:</strong> Here. Anything the matter?</p>\n\n<p><strong>Jonsey:</strong> (Moves front stage centre right) Your mayoral hopeful.</p><p>Jonsey&#39;s opening speech illustrates</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 6 - Question 6%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 7 - Question 7</small></p><p><strong>WAEC 2025 Literature in English - Question 7</strong></p><p>Read the passage below and answer the following question:</p>\n\n<p><strong>(In the Town Hall)</strong></p>\n\n<p><strong>Jonsey:</strong> (By himself, centre right, looking skulky) How does anyone keep faith with himself In such an ill made place? Bassy, Ba-a-ssy!</p>\n\n<p><strong>Bassy:</strong> Here. Anything the matter?</p>\n\n<p><strong>Jonsey:</strong> (Moves front stage centre right) Your mayoral hopeful.</p><p>In the Town hall is the</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 7 - Question 7%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 8 - Question 8</small></p><p><strong>WAEC 2025 Literature in English - Question 8</strong></p><p>Read the passage below and answer the following question:</p>\n\n<p><strong>(In the Town Hall)</strong></p>\n\n<p><strong>Jonsey:</strong> (By himself, centre right, looking skulky) How does anyone keep faith with himself In such an ill made place? Bassy, Ba-a-ssy!</p>\n\n<p><strong>Bassy:</strong> Here. Anything the matter?</p>\n\n<p><strong>Jonsey:</strong> (Moves front stage centre right) Your mayoral hopeful.</p><p>Bassy is a ________ in the play.</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 8 - Question 8%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 9 - Question 9</small></p><p><strong>WAEC 2025 Literature in English - Question 9</strong></p><p>Read the passage below and answer the following question:</p>\n\n<p><strong>(In the Town Hall)</strong></p>\n\n<p><strong>Jonsey:</strong> (By himself, centre right, looking skulky) How does anyone keep faith with himself In such an ill made place? Bassy, Ba-a-ssy!</p>\n\n<p><strong>Bassy:</strong> Here. Anything the matter?</p>\n\n<p><strong>Jonsey:</strong> (Moves front stage centre right) Your mayoral hopeful.</p><p>Jonsey&#39;s speech &quot;Your mayoral hopeful&quot; is addressed to</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 9 - Question 9%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 16 - Question 16</small></p><p><strong>WAEC 2025 Literature in English - Question 16</strong></p><p>Read the extract below and answer the following question:&nbsp;<br>\n&nbsp;</p>\n\n<p><em>The boat nodded in timing with the gentle</em><br>\n<em>Bobbing of the float on the unhurrying</em><br>\n<em>Tide as the angler awaited the bite and</em><br>\n<em>Pull of a salmon</em></p><p>The extract presents the image of a</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 16 - Question 16%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 17 - Question 17</small></p><p><strong>WAEC 2025 Literature in English - Question 17</strong></p><p>Read the extract below and answer the following question:&nbsp;<br>\n&nbsp;</p>\n\n<p><em>The boat nodded in timing with the gentle</em><br>\n<em>Bobbing of the float on the unhurrying</em><br>\n<em>Tide as the angler awaited the bite and</em><br>\n<em>Pull of a salmon</em></p><p>The dominant literary device used in the extract is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 17 - Question 17%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 21 - Question 21</small></p><p><strong>WAEC 2025 Literature in English - Question 21</strong></p><p>PART II: UNSEEN PROSE AND POETRY</p>\n\n<p>Read the following passage and answer the following question:</p>\n\n<p>Along marched the crowd, determined not to be distracted from its cause and the course it had charted. If anyone could intimidate the chief, it was Sasu, who led the crowd. The chief nurtured unruffled restraint. He knew Sasu, knew that Sasu would not waste the trust between them on renegades.</p>\n\n<p>One way to divert a mob from its goal is to join in with it, lead it on, but, finally, veer it from the course of its cause. Onward, towards the chief&#39;s palace marched the crowd, singing war songs.</p>\n\n<p>The sun frowned as the palace guards, rattling like leaves in a storm - fear branded on their faces,&nbsp;came out to survey the threatening crowd and prepare for a siege. Just then, Sasu turned about, heading away from the palace - with the crowd, and the war songs.</p><p>The prevailing atmosphere is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 21 - Question 21%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 22 - Question 22</small></p><p><strong>WAEC 2025 Literature in English - Question 22</strong></p><p>PART II: UNSEEN PROSE AND POETRY</p>\n\n<p>Read the following passage and answer the following question:</p>\n\n<p>Along marched the crowd, determined not to be distracted from its cause and the course it had charted. If anyone could intimidate the chief, it was Sasu, who led the crowd. The chief nurtured unruffled restraint. He knew Sasu, knew that Sasu would not waste the trust between them on renegades.</p>\n\n<p>One way to divert a mob from its goal is to join in with it, lead it on, but, finally, veer it from the course of its cause. Onward, towards the chief&#39;s palace marched the crowd, singing war songs.</p>\n\n<p>The sun frowned as the palace guards, rattling like leaves in a storm - fear branded on their faces,&nbsp;came out to survey the threatening crowd and prepare for a siege. Just then, Sasu turned about, heading away from the palace - with the crowd, and the war songs.</p><p><em>join in with it, lead it on, but, finally, veer it from</em> illustrates</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 22 - Question 22%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 23 - Question 23</small></p><p><strong>WAEC 2025 Literature in English - Question 23</strong></p><p>PART II: UNSEEN PROSE AND POETRY</p>\n\n<p>Read the following passage and answer the following question:</p>\n\n<p>Along marched the crowd, determined not to be distracted from its cause and the course it had charted. If anyone could intimidate the chief, it was Sasu, who led the crowd. The chief nurtured unruffled restraint. He knew Sasu, knew that Sasu would not waste the trust between them on renegades.</p>\n\n<p>One way to divert a mob from its goal is to join in with it, lead it on, but, finally, veer it from the course of its cause. Onward, towards the chief&#39;s palace marched the crowd, singing war songs.</p>\n\n<p>The sun frowned as the palace guards, rattling like leaves in a storm - fear branded on their faces,&nbsp;came out to survey the threatening crowd and prepare for a siege. Just then, Sasu turned about, heading away from the palace - with the crowd, and the war songs.</p><p>The attitude of the writer towards Sasu is one of</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 23 - Question 23%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 24 - Question 24</small></p><p><strong>WAEC 2025 Literature in English - Question 24</strong></p><p>PART II: UNSEEN PROSE AND POETRY</p>\n\n<p>Read the following passage and answer the following question:</p>\n\n<p>Along marched the crowd, determined not to be distracted from its cause and the course it had charted. If anyone could intimidate the chief, it was Sasu, who led the crowd. The chief nurtured unruffled restraint. He knew Sasu, knew that Sasu would not waste the trust between them on renegades.</p>\n\n<p>One way to divert a mob from its goal is to join in with it, lead it on, but, finally, veer it from the course of its cause. Onward, towards the chief&#39;s palace marched the crowd, singing war songs.</p>\n\n<p>The sun frowned as the palace guards, rattling like leaves in a storm - fear branded on their faces,&nbsp;came out to survey the threatening crowd and prepare for a siege. Just then, Sasu turned about, heading away from the palace - with the crowd, and the war songs.</p><p><em>rattling like leaves in a storm, fear branded on their faces</em> illustrates</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 24 - Question 24%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 25 - Question 25</small></p><p><strong>WAEC 2025 Literature in English - Question 25</strong></p><p>PART II: UNSEEN PROSE AND POETRY</p>\n\n<p>Read the following passage and answer the following question:</p>\n\n<p>Along marched the crowd, determined not to be distracted from its cause and the course it had charted. If anyone could intimidate the chief, it was Sasu, who led the crowd. The chief nurtured unruffled restraint. He knew Sasu, knew that Sasu would not waste the trust between them on renegades.</p>\n\n<p>One way to divert a mob from its goal is to join in with it, lead it on, but, finally, veer it from the course of its cause. Onward, towards the chief&#39;s palace marched the crowd, singing war songs.</p>\n\n<p>The sun frowned as the palace guards, rattling like leaves in a storm - fear branded on their faces,&nbsp;came out to survey the threatening crowd and prepare for a siege. Just then, Sasu turned about, heading away from the palace - with the crowd, and the war songs.</p><p>The last paragraph illustrates</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 25 - Question 25%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 26 - Question 26</small></p><p><strong>WAEC 2025 Literature in English - Question 26</strong></p><p>Read the poem below and answer the question that follows:</p>\n\n<p>Miniver Cheevy, child of scorn,<br>\nGrew lean while he assailed the season;<br>\nHe wept that he was ever born,<br>\nAnd he had reasons.<br>\nMiniver loved the days of old<br>\nWhen swords were bright and steeds prancing;<br>\nThe vision of a warrior bold<br>\nWould set him dancing.</p><p><em>child of scorn</em> illustrates</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 26 - Question 26%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 27 - Question 27</small></p><p><strong>WAEC 2025 Literature in English - Question 27</strong></p><p>Read the poem below and answer the question that follows:</p>\n\n<p>Miniver Cheevy, child of scorn,<br>\nGrew lean while he assailed the season;<br>\nHe wept that he was ever born,<br>\nAnd he had reasons.<br>\nMiniver loved the days of old<br>\nWhen swords were bright and steeds prancing;<br>\nThe vision of a warrior bold<br>\nWould set him dancing.</p><p>The metrical structure is predominantly</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 27 - Question 27%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 28 - Question 28</small></p><p><strong>WAEC 2025 Literature in English - Question 28</strong></p><p>Read the poem below and answer the question that follows:</p>\n\n<p>Miniver Cheevy, child of scorn,<br>\nGrew lean while he assailed the season;<br>\nHe wept that he was ever born,<br>\nAnd he had reasons.<br>\nMiniver loved the days of old<br>\nWhen swords were bright and steeds prancing;<br>\nThe vision of a warrior bold<br>\nWould set him dancing.</p><p>Reading the poem, one notices that the poet is being</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 28 - Question 28%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 29 - Question 29</small></p><p><strong>WAEC 2025 Literature in English - Question 29</strong></p><p>Read the poem below and answer the question that follows:</p>\n\n<p>Miniver Cheevy, child of scorn,<br>\nGrew lean while he assailed the season;<br>\nHe wept that he was ever born,<br>\nAnd he had reasons.<br>\nMiniver loved the days of old<br>\nWhen swords were bright and steeds prancing;<br>\nThe vision of a warrior bold<br>\nWould set him dancing.</p><p>In the last stanza, the persona is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 29 - Question 29%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 30 - Question 30</small></p><p><strong>WAEC 2025 Literature in English - Question 30</strong></p><p>Read the poem below and answer the question that follows:</p>\n\n<p>Miniver Cheevy, child of scorn,<br>\nGrew lean while he assailed the season;<br>\nHe wept that he was ever born,<br>\nAnd he had reasons.<br>\nMiniver loved the days of old<br>\nWhen swords were bright and steeds prancing;<br>\nThe vision of a warrior bold<br>\nWould set him dancing.</p><p>The two stanzas are built on</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 30 - Question 30%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 31 - Question 31</small></p><p><strong>WAEC 2025 Literature in English - Question 31</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Use the following extract to answer the following question:<br>\nAs wagish boys in a game themselves forswear;<br>\nSo the boy Love is perjured everywhere;<br>\nFor ere Demetrius looked on Hermia&#39;s eyne,<br>\nHe hailed down oaths that he was only mine;<br>\nAnd when this hail some heat from Hermia felt,<br>\nSo he dissolved and showers of oaths did melt</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 31 - Question 31%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 32 - Question 32</small></p><p><strong>WAEC 2025 Literature in English - Question 32</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Use the following extract to answer the following question:<br>\nAs wagish boys in a game themselves forswear;<br>\nSo the boy Love is perjured everywhere;<br>\nFor ere Demetrius looked on Hermia&#39;s eyne,<br>\nHe hailed down oaths that he was only mine;<br>\nAnd when this hail some heat from Hermia felt,<br>\nSo he dissolved and showers of oaths did melt</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speech shows that the speaker is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 32 - Question 32%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 33 - Question 33</small></p><p><strong>WAEC 2025 Literature in English - Question 33</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Use the following extract to answer the following question:<br>\nAs wagish boys in a game themselves forswear;<br>\nSo the boy Love is perjured everywhere;<br>\nFor ere Demetrius looked on Hermia&#39;s eyne,<br>\nHe hailed down oaths that he was only mine;<br>\nAnd when this hail some heat from Hermia felt,<br>\nSo he dissolved and showers of oaths did melt</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker&#39;s mood stems from</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 33 - Question 33%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 34 - Question 34</small></p><p><strong>WAEC 2025 Literature in English - Question 34</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Use the following extract to answer the following question:<br>\nAs wagish boys in a game themselves forswear;<br>\nSo the boy Love is perjured everywhere;<br>\nFor ere Demetrius looked on Hermia&#39;s eyne,<br>\nHe hailed down oaths that he was only mine;<br>\nAnd when this hail some heat from Hermia felt,<br>\nSo he dissolved and showers of oaths did melt</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker has just said farewell to</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 34 - Question 34%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 35 - Question 35</small></p><p><strong>WAEC 2025 Literature in English - Question 35</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Use the following extract to answer the following question:<br>\nAs wagish boys in a game themselves forswear;<br>\nSo the boy Love is perjured everywhere;<br>\nFor ere Demetrius looked on Hermia&#39;s eyne,<br>\nHe hailed down oaths that he was only mine;<br>\nAnd when this hail some heat from Hermia felt,<br>\nSo he dissolved and showers of oaths did melt</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker resolves to tell</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 35 - Question 35%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 36 - Question 36</small></p><p><strong>WAEC 2025 Literature in English - Question 36</strong></p><p>WILLIAM SHAKESPEARE: <em>A Midummer Night&#39;s Dream</em></p>\n\n<p>Read the following extract and answer the question that follows:</p>\n\n<p>Lysander riddles very prettily;<br>\nNow much beshrew my manners and my pride,<br>\nIf Hermia meant to say Lysander lied.<br>\nBut, gentle friend, for love and courtesy<br>\nLie further off, in human modesty;<br>\nSuch separation as may well be said<br>\nBecomes a virtuous bachelor and a maid;<br>\nSo far be distant, and good night, sweet friend:<br>\nThy love ne&#39;er alter, till thy sweet life end!</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 36 - Question 36%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 37 - Question 37</small></p><p><strong>WAEC 2025 Literature in English - Question 37</strong></p><p>WILLIAM SHAKESPEARE: <em>A Midummer Night&#39;s Dream</em></p>\n\n<p>Read the following extract and answer the question that follows:</p>\n\n<p>Lysander riddles very prettily;<br>\nNow much beshrew my manners and my pride,<br>\nIf Hermia meant to say Lysander lied.<br>\nBut, gentle friend, for love and courtesy<br>\nLie further off, in human modesty;<br>\nSuch separation as may well be said<br>\nBecomes a virtuous bachelor and a maid;<br>\nSo far be distant, and good night, sweet friend:<br>\nThy love ne&#39;er alter, till thy sweet life end!</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speech is made in</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 37 - Question 37%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 38 - Question 38</small></p><p><strong>WAEC 2025 Literature in English - Question 38</strong></p><p>WILLIAM SHAKESPEARE: <em>A Midummer Night&#39;s Dream</em></p>\n\n<p>Read the following extract and answer the question that follows:</p>\n\n<p>Lysander riddles very prettily;<br>\nNow much beshrew my manners and my pride,<br>\nIf Hermia meant to say Lysander lied.<br>\nBut, gentle friend, for love and courtesy<br>\nLie further off, in human modesty;<br>\nSuch separation as may well be said<br>\nBecomes a virtuous bachelor and a maid;<br>\nSo far be distant, and good night, sweet friend:<br>\nThy love ne&#39;er alter, till thy sweet life end!</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker and the addressee are</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 38 - Question 38%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 39 - Question 39</small></p><p><strong>WAEC 2025 Literature in English - Question 39</strong></p><p>WILLIAM SHAKESPEARE: <em>A Midummer Night&#39;s Dream</em></p>\n\n<p>Read the following extract and answer the question that follows:</p>\n\n<p>Lysander riddles very prettily;<br>\nNow much beshrew my manners and my pride,<br>\nIf Hermia meant to say Lysander lied.<br>\nBut, gentle friend, for love and courtesy<br>\nLie further off, in human modesty;<br>\nSuch separation as may well be said<br>\nBecomes a virtuous bachelor and a maid;<br>\nSo far be distant, and good night, sweet friend:<br>\nThy love ne&#39;er alter, till thy sweet life end!</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p><em>Now much beshrew my manners and my pride,</em> illustrates the use of</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 39 - Question 39%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 40 - Question 40</small></p><p><strong>WAEC 2025 Literature in English - Question 40</strong></p><p>WILLIAM SHAKESPEARE: <em>A Midummer Night&#39;s Dream</em></p>\n\n<p>Read the following extract and answer the question that follows:</p>\n\n<p>Lysander riddles very prettily;<br>\nNow much beshrew my manners and my pride,<br>\nIf Hermia meant to say Lysander lied.<br>\nBut, gentle friend, for love and courtesy<br>\nLie further off, in human modesty;<br>\nSuch separation as may well be said<br>\nBecomes a virtuous bachelor and a maid;<br>\nSo far be distant, and good night, sweet friend:<br>\nThy love ne&#39;er alter, till thy sweet life end!</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p><em>Thy love ne&#39;er alter, till thy sweet life end.</em> implies</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 40 - Question 40%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 41 - Question 41</small></p><p><strong>WAEC 2025 Literature in English - Question 41</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Read the extract below and asnwer the question that follows:</p>\n\n<p>That fallen am I in dark uneven way,<br>\nCome, thou gentle day;<br>\nFor if but once thou show me thy grey light,<br>\nI&#39;ll find, and revenge this spite.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 41 - Question 41%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 42 - Question 42</small></p><p><strong>WAEC 2025 Literature in English - Question 42</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Read the extract below and asnwer the question that follows:</p>\n\n<p>That fallen am I in dark uneven way,<br>\nCome, thou gentle day;<br>\nFor if but once thou show me thy grey light,<br>\nI&#39;ll find, and revenge this spite.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker is addressing</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 42 - Question 42%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 43 - Question 43</small></p><p><strong>WAEC 2025 Literature in English - Question 43</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Read the extract below and asnwer the question that follows:</p>\n\n<p>That fallen am I in dark uneven way,<br>\nCome, thou gentle day;<br>\nFor if but once thou show me thy grey light,<br>\nI&#39;ll find, and revenge this spite.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker is in</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 43 - Question 43%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 44 - Question 44</small></p><p><strong>WAEC 2025 Literature in English - Question 44</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Read the extract below and asnwer the question that follows:</p>\n\n<p>That fallen am I in dark uneven way,<br>\nCome, thou gentle day;<br>\nFor if but once thou show me thy grey light,<br>\nI&#39;ll find, and revenge this spite.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p><em>Come, thou gentle day</em> illustrates</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 44 - Question 44%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 45 - Question 45</small></p><p><strong>WAEC 2025 Literature in English - Question 45</strong></p><strong>WILLIAM SHAKESPEARE: <em>A Midsummer Night&#39;s Dream</em></strong>\n\n<p>Read the extract below and asnwer the question that follows:</p>\n\n<p>That fallen am I in dark uneven way,<br>\nCome, thou gentle day;<br>\nFor if but once thou show me thy grey light,<br>\nI&#39;ll find, and revenge this spite.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>After the speech, the speaker</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 45 - Question 45%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 46 - Question 46</small></p><p><strong>WAEC 2025 Literature in English - Question 46</strong></p><p>WILLIAM SHAKESPEARE:&nbsp;<em>A Midsummer Night&#39;s Dream</em></p>\n\n<p>Read the extract below and answer the question that follows:</p>\n\n<p>He hath rid his prologue like a rough colt: he knows not the stop.<br>\nA good moral, my lord: it is not enough to speak, but to speak true.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The speaker is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 46 - Question 46%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 47 - Question 47</small></p><p><strong>WAEC 2025 Literature in English - Question 47</strong></p><p>WILLIAM SHAKESPEARE:&nbsp;<em>A Midsummer Night&#39;s Dream</em></p>\n\n<p>Read the extract below and answer the question that follows:</p>\n\n<p>He hath rid his prologue like a rough colt: he knows not the stop.<br>\nA good moral, my lord: it is not enough to speak, but to speak true.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The character that speaks before the speaker</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 47 - Question 47%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 48 - Question 48</small></p><p><strong>WAEC 2025 Literature in English - Question 48</strong></p><p>WILLIAM SHAKESPEARE:&nbsp;<em>A Midsummer Night&#39;s Dream</em></p>\n\n<p>Read the extract below and answer the question that follows:</p>\n\n<p>He hath rid his prologue like a rough colt: he knows not the stop.<br>\nA good moral, my lord: it is not enough to speak, but to speak true.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p><em>it is not enough to speak, but to speak true</em> illustrates</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 48 - Question 48%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 49 - Question 49</small></p><p><strong>WAEC 2025 Literature in English - Question 49</strong></p><p>WILLIAM SHAKESPEARE:&nbsp;<em>A Midsummer Night&#39;s Dream</em></p>\n\n<p>Read the extract below and answer the question that follows:</p>\n\n<p>He hath rid his prologue like a rough colt: he knows not the stop.<br>\nA good moral, my lord: it is not enough to speak, but to speak true.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The character that speaks after the speaker is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 49 - Question 49%'
  AND deleted = 0;

UPDATE question_bank SET question = '<p><small>Source: WAEC 2025 Literature in English - Item 50 - Question 50</small></p><p><strong>WAEC 2025 Literature in English - Question 50</strong></p><p>WILLIAM SHAKESPEARE:&nbsp;<em>A Midsummer Night&#39;s Dream</em></p>\n\n<p>Read the extract below and answer the question that follows:</p>\n\n<p>He hath rid his prologue like a rough colt: he knows not the stop.<br>\nA good moral, my lord: it is not enough to speak, but to speak true.</p> From the novel; <strong>A Midsummer Night&#39;s Dream</strong><p>The character that delivers the prologue is</p>'
WHERE question LIKE '%WAEC 2025 Literature in English - Item 50 - Question 50%'
  AND deleted = 0;
