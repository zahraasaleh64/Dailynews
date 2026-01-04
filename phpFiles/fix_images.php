<?php
// This script will fix the "Broken Image" issue by creating the correct headers settings
$dir = 'uploads';

if (!is_dir($dir)) {
    mkdir($dir, 0777, true);
}

$htaccess_content = 'Header set Access-Control-Allow-Origin "*"';
$file_path = $dir . '/.htaccess';

if (file_put_contents($file_path, $htaccess_content)) {
    echo "<h1>✅ SUCCESS!</h1>";
    echo "<p>The image security fix has been applied to the 'uploads' folder.</p>";
    echo "<p>Now, <b>Refresh</b> your Flutter app, and the images should start appearing.</p>";
} else {
    echo "<h1>❌ FAILED</h1>";
    echo "<p>Could not create the security file. Check your folder permissions.</p>";
}
?>
