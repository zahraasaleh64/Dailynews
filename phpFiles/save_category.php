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

// Check if data came from a Form or JSON
$name = isset($_POST['name']) ? $_POST['name'] : "";
if (empty($name)) {
    $data = json_decode(file_get_contents('php://input'), true);
    $name = isset($data['name']) ? $data['name'] : "";
}

if (!empty($name)) {
    $name = mysqli_real_escape_string($con, strip_tags($name));
    
    // Auto-create table if missing
    mysqli_query($con, "CREATE TABLE IF NOT EXISTS categories (cid INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255) NOT NULL)");
    
    $sql = "INSERT INTO categories (name) VALUES ('$name')";
    if (mysqli_query($con, $sql)) {
        header("Content-Type: application/json");
        echo json_encode(["success" => true, "message" => "Saved category", "cid" => mysqli_insert_id($con)]);
    } else {
        echo json_encode(["success" => false, "message" => "Query Error: " . mysqli_error($con)]);
    }
} else {
    echo json_encode(["success" => false, "message" => "No name provided"]);
}

mysqli_close($con);
exit();
?>
