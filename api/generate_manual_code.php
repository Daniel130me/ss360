<?php
// cloud_panel/generate_manual_code.php
// This is a Super Admin tool to generate offline activation codes.

$secret = 'A$$3ssHub_Cloud_Secret_Offline';

$generatedCode = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $licenseKey = trim($_POST['license_key'] ?? '');
    $hwid = trim($_POST['hwid'] ?? '');

    if (empty($licenseKey) || empty($hwid)) {
        $error = 'Both License Key and Hardware ID are required.';
    } else {
        // signature = hash_hmac('sha256', $licenseKey . $hwid, 'A$$3ssHub_Cloud_Secret_Offline')
        $generatedCode = hash_hmac('sha256', $licenseKey . $hwid, $secret);
    }
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Manual Activation Generator - Assesshub</title>
    <style>
        body {
            font-family: system-ui, -apple-system, sans-serif;
            background: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .card {
            background: white;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }

        h1 {
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            color: #1c1e21;
            text-align: center;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            color: #4b4f56;
        }

        input {
            width: 100%;
            padding: 0.8rem;
            border: 1px solid #dddfe2;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 1rem;
        }

        button {
            width: 100%;
            padding: 0.9rem;
            background: #1877f2;
            color: white;
            border: none;
            border-radius: 6px;
            font-weight: 700;
            cursor: pointer;
            font-size: 1rem;
        }

        button:hover {
            background: #166fe5;
        }

        .result {
            margin-top: 2rem;
            padding: 1.25rem;
            background: #e7f3ff;
            border-radius: 8px;
            border: 1px solid #bbdefb;
        }

        .result label {
            color: #004a99;
        }

        .code-box {
            background: white;
            padding: 10px;
            border-radius: 4px;
            border: 1px solid #bbdefb;
            font-family: monospace;
            font-size: 0.9rem;
            margin-top: 10px;
            word-break: break-all;
            user-select: all;
        }

        .error {
            color: #d32f2f;
            background: #ffebee;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 1rem;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>
    <div class="card">
        <h1>Manual Code Generator</h1>

        <?php if ($error): ?>
            <div class="error"><?php echo $error; ?></div>
        <?php endif; ?>

        <form method="POST">
            <div class="form-group">
                <label>School License Key</label>
                <input type="text" name="license_key" placeholder="e.g. SCH-XXXX-XXXX" value="<?php echo htmlspecialchars($_POST['license_key'] ?? ''); ?>" required>
            </div>
            <div class="form-group">
                <label>Teacher's Hardware ID (from App)</label>
                <input type="text" name="hwid" placeholder="e.g. 8f7a93..." value="<?php echo htmlspecialchars($_POST['hwid'] ?? ''); ?>" required>
            </div>
            <button type="submit">Generate Activation Code</button>
        </form>

        <?php if ($generatedCode): ?>
            <div class="result">
                <label>Activation Code for Teacher:</label>
                <div class="code-box"><?php echo $generatedCode; ?></div>
                <p style="font-size: 0.75rem; color: #666; margin-top: 10px;">Provide the full string above to the school.</p>
            </div>
        <?php endif; ?>
    </div>
</body>

</html>