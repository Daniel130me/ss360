function format_student_table_report-old(student_score_data, term, session_id, class_id) {
        student_score_data = JSON.parse(student_score_data)
        console.log("student", student_score_data)
        // const nwdata1 = Object.entries(student_score_data).filter(item => item.term_id == term && item.session_id == session_id && item.class_id == class_id)
        const nwdata = Object.entries(student_score_data).map(([inde, item]) => item.term_id == term && item.session_id == session_id && item.class_id == class_id)
        console.log("nw", nwdata1)
        let str = ''
        if (nwdata.length > 0) {
            str = `
  <table id="view_student_score_table" class="display nowrap" style="width:100%;">
      <thead>
          <tr>
              <th>Subjects</th>
              <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}">CA1</th>
              <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}">CA2</th>
              <th class="${settingsData.ca3 == 0 ? 'd-none' : ''}">CA3</th>
              <th class="${settingsData.pra == 0 ? 'd-none' : ''}">Practical</th>
              <th class="${settingsData.exa == 0 ? 'd-none' : ''}">Exam</th>
          <th>Total</th>         
              <th>Total(%)</th>
              <th>Grade</th>
          </tr>
      </thead>
      <tbody>
  `;

            // if () {
            nwdata.forEach(item => {
                console.log('subj', item.subject_id)
                str += `
      <tr>
          <td>${item.subject}</td>
          <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}">${item.CA1}</td>
          <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}">${item.CA2}</td>
          <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}">${item.CA3}</td>
          <td class="${settingsData.pra == 0 ? 'd-none' : ''}">${item.Practical}</td>
          <td class="${settingsData.exa == 0 ? 'd-none' : ''}">${item.Exam}</td>
          <td>${item.Total}</td>
          <td>90</td>
          <td>A</td>
      </tr>
  `
                // }
            });

            str += `</tbody>
    </table>`;
        }
        $("#table_visuals_display_report").html(str);
    }

    format_student_table_report(data, '<?= $term_id ?>', '<?= $session_id ?>', '<?= $class_id ?>')

     // const settingsData = <?= $settingsData ?>
    // console.log("settingsData", settingsData)
    // console.log("Data", <?=$data?>)
    // const data = <?=$data?>
    (function() {
        // set_behaviour_comment('<= $term_id ?>', '<= $session_id ?>', '<= $student_id ?>', '<= $class_id ?>', 'view')
        // Grading system logic (unchanged)




        // console.log("Grading System:", gradingSystem);

        function calculateGrade1(percentage, gradingSystem) {
            for (const grade in gradingSystem) {
                if (percentage >= gradingSystem[grade]) {
                    return grade;
                }
            }
            return 'F'; // Default to 'F' if no grade matches
        }

        document.querySelectorAll('tbody tr').forEach(row => {
            let totalScore = 0;
            let totalPossible = 0;

            row.querySelectorAll('.score').forEach(cell => {
                if (!cell.classList.contains('d-none')) {
                    const score = parseInt(cell.dataset.score);
                    const maxScore = parseInt(cell.dataset.maxScore);

                    if (!isNaN(score) && !isNaN(maxScore)) {
                        totalScore += score;
                        totalPossible += maxScore;
                    }
                }
            });
            let percentage_cal = (totalScore / totalPossible) * 100
            const percentage = percentage_cal > 0 ? percentage_cal : 0;
            console.log("Calculating grade for percentage:", percentage);
            const grade = calculateGrade1(percentage, gradingSystem);
            console.log("Assigned Grade:", grade);

            const totalScoreElement = row.querySelector('.total-score');
            const percentageElement = row.querySelector('.percentage');
            const gradeElement = row.querySelector('.gradeclass');

            if (totalScoreElement) totalScoreElement.textContent = totalScore;
            if (percentageElement) percentageElement.textContent = percentage.toFixed(0);
            if (gradeElement) gradeElement.textContent = grade;
        });
    })();