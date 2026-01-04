<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
header("Content-Type: application/json");

$con = mysqli_connect("fdb1032.awardspace.net", "4717132_fatima", "Zahraa64", "4717132_fatima");

if (mysqli_connect_errno()) {
    echo json_encode(["error" => "Failed to connect to MySQL: " . mysqli_connect_error()]);
    exit();
}

$sql = "SELECT news.nid, news.title, news.content, news.image_url, news.published_date, categories.name as category 
        FROM news 
        LEFT JOIN categories ON news.cid = categories.cid 
        ORDER BY news.published_date DESC";

if ($result = mysqli_query($con, $sql)) {
    $emparray = array();
    while($row = mysqli_fetch_assoc($result)) {
        $emparray[] = $row;
    }
    echo json_encode($emparray);
    mysqli_free_result($result);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Query failed: " . mysqli_error($con)]);
}

mysqli_close($con);
?>
