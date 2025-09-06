let currentTab = 'rankings';
let selectedSchools = [];
let rankingsChart = null;
let subjectRankingsChart = null;
let studentRankingsChart = null;

// Initialize charts and event listeners
$(document).ready(function() {
    // Tab change handling
    $('#analytics-tab a').on('click', function (e) {
        e.preventDefault();
        currentTab = $(this).attr('href').replace('#', '');
        $(this).tab('show');
        updateCharts();
    });

    // School selection modal handling
    $('#selectSchools1, #selectSchools2').click(function() {
        $('#schoolSelectionModal').modal('show');
    });

    // Select all schools checkbox
    $('#selectAllSchools').change(function() {
        $('.school-checkbox').prop('checked', $(this).is(':checked'));
    });

    // Apply school selection
    $('#applySchoolSelection').click(function() {
        selectedSchools = $('.school-checkbox:checked').map(function() {
            return $(this).val();
        }).get();
        $('#schoolSelectionModal').modal('hide');
        updateCharts();
    });

    // Filter change handlers
    $('#sessionSelect1, #sessionSelect2, #sessionSelect3, #subjectSelect1, #subjectSelect2').change(function() {
        updateCharts();
    });

    // Add event listeners for school performance metrics filters
    $('#overall-school-select, #overall-session-select').change(function() {
        loadOverallPerformance();
    });

    // Add event listeners for subject performance filters
    $('#subject-school-select, #subject-session-select, #subject-select').change(function() {
        loadSubjectPerformance();
    });

    // Load filters
    $.ajax({
        url: '../new_controller.php',
        method: 'POST',
        data: {
            action: 'getSchools'
        },
        success: function(data) {
            try {
                const schools = JSON.parse(data);
                $('#overall-school-select, #subject-school-select').html('<option value="">Select School</option>');
                schools.forEach(school => {
                    $('#overall-school-select, #subject-school-select').append(
                        `<option value="${school.id}">${school.school_name}</option>`
                    );
                });
            } catch (error) {
                console.error("Error parsing schools data:", error);
            }
        }
    });

    $.ajax({
        url: '../new_controller.php',
        method: 'POST',
        data: {
            action: 'getSessions'  
        },
        success: function(data) {
            try {
                const sessions = JSON.parse(data);
                $('#overall-session-select, #subject-session-select').html('<option value="">Select Session</option>');
                sessions.forEach(session => {
                    $('#overall-session-select, #subject-session-select').append(
                        `<option value="${session.id}">${session.session}</option>`
                    ); 
                });
            } catch (error) {
                console.error("Error parsing sessions data:", error);
            }
        }
    });

    $.ajax({
        url: '../new_controller.php', 
        method: 'POST',
        data: {
            action: 'getSubjects'
        },
        success: function(data) {
            try {
                const subjects = JSON.parse(data);
                $('#subject-select').html('<option value="">Select Subject</option>');
                subjects.forEach(subject => {
                    $('#subject-select').append(
                        `<option value="${subject.id}">${subject.subject}</option>`
                    );
                });
            } catch (error) {
                console.error("Error parsing subjects data:", error);
            }
        }
    });
});

function updateCharts() {
    switch(currentTab) {
        case 'rankings':
            loadSchoolRankings();
            break;
        case 'subject-rankings':
            loadSubjectRankings();
            break;
        case 'student-rankings':
            loadStudentRankings();
            break;
        case 'overall-performance':
            loadOverallPerformance();
            break;
    }
}

function loadSchoolRankings() {
    const sessionId = $('#sessionSelect1').val();
    if (!sessionId) return;

    $.ajax({
        url: '../new_controller.php',
        method: 'POST',
        data: {
            action: 'getSchoolRankings',
            session_id: sessionId,
            school_ids: selectedSchools
        },
        success: function(response) {
            const data = JSON.parse(response);

            if (rankingsChart) {
                rankingsChart.destroy();
            }

            // Calculate average score
            const averageScore = data.scores && data.scores.length > 0 
                ? data.scores.map(score => parseFloat(score)).reduce((a, b) => a + b, 0) / data.scores.length 
                : 0;
            // console.log(averageScore); // Debug log
            rankingsChart = new Chart(document.getElementById('rankingsChart'), {
                type: 'bar',
                data: {
                    labels: data.schools,
                    datasets: [{
                        label: 'Average Performance (%)',
                        data: data.scores,
                        backgroundColor: 'rgba(75, 192, 192, 0.6)'
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100
                        }
                    },
                    plugins: {
                        annotation: {
                            annotations: {
                                averageLine: {
                                    type: 'line',
                                    yMin: averageScore,
                                    yMax: averageScore,
                                    borderColor: 'rgb(255, 99, 132)',
                                    borderWidth: 2,
                                    borderDash: [5, 5],
                                    label: {
                                        display: true,
                                        content: `Average: ${averageScore.toFixed(1)}%`,
                                        position: 'end',
                                        backgroundColor: 'rgb(255, 99, 132)',
                                        color: 'white',
                                        padding: 4
                                    }
                                }
                            }
                        }
                    }
                }
            });

            $('#rankingsSummary').html(data.summary);
            $('#rankingsRecommendations').html(data.recommendations);
        }
    });
}


