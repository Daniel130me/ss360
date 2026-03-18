<?php
// Database connection
try {
    $pdo = new PDO(
        "mysql:host=localhost;dbname=ekmapxmy_ss360;charset=utf8mb4",
        "ekmapxmy_oluwagbenga",   // replace with actual DB user
        "G.s.o.m."    // replace with actual DB password
    );
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("<p style='color:red;'>Connection failed: " . $e->getMessage() . "</p>");
}

// Set the assessment ID you want to process
echo $assessmentId = 30; // <-- change this as needed

// Check if user clicked "commit"
$doCommit = isset($_POST['commit']);


try {
    $pdo->beginTransaction();

    // Step 1: Find duplicates for this assessment
    $sql = "
        SELECT q.question, q.ass_id, MIN(q.id) AS keep_id, GROUP_CONCAT(q.id) AS all_ids
        FROM questions q
        WHERE q.deleted = 0 AND q.ass_id = :ass_id
        GROUP BY q.question, q.ass_id
        HAVING COUNT(*) > 1
    ";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['ass_id' => $assessmentId]);
    $duplicates = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $toDelete = [];

    foreach ($duplicates as $dup) {
        $keepId = $dup['keep_id'];
        $allIds = explode(',', $dup['all_ids']);
        $deleteIds = array_diff($allIds, [$keepId]);

        if (!empty($deleteIds)) {
            $toDelete[] = [
                'question'   => $dup['question'],
                'keep_id'    => $keepId,
                'delete_ids' => $deleteIds
            ];
        }
    }

    echo "<h2>Preview of duplicates for assessment $assessmentId</h2>";

    if (empty($toDelete)) {
        echo "<p>No duplicates found.</p>";
    } else {
        foreach ($toDelete as $row) {
            echo "<div style='margin-bottom:1em;'>";
            echo "<strong>Question:</strong> " . htmlspecialchars($row['question']) . "<br>";
            echo "<strong>Keep ID:</strong> " . $row['keep_id'] . "<br>";
            echo "<strong>Delete IDs:</strong> " . implode(',', $row['delete_ids']) . "<br>";
            echo "</div>";
        }

        if ($doCommit) {
            // Apply changes
            foreach ($toDelete as $row) {
                $in = implode(',', $row['delete_ids']);
                $pdo->exec("UPDATE questions SET deleted = 1 WHERE id IN ($in)");
                $pdo->exec("UPDATE options SET deleted = 1 WHERE question_id IN ($in)");
            }
            $pdo->commit();
            echo "<p style='color:green;'>Changes committed successfully.</p>";
        } else {
            // Show commit button
            echo '<form method="post">';
            echo '<button type="submit" name="commit" value="1">Commit Changes</button>';
            echo '</form>';
            $pdo->rollBack();
            echo "<p style='color:orange;'>No changes committed yet. Review the preview above.</p>";
        }
    }
} catch (Exception $e) {
    $pdo->rollBack();
    echo "<p style='color:red;'>Error occurred: " . $e->getMessage() . "</p>";
}
?>
