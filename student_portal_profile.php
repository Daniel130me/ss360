<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$student_id = $_SESSION['userid'];
$class_id = $_SESSION['class_id'];
$school_id = $_SESSION['school_id'];
// Fetch student info
$query = "SELECT s.*, c.classname, sc.school_name 
          FROM students s 
          LEFT JOIN class c ON s.class_id = c.id 
          LEFT JOIN school sc ON s.school_id = sc.id 
          WHERE s.id = " . $student_id;

$result = $conn->query($query);

if ($result) {
    $student = $result->fetch_assoc();
} else {
    // Handle the error, e.g., log it or display a user-friendly message.
    echo "Error: " . $conn->error;
    $student = null; // Or some default value indicating no student found.
}

// echo "kllhkh";

if (!$student) {
    echo '<div style="padding:40px;text-align:center;">Student information not found.</div>';
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Profile</title>
    <link rel="icon" href="418769schoollogo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <style>
        body {
            background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
            min-height: 100vh;
        }
        .profile-container {
            max-width: 700px;
            margin: 40px auto;
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 32px rgba(99,102,241,0.12);
            padding: 40px 32px 32px 32px;
            position: relative;
        }
        .profile-header {
            display: flex;
            align-items: center;
            gap: 28px;
            margin-bottom: 32px;
        }
        .profile-header img {
            width: 110px;
            height: 110px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #6366f1;
            box-shadow: 0 2px 8px rgba(99,102,241,0.10);
        }
        .profile-header .profile-name {
            font-size: 2rem;
            font-weight: 700;
            color: #3730a3;
        }
        .profile-header .profile-class {
            font-size: 1.1rem;
            color: #6366f1;
            margin-top: 4px;
        }
        .profile-section {
            margin-bottom: 28px;
        }
        .profile-section-title {
            font-size: 1.1rem;
            font-weight: 600;
            /* color: #6366f1; */
            margin-bottom: 10px;
            letter-spacing: 0.5px;
        }
        .profile-details {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px 32px;
        }
        .profile-details .detail-label {
            color: #64748b;
            font-weight: 500;
            font-size: 0.98rem;
        }
        .profile-details .detail-value {
            color: #22223b;
            font-size: 1.05rem;
            font-weight: 500;
        }
        @media (max-width: 700px) {
            .profile-container { padding: 18px 6vw; }
            .profile-header { flex-direction: column; gap: 16px; text-align: center; }
            .profile-details { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <img src="../uploads/<?= htmlspecialchars($student['photo'] ?? 'default.png') ?>" alt="Student Photo">
            <div>
                <div class="profile-name">
                    <?= htmlspecialchars($student['firstname'] . ' ' . $student['lastname']) ?>
                </div>
                <div class="profile-class">
                    <?= htmlspecialchars($student['classname'] ?? 'N/A') ?>
                </div>
                <div style="color:#818cf8; font-size:0.98rem; margin-top:2px;">
                    <?= htmlspecialchars($student['school_name'] ?? '') ?>
                </div>
            </div>
        </div>
        <div class="profile-section">
            <div class="profile-section-title"><span class="material-symbols-outlined" style="vertical-align:middle;">person</span> Personal Information</div>
            <div class="profile-details">
                <div><span class="detail-label">Gender:</span> <span class="detail-value"><?= htmlspecialchars($student['gender'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Date of Birth:</span> <span class="detail-value"><?= htmlspecialchars($student['dob'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Email:</span> <span class="detail-value"><?= htmlspecialchars($student['email'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Phone:</span> <span class="detail-value"><?= htmlspecialchars($student['phone'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Address:</span> <span class="detail-value"><?= htmlspecialchars($student['address'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Nationality:</span> <span class="detail-value"><?= htmlspecialchars($student['nationality'] ?? 'N/A') ?></span></div>
            </div>
        </div>
        <div class="profile-section">
            <div class="profile-section-title"><span class="material-symbols-outlined" style="vertical-align:middle;">school</span> Academic Information</div>
            <div class="profile-details">
                <div><span class="detail-label">Class:</span> <span class="detail-value"><?= htmlspecialchars($student['class_name'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Section:</span> <span class="detail-value"><?= htmlspecialchars($student['section'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Level:</span> <span class="detail-value"><?= htmlspecialchars($student['level'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Admission No:</span> <span class="detail-value"><?= htmlspecialchars($student['admission_no'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Session:</span> <span class="detail-value"><?= htmlspecialchars($student['session'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Term:</span> <span class="detail-value"><?= htmlspecialchars($student['term'] ?? 'N/A') ?></span></div>
            </div>
        </div>
        <div class="profile-section">
            <div class="profile-section-title"><span class="material-symbols-outlined" style="vertical-align:middle;">group</span> Parent/Guardian Information</div>
            <div class="profile-details">
                <div><span class="detail-label">Parent Name:</span> <span class="detail-value"><?= htmlspecialchars($student['parent_name'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Parent Phone:</span> <span class="detail-value"><?= htmlspecialchars($student['parent_phone'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Parent Email:</span> <span class="detail-value"><?= htmlspecialchars($student['parent_email'] ?? 'N/A') ?></span></div>
                <div><span class="detail-label">Relationship:</span> <span class="detail-value"><?= htmlspecialchars($student['parent_relationship'] ?? 'N/A') ?></span></div>
            </div>
        </div>
    </div>
</body>
</html>
