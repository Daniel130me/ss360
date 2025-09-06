<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");

if(isset($_POST['action'])) {
    switch($_POST['action']) {
        case 'getOverallPerformance':
            getOverallPerformance($conn);
            break;
        case 'getSubjectPerformance':
            getSubjectPerformance($conn);
            break;
        case 'getSchoolRankings':
            getSchoolRankings($conn);
            break;
        case 'getSubjectRankings':
            getSubjectRankings($conn);
            break;
        case 'getStudentRankings':
            getStudentRankings($conn);
            break;
        case 'getSchools':
            $query = "SELECT id, school_name FROM school WHERE status = 1";
            $result = $conn->query($query);
            $schools = array();
            while($row = $result->fetch_assoc()) {
                $schools[] = $row;
            }
            echo json_encode($schools);
            break;
        case 'getSessions':
            $query = "SELECT id, session FROM sessions";
            $result = $conn->query($query);
            $sessions = array();
            while($row = $result->fetch_assoc()) {
                $sessions[] = $row;
            }
            echo json_encode($sessions);
            break;
        case 'getSubjects':
            $query = "SELECT id, subject FROM subjects";
            $result = $conn->query($query);
            $subjects = array();
            while($row = $result->fetch_assoc()) {
                $subjects[] = $row;
            }
            echo json_encode($subjects);
            break;
        default:
            echo json_encode(["error" => "Invalid action"]);
            break;
    }
}

