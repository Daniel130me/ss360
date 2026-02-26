<?php
// test_smtp_conn.php
// Quick script to test TCP connectivity to the SMTP host on common ports.
$host = 'mail.schoolsuite360.com';
$ports = [25, 465, 587];

header('Content-Type: text/plain');
echo "Testing connectivity to $host...\n\n";

foreach ($ports as $port) {
    $errNo = 0;
    $errStr = '';
    $timeout = 10; // seconds
    $start = microtime(true);
    $fp = @stream_socket_client("tcp://{$host}:{$port}", $errNo, $errStr, $timeout);
    $end = microtime(true);
    $elapsed = round($end - $start, 2);
    if ($fp) {
        echo "Connected to {$host}:{$port} ({$elapsed}s)\n";
        fclose($fp);
    } else {
        echo "Failed to connect to {$host}:{$port} — ({$errNo}) {$errStr} ({$elapsed}s)\n";
    }
}

echo "\nNote: If these fail, check Windows Firewall, antivirus, or network/ISP blocking outbound SMTP ports. Also ensure PHP's OpenSSL extension is enabled for TLS/SSL connections.\n";
