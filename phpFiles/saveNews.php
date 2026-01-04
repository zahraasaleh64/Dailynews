<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit();
}

$con = mysqli_connect("fdb1032.awardspace.net", "4717132_fatima", "Zahraa64", "4717132_fatima");

if (mysqli_connect_errno()) {
    die(json_encode(["success" => false, "message" => "Connection failed"]));
}

// 1. GET DATA (Handle both Multipart and raw JSON just in case)
$title = isset($_POST['title']) ? $_POST['title'] : '';
$content = isset($_POST['content']) ? $_POST['content'] : '';
$cid = isset($_POST['cid']) ? $_POST['cid'] : 0;

if (empty($title) || empty($content)) {
    // Try reading JSON input if POST fields are empty
    $jsonInput = file_get_contents('php://input');
    $data = json_decode($jsonInput, true);
    if ($data) {
        $title = $data['title'] ?? '';
        $content = $data['content'] ?? '';
        $cid = $data['cid'] ?? 0;
    }
}

if (empty($title) || empty($content)) {
    die(json_encode(["success" => false, "message" => "Title and Content are required"]));
}

$image_url = "";

// 2. FILE UPLOAD
if (isset($_FILES['image']) && $_FILES['image']['error'] == 0) {
    if (!is_dir("uploads")) {
        mkdir("uploads", 0777, true);
    }
    $ext = pathinfo($_FILES["image"]["name"], PATHINFO_EXTENSION);
    $filename = uniqid() . "." . $ext;
    $target = "uploads/" . $filename;
    
    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target)) {
        $image_url = "http://fatimamobile.atwebpages.com/" . $target; 
    }
}

// 3. SAVE TO DATABASE
$title = mysqli_real_escape_string($con, strip_tags($title));
$content = mysqli_real_escape_string($con, strip_tags($content));
$cid = (int)$cid;
$date = date("Y-m-d H:i:s");

$sql = "INSERT INTO news (title, content, image_url, published_date, cid) 
        VALUES ('$title', '$content', '$image_url', '$date', $cid)";

if (mysqli_query($con, $sql)) {
    echo json_encode(["success" => true, "message" => "News published!"]);
} else {
    echo json_encode(["success" => false, "message" => "DB Error: " . mysqli_error($con)]);
}

mysqli_close($con);
exit();
?>