function loadSubjectRankings() {
    const sessionId = $('#sessionSelect2').val();
    const subjectId = $('#subjectSelect1').val();
    if (!sessionId || !subjectId) return;

    $.ajax({
        url: '../new_controller.php',
        method: 'POST',
        data: {
            action: 'getSubjectRankings',
            session_id: sessionId,
            subject_id: subjectId,
            school_ids: selectedSchools
        },
        success: function(response) {
            const data = JSON.parse(response);
            
            if(subjectRankingsChart) {
                subjectRankingsChart.destroy();
            }

            // Calculate average score
            const averageScore = data.scores && data.scores.length > 0 
                ? data.scores.map(score => parseFloat(score)).reduce((a, b) => a + b, 0) / data.scores.length 
                : 0;

            subjectRankingsChart = new Chart(document.getElementById('subjectRankingsChart'), {
                type: 'bar',
                data: {
                    labels: data.schools,
                    datasets: [{
                        label: 'Subject Performance (%)',
                        data: data.scores,
                        backgroundColor: 'rgba(153, 102, 255, 0.6)'
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100
                        }
                    },
                    plugins: {
                        annotation: {
                            annotations: {
                                averageLine: {
                                    type: 'line',
                                    yMin: averageScore,
                                    yMax: averageScore,
                                    borderColor: 'rgb(255, 99, 132)',
                                    borderWidth: 2,
                                    borderDash: [5, 5],
                                    label: {
                                        display: true,
                                        content: `Average: ${averageScore.toFixed(1)}%`,
                                        position: 'end',
                                        backgroundColor: 'rgb(255, 99, 132)',
                                        color: 'white',
                                        padding: 4
                                    }
                                }
                            }
                        }
                    }
                }
            });

            $('#subjectRankingsSummary').html(data.summary);
            $('#subjectRankingsRecommendations').html(data.recommendations);
        }
    });
}

function loadStudentRankings() {
    const sessionId = $('#sessionSelect3').val();
    const subjectId = $('#subjectSelect2').val();
    if (!sessionId || !subjectId) return;

    $.ajax({
        url: '../new_controller.php',
        method: 'POST',
        data: {
            action: 'getStudentRankings',
            session_id: sessionId,
            subject_id: subjectId
        },
        success: function(response) {
            const data = JSON.parse(response);
            
            if(studentRankingsChart) {
                studentRankingsChart.destroy();
            }

            // Calculate average score
            const averageScore = data.scores && data.scores.length > 0 
                ? data.scores.map(score => parseFloat(score)).reduce((a, b) => a + b, 0) / data.scores.length 
                : 0;

            studentRankingsChart = new Chart(document.getElementById('studentRankingsChart'), {
                type: 'bar',
                data: {
                    labels: data.students,
                    datasets: [{
                        label: 'Student Scores (%)',
                        data: data.scores,
                        backgroundColor: 'rgba(255, 159, 64, 0.6)'
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true,
                            max: 100
                        }
                    },
                    plugins: {
                        annotation: {
                            annotations: {
                                averageLine: {
                                    type: 'line',
                                    yMin: averageScore,
                                    yMax: averageScore,
                                    borderColor: 'rgb(255, 99, 132)',
                                    borderWidth: 2,
                                    borderDash: [5, 5],
                                    label: {
                                        display: true,
                                        content: `Average: ${averageScore.toFixed(1)}%`,
                                        position: 'end',
                                        backgroundColor: 'rgb(255, 99, 132)',
                                        color: 'white',
                                        padding: 4
                                    }
                                }
                            }
                        }
                    }
                }
            });

            // Update table
            let tableBody = '';
            data.details.forEach((student, index) => {
                tableBody += `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${student.name}</td>
                        <td>${student.school}</td>
                        <td>${student.score}%</td>
                    </tr>
                `;
            });
            $('#studentRankingsTable tbody').html(tableBody);
        }
    });
}

