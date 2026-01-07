<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");

if (!isset($_GET['path']) || empty($_GET['path'])) {
    die("No path provided");
}

$path = $_GET['path'];
// Security check: only allow files from uploads directory
if (strpos($path, 'uploads/') !== 0) {
    die("Access denied");
}

if (!file_exists($path)) {
    die("File not found");
}

$mime = mime_content_type($path);
header("Content-Type: $mime");
readfile($path);
exit();
?>