function getOverallPerformance($conn) {
    $school_id = $_POST['school_id'];
    $session_id = $_POST['session_id'];
    $averages = [];
    $recommendations = [];

    // Get averages for each term
    for ($term = 1; $term <= 3; $term++) {
        $query = "SELECT
                    ROUND(AVG(
                        CASE
                            WHEN (
                                (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                            ) > 0
                            THEN (
                                (CASE WHEN sk.ca1Total > 0 THEN (sk.ca1 * 100.0 / sk.ca1Total) ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN (sk.ca2 * 100.0 / sk.ca2Total) ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN (sk.ca3 * 100.0 / sk.ca3Total) ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN (sk.pra * 100.0 / sk.praTotal) ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN (sk.exam * 100.0 / sk.examTotal) ELSE 0 END)
                            ) / (
                                (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                            )
                            ELSE 0
                        END
                    ), 2) as term_avg
                 FROM skulscores sk
                 WHERE sk.school_id = $school_id
                 AND sk.session_id = $session_id
                 AND sk.term_id = $term";

        $result = mysqli_query($conn, $query);
        $row = mysqli_fetch_assoc($result);
        $averages[] = round($row['term_avg'] ?? 0, 2);
    }

    // Generate recommendations (same as before)
    $latest_avg = end($averages);
    $prev_avg = prev($averages);

    $recommendations[] = "<h4>Performance Analysis:</h4>";

    if ($latest_avg > $prev_avg) {
        $recommendations[] = "• Overall performance has improved by " . round($latest_avg - $prev_avg, 1) . "%";
    } elseif ($latest_avg < $prev_avg) {
        $recommendations[] = "• Overall performance has decreased by " . round($prev_avg - $latest_avg, 1) . "%";
    } else {
        $recommendations[] = "• Overall performance has remained the same.";
    }

    if ($latest_avg < 50) {
        $recommendations[] = "• Performance needs significant improvement";
    } elseif ($latest_avg < 75) {
        $recommendations[] = "• Performance is satisfactory but there's room for improvement";
    } else {
        $recommendations[] = "• Excellent overall performance";
    }

    echo json_encode([
        'averages' => $averages,
        'recommendations' => implode("<br>", $recommendations)
    ]);
}


function getSubjectPerformance($conn) {
    $school_id = $_POST['school_id'];
    $session_id = $_POST['session_id'];
    $subject_id = $_POST['subject_id'];
    $averages = [];
    $recommendations = [];
    $totalStudents = 0;
    $passingStudents = 0;

    // Get averages for each term
    for ($term = 1; $term <= 3; $term++) {
        $query = "SELECT
                    ROUND(AVG(
                        CASE
                            WHEN (
                                (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                            ) > 0
                            THEN (
                                (CASE WHEN sk.ca1Total > 0 THEN (sk.ca1 * 100.0 / sk.ca1Total) ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN (sk.ca2 * 100.0 / sk.ca2Total) ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN (sk.ca3 * 100.0 / sk.ca3Total) ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN (sk.pra * 100.0 / sk.praTotal) ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN (sk.exam * 100.0 / sk.examTotal) ELSE 0 END)
                            ) / (
                                (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                            )
                            ELSE 0
                        END
                    ), 2) as term_avg,
                    COUNT(*) as total_students,
                    SUM(CASE WHEN (
                        CASE
                            WHEN (
                                (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                            ) > 0
                            THEN (
                                (CASE WHEN sk.ca1Total > 0 THEN (sk.ca1 * 100.0 / sk.ca1Total) ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN (sk.ca2 * 100.0 / sk.ca2Total) ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN (sk.ca3 * 100.0 / sk.ca3Total) ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN (sk.pra * 100.0 / sk.praTotal) ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN (sk.exam * 100.0 / sk.examTotal) ELSE 0 END)
                            ) / (
                                (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                                (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                            )
                            ELSE 0
                        END
                    ) >= 40 THEN 1 ELSE 0 END) as passing_students
                 FROM skulscores sk
                 WHERE sk.school_id = $school_id
                 AND sk.session_id = $session_id
                 AND sk.term_id = $term
                 AND sk.subject_id = $subject_id";

        $result = mysqli_query($conn, $query);
        $row = mysqli_fetch_assoc($result);
        $averages[] = round($row['term_avg'] ?? 0, 2);
        $totalStudents = $row['total_students'];
        $passingStudents = $row['passing_students'];
    }

    // Get subject name
    $subject_query = "SELECT subject FROM subjects WHERE id = $subject_id";
    $subject_result = mysqli_query($conn, $subject_query);
    $subject_row = mysqli_fetch_assoc($subject_result);
    $subject_name = $subject_row['subject'];

    // Generate recommendations
    $latest_avg = end($averages);
    $prev_avg = prev($averages);

    $recommendations[] = "<h4>$subject_name Performance Analysis:</h4>";

    if ($latest_avg > $prev_avg) {
        $recommendations[] = "• Performance in $subject_name has improved by " . round($latest_avg - $prev_avg, 1) . "%";
    } elseif ($latest_avg < $prev_avg) {
        $recommendations[] = "• Performance in $subject_name has decreased by " . round($prev_avg - $latest_avg, 1) . "%";
    } else {
        $recommendations[] = "• Performance in $subject_name has remained the same.";
    }

    if ($latest_avg < 50) {
        $recommendations[] = "• Students need additional support in $subject_name";
    } elseif ($latest_avg < 75) {
        $recommendations[] = "• Performance is satisfactory but more practice is recommended";
    } else {
        $recommendations[] = "• Excellent performance in $subject_name";
    }
    $averageScore = round(array_sum($averages) / count(array_filter($averages)), 2);
    echo json_encode([
        'averages' => $averages,
        'recommendations' => implode("<br>", $recommendations),
        'totalStudents' => $totalStudents,
        'passingStudents' => $passingStudents,
        'averageScore' => $averageScore
    ]);
}


function getSchoolRankings($conn) {
    $session_id = $_POST['session_id'];
    $school_ids = isset($_POST['school_ids']) ? implode(',', $_POST['school_ids']) : '';
    
    $school_clause = $school_ids ? "AND sk.school_id IN ($school_ids)" : '';
    
    $query = "SELECT 
                sc.school_name,
                ROUND(AVG(
                    CASE 
                        WHEN (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        ) > 0
                        THEN (
                            (CASE WHEN sk.ca1Total > 0 THEN (sk.ca1 * 100.0 / sk.ca1Total) ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN (sk.ca2 * 100.0 / sk.ca2Total) ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN (sk.ca3 * 100.0 / sk.ca3Total) ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN (sk.pra * 100.0 / sk.praTotal) ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN (sk.exam * 100.0 / sk.examTotal) ELSE 0 END)
                        ) / (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        )
                        ELSE 0
                    END
                ), 2) as avg_score
              FROM skulscores sk 
              JOIN school sc ON sk.school_id = sc.id
              WHERE sk.session_id = $session_id 
                $school_clause
              GROUP BY sk.school_id
              HAVING avg_score > 0
              ORDER BY avg_score DESC
              LIMIT 10";
              
    $result = mysqli_query($conn, $query);
    
    $schools = [];
    $scores = [];
    
    while($row = mysqli_fetch_assoc($result)) {
        $schools[] = $row['school_name'];
        $scores[] = $row['avg_score'];
    }
    
    echo json_encode([
        'schools' => $schools,
        'scores' => $scores,
        'summary' => generateRankingSummary($schools, $scores),
        'recommendations' => generateRankingRecommendations($scores)
   
    ]);
}


function getSubjectRankings($conn) {
    $session_id = $_POST['session_id'];
    $subject_id = $_POST['subject_id'];
    $school_ids = isset($_POST['school_ids']) ? implode(',', $_POST['school_ids']) : '';

    $school_clause = $school_ids ? "AND sk.school_id IN ($school_ids)" : '';

    $query = "SELECT
                sc.school_name,
                ROUND(AVG(
                    CASE
                        WHEN (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        ) > 0
                        THEN (
                            (CASE WHEN sk.ca1Total > 0 THEN (sk.ca1 * 100.0 / sk.ca1Total) ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN (sk.ca2 * 100.0 / sk.ca2Total) ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN (sk.ca3 * 100.0 / sk.ca3Total) ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN (sk.pra * 100.0 / sk.praTotal) ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN (sk.exam * 100.0 / sk.examTotal) ELSE 0 END)
                        ) / (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        )
                        ELSE 0
                    END
                ), 2) as avg_score
              FROM skulscores sk
              JOIN school sc ON sk.school_id = sc.id
              WHERE sk.session_id = $session_id
                AND sk.subject_id = $subject_id
                $school_clause
              GROUP BY sk.school_id
              HAVING avg_score > 0
              ORDER BY avg_score DESC
              LIMIT 10";

    $result = mysqli_query($conn, $query);


    $schools = [];
    $scores = [];

    while ($row = mysqli_fetch_assoc($result)) {
        $schools[] = $row['school_name'];
        $scores[] = $row['avg_score'];
    }
    $averageScore = $scores[0];

    echo json_encode([
        'schools' => $schools,
        'scores' => $scores,
        'summary' => generateSubjectRankingSummary($schools, $scores),
        'recommendations' => generateSubjectRecommendations($scores),
        'averageScore' => $averageScore
    ]);
}


function getStudentRankings($conn) {
    $session_id = $_POST['session_id'];
    $subject_id = $_POST['subject_id'];

    $query = "SELECT
                CONCAT(st.firstname, ' ', st.lastname) as student_name,
                sc.school_name,
                ROUND(AVG(
                    CASE
                        WHEN (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        ) > 0
                        THEN (
                            (CASE WHEN sk.ca1Total > 0 THEN (sk.ca1 * 100.0 / sk.ca1Total) ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN (sk.ca2 * 100.0 / sk.ca2Total) ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN (sk.ca3 * 100.0 / sk.ca3Total) ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN (sk.pra * 100.0 / sk.praTotal) ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN (sk.exam * 100.0 / sk.examTotal) ELSE 0 END)
                        ) / (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        )
                        ELSE 0
                    END
                ), 2) as overall_score
            FROM skulscores sk
            JOIN students st ON sk.student_id = st.id
            JOIN school sc ON sk.school_id = sc.id
            WHERE sk.session_id = $session_id
            AND sk.subject_id = $subject_id
            GROUP BY sk.student_id
            HAVING overall_score > 0
            ORDER BY overall_score DESC
            LIMIT 10";

    $result = mysqli_query($conn, $query);

    $students = [];
    $scores = [];
    $details = [];

    while ($row = mysqli_fetch_assoc($result)) {
        $students[] = $row['student_name'];
        $scores[] = $row['overall_score'];
        $details[] = [
            'name' => $row['student_name'],
            'school' => $row['school_name'],
            'score' => $row['overall_score']
        ];
    }

    echo json_encode([
        'students' => $students,
        'scores' => $scores,
        'details' => $details
    ]);
}



function generateRankingSummary($schools, $scores) {
    $top_school = $schools[0];
    $top_score = $scores[0];
    $avg_score = array_sum($scores) / count($scores);
    
    return "<p>The top performing school is <strong>$top_school</strong> with an average score of $top_score%. </p>";
}

function generateRankingRecommendations($scores) {
    $recommendations = [];
    $avg_score = array_sum($scores) / count($scores);
    
    if($avg_score < 50) {
        $recommendations[] = "Overall performance needs significant improvement across all schools";
    } else if($avg_score < 75) {
        $recommendations[] = "Schools are performing satisfactorily but there's room for improvement";
    } else {
        $recommendations[] = "Schools are performing excellently overall";
    }
    
    return "<ul><li>" . implode("</li><li>", $recommendations) . "</li></ul>";
}

function generateSubjectRankingSummary($schools, $scores) {
    $top_school = $schools[0];
    $top_score = $scores[0];
    
    return "<p>In this subject, <strong>$top_school</strong> leads with $top_score%. </p>";
}

function generateSubjectRecommendations($scores) {
    $recommendations = [];
    $avg_score = $scores[0];
    
    if($avg_score < 50) {
        $recommendations[] = "Teaching methods for this subject need review across schools";
    } else if($avg_score < 75) {
        $recommendations[] = "Consider sharing best practices from top performing schools";
    } else {
        $recommendations[] = "Maintain current teaching standards and methods";
    }
    
    return "<ul><li>" . implode("</li><li>", $recommendations) . "</li></ul>";
}
?>