function loadOverallPerformance() {
    const schoolId = $('#overall-school-select').val();
    const sessionId = $('#overall-session-select').val();

    if (!schoolId || !sessionId) return;

    // Clear existing chart if it exists
    const ctx = document.getElementById('performanceTrendChart');
    if (!ctx) {
        console.error('Performance trend chart canvas not found');
        return;
    }

    // Destroy existing chart instance properly
    if (window.performanceTrendChart instanceof Chart) {
        window.performanceTrendChart.destroy();
        window.performanceTrendChart = null;
    }

    $.ajax({
        url: '../new_controller.php',
        method: 'POST',
        data: {
            action: 'getOverallPerformance',
            school_id: schoolId,
            session_id: sessionId
        },
        success: function(response) {
            try {
                const data = JSON.parse(response);
                console.log("Parsed data:", data); // Debug log
                
                // Calculate metrics before using them
                const termData = data.averages || [0, 0, 0];
                const avgScore = termData.reduce((a, b) => a + b, 0) / termData.length;
                
                // Calculate highest and lowest scores and their terms
                const highestScore = Math.max(...termData);
                const lowestScore = Math.min(...termData);
                const highestTerm = termData.indexOf(highestScore) + 1;
                const lowestTerm = termData.indexOf(lowestScore) + 1;

                // Initialize new chart with the actual data array
                window.performanceTrendChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ['First Term', 'Second Term', 'Third Term'],
                        datasets: [{
                            label: 'Average Performance',
                            data: data.averages, // Direct array assignment
                            borderColor: '#007bff',
                            backgroundColor: 'rgba(0, 123, 255, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        return `Performance: ${context.parsed.y}%`;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100,
                                ticks: {
                                    stepSize: 20,
                                    callback: function(value) {
                                        return value + '%';
                                    }
                                }
                            }
                        }
                    }
                });

                // Generate insights HTML with the new styled components
                let insights = `
                    <div class="performance-insights">
                        <h5><i class="fas fa-chart-line mr-2"></i>Performance Overview</h5>
                        
                        <div class="insight-grid">
                            <div class="insight-card high">
                                <div class="insight-value">${highestScore.toFixed(1)}%</div>
                                <div class="insight-label">Highest Score (Term ${highestTerm})</div>
                            </div>
                            <div class="insight-card low">
                                <div class="insight-value">${lowestScore.toFixed(1)}%</div>
                                <div class="insight-label">Lowest Score (Term ${lowestTerm})</div>
                            </div>
                            <div class="insight-card neutral">
                                <div class="insight-value">${avgScore.toFixed(1)}%</div>
                                <div class="insight-label">Average Performance</div>
                            </div>
                        </div>

                        <div class="trend-analysis">
                            <h5><i class="fas fa-chart-line mr-2"></i>Term Analysis</h5>`;

                // Add trend items
                for(let i = 1; i < termData.length; i++) {
                    const difference = termData[i] - termData[i-1];
                    const trend = difference > 0 ? 'up' : difference < 0 ? 'down' : 'stable';
                    const trendIcon = trend === 'up' ? '↑' : trend === 'down' ? '↓' : '→';
                    const trendText = trend === 'up' ? 'improved' : trend === 'down' ? 'declined' : 'remained stable';
                    const changePercent = Math.abs(difference).toFixed(1);
                    
                    insights += `
                        <div class="trend-item">
                            <div class="trend-indicator trend-${trend}">${trendIcon}</div>
                            <div>
                                <strong>Term ${i+1}</strong> ${trendText} by ${changePercent}% compared to Term ${i}
                            </div>
                        </div>`;
                }

                insights += `</div>
                
                <div class="recommendations-section">
                    <h5><i class="fas fa-lightbulb mr-2"></i>Recommendations</h5>
                    <ul class="recommendation-list">`;

                // Add recommendations based on average score
                if(avgScore < 50) {
                    insights += `
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-exclamation-circle"></i></div>
                            <div>Implement immediate intervention strategies</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-users"></i></div>
                            <div>Schedule teacher-parent meetings to discuss improvement strategies</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-book-reader"></i></div>
                            <div>Consider organizing remedial classes focusing on core subjects</div>
                        </li>`;
                } else if(avgScore < 75) {
                    insights += `
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-search"></i></div>
                            <div>Focus on identifying and strengthening weak areas</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-chart-line"></i></div>
                            <div>Continue monitoring progress with regular assessments</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-users"></i></div>
                            <div>Encourage formation of peer learning groups</div>
                        </li>`;
                } else {
                    insights += `
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-star"></i></div>
                            <div>Maintain current teaching methods and strategies</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-graduation-cap"></i></div>
                            <div>Consider implementing advanced learning programs</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-share-alt"></i></div>
                            <div>Share successful teaching practices with other schools</div>
                        </li>`;
                }

                insights += `
                    </ul>
                </div>`;

                // Update the UI with insights
                $('#performance-insights').html(insights);
                $('#performance-summary').html(''); // Clear the old summary since we now have a better visualization
            } catch (error) {
                console.error("Error parsing performance data:", error);
                $('#performance-summary').html('Error loading performance data');
            }
        },
        error: function(xhr, status, error) {
            console.error("Error fetching performance data:", error);
            $('#performance-summary').html('Error loading performance data');
        }
    });
}

