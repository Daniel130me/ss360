<?php
// SMTP Configuration
// For security, this file should ideally be stored outside of the web root.    
return [
    'host'       => 'mail.schoolsuite360.com',       // Your SMTP server, e.g., smtp.gmail.com
    'username'   => 'mail@schoolsuite360.com',   // Your SMTP username
    'password'   => 'G.s.o.m.1.2.3.',             // Your SMTP password or app-specific password
    // Use SMTPS on port 465 because outbound tests showed port 465 is reachable from this host
    'secure'     => PHPMailer\PHPMailer\PHPMailer::ENCRYPTION_SMTPS, // ENCRYPTION_SMTPS for SSL on port 465
    'port'       => 465,
    'from_email' => 'mail@schoolsuite360.com',
    'from_name'  => 'School Suite 360'
];
?>