function loadSubjectPerformance() {
    const schoolId = $('#subject-school-select').val();
    const sessionId = $('#subject-session-select').val();
    const subjectId = $('#subject-select').val();

    if (!schoolId || !sessionId || !subjectId) return;

    const ctx = document.getElementById('subjectPerformanceChart');
    if (!ctx) {
        console.error('Subject performance chart canvas not found');
        return;
    }

    // Properly check and destroy existing chart instance
    if (window.subjectPerformanceChart instanceof Chart) {
        window.subjectPerformanceChart.destroy();
        window.subjectPerformanceChart = null;
    }

    // Show loading state
    $(ctx).addClass('loading');

    $.ajax({
        url: '../new_controller.php',
        method: 'POST',
        data: {
            action: 'getSubjectPerformance',
            school_id: schoolId,
            session_id: sessionId,
            subject_id: subjectId
        },
        success: function(response) {
            try {
                const data = JSON.parse(response);
                
                // Calculate average score across terms and other metrics
                const termData = data.averages || [0, 0, 0];
                const averageScore = termData.reduce((a, b) => a + b, 0) / termData.length;
                
                // Calculate highest and lowest scores and their terms
                const highestScore = Math.max(...termData);
                const lowestScore = Math.min(...termData);
                const highestTerm = termData.indexOf(highestScore) + 1;
                const lowestTerm = termData.indexOf(lowestScore) + 1;

                // Create new chart instance with fixed dimensions
                window.subjectPerformanceChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: ['First Term', 'Second Term', 'Third Term'],
                        datasets: [{
                            label: 'Subject Performance',
                            data: termData,
                            borderColor: '#28a745',
                            backgroundColor: 'rgba(40, 167, 69, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: true,
                        animation: {
                            duration: 750
                        },
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top'
                            },
                            tooltip: {
                                mode: 'index',
                                intersect: false,
                                callbacks: {
                                    label: function(context) {
                                        return `Performance: ${context.parsed.y}%`;
                                    }
                                }
                            },
                            annotation: {
                                annotations: {
                                    averageLine: {
                                        type: 'line',
                                        yMin: averageScore,
                                        yMax: averageScore,
                                        borderColor: 'rgb(255, 99, 132)',
                                        borderWidth: 2,
                                        borderDash: [5, 5],
                                        label: {
                                            display: true,
                                            content: `Average: ${averageScore.toFixed(1)}%`,
                                            position: 'end',
                                            backgroundColor: 'rgb(255, 99, 132)',
                                            color: 'white',
                                            padding: 4
                                        }
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                max: 100,
                                ticks: {
                                    stepSize: 20,
                                    callback: function(value) {
                                        return value + '%';
                                    }
                                }
                            }
                        }
                    }
                });

                // Generate insights HTML
                let insights = `
                    <div class="performance-insights">
                        <h5><i class="fas fa-book mr-2"></i>Subject Performance Overview</h5>
                        
                        <div class="insight-grid">
                            <div class="insight-card high">
                                <div class="insight-value">${highestScore.toFixed(1)}%</div>
                                <div class="insight-label">Highest Score (Term ${highestTerm})</div>
                            </div>
                            <div class="insight-card low">
                                <div class="insight-value">${lowestScore.toFixed(1)}%</div>
                                <div class="insight-label">Lowest Score (Term ${lowestTerm})</div>
                            </div>
                            <div class="insight-card neutral">
                                <div class="insight-value">${averageScore.toFixed(1)}%</div>
                                <div class="insight-label">Average Performance</div>
                            </div>
                        </div>

                        <div class="trend-analysis">
                            <h5><i class="fas fa-chart-line mr-2"></i>Term Analysis</h5>`;

                // Add trend items with icons and styling
                for(let i = 1; i < termData.length; i++) {
                    const difference = termData[i] - termData[i-1];
                    const trend = difference > 0 ? 'up' : difference < 0 ? 'down' : 'stable';
                    const trendIcon = trend === 'up' ? '↑' : trend === 'down' ? '↓' : '→';
                    const trendText = trend === 'up' ? 'improved' : trend === 'down' ? 'declined' : 'remained stable';
                    const changePercent = Math.abs(difference).toFixed(1);
                    
                    insights += `
                        <div class="trend-item">
                            <div class="trend-indicator trend-${trend}">${trendIcon}</div>
                            <div>
                                <strong>Term ${i+1}</strong> ${trendText} by ${changePercent}% compared to Term ${i}
                            </div>
                        </div>`;
                }

                insights += `</div>
                
                <div class="recommendations-section">
                    <h5><i class="fas fa-lightbulb mr-2"></i>Subject-Specific Recommendations</h5>
                    <ul class="recommendation-list">`;

                // Add subject-specific recommendations based on average score
                if(averageScore < 50) {
                    insights += `
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                            <div>Review and adapt teaching methods for this subject</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-tasks"></i></div>
                            <div>Implement additional practice sessions with focus on problem areas</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-users"></i></div>
                            <div>Organize remedial classes for challenging topics</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-comments"></i></div>
                            <div>Schedule parent-teacher meetings for targeted support</div>
                        </li>`;
                } else if(averageScore < 75) {
                    insights += `
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-search"></i></div>
                            <div>Focus on identifying and strengthening specific weak areas</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-laptop"></i></div>
                            <div>Introduce interactive learning methods for better engagement</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-user-friends"></i></div>
                            <div>Establish peer tutoring groups for collaborative learning</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-tools"></i></div>
                            <div>Incorporate more practical applications of concepts</div>
                        </li>`;
                } else {
                    insights += `
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-star"></i></div>
                            <div>Maintain current successful teaching strategies</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-graduation-cap"></i></div>
                            <div>Introduce advanced topics for further enrichment</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-award"></i></div>
                            <div>Consider competitive opportunities in this subject</div>
                        </li>
                        <li class="recommendation-item">
                            <div class="recommendation-icon"><i class="fas fa-share-alt"></i></div>
                            <div>Document and share successful teaching methods</div>
                        </li>`;
                }

                insights += `
                    </ul>
                </div>`;

                // Add performance metrics with beautiful cards
                const metricsHtml = `
                    <div class="metrics-grid">
                        <div class="metric-card">
                            <div class="metric-value">${averageScore.toFixed(1)}%</div>
                            <div class="metric-label">Average Score</div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-value">${data.passingStudents || 0}</div>
                            <div class="metric-label">Passing Students</div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-value">${data.totalStudents || 0}</div>
                            <div class="metric-label">Total Students</div>
                        </div>
                        <div class="metric-card">
                            <div class="metric-value">${((data.passingStudents || 0) / (data.totalStudents || 1) * 100).toFixed(1)}%</div>
                            <div class="metric-label">Pass Rate</div>
                        </div>
                    </div>
                `;

                // Update the UI with insights and metrics
                $('#subject-performance-insights').html(insights);
                $('#subject-performance-metrics').html(metricsHtml);
            } catch (error) {
                console.error("Error parsing subject performance data:", error);
                $('#subject-performance-container').html('Error loading subject performance data');
            }
        },
        error: function(xhr, status, error) {
            console.error("Error fetching subject performance data:", error);
            $('#subject-performance-container').html('Error loading subject performance data');
        },
        complete: function() {
            $(ctx).removeClass('loading');
        }
    });
}

// Add trend chart update function if needed
function updateTrendChart(trendsData) {
    // Implementation for updating trend chart
    // This will depend on how you want to visualize the trends
}
