<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

$con = mysqli_connect("fdb1032.awardspace.net", "4717132_fatima", "Zahraa64", "4717132_fatima");

if (mysqli_connect_errno()) {
    echo json_encode(["error" => "Connection failed"]);
    exit();
}

$term = $_GET['term'] ?? '';

// Prevent SQL injection (basic)
$term = mysqli_real_escape_string($con, $term);

$sql = "SELECT news.nid, news.title, news.content, news.image_url, news.published_date, categories.name as category 
        FROM news 
        LEFT JOIN categories ON news.cid = categories.cid 
        WHERE news.title LIKE '%$term%' OR news.content LIKE '%$term%'
        ORDER BY news.published_date DESC";

if ($result = mysqli_query($con, $sql)) {
    $emparray = array();
    while($row = mysqli_fetch_assoc($result)) {
        $emparray[] = $row;
    }
    echo json_encode($emparray);
    mysqli_free_result($result);
} else {
    echo json_encode([]);
}

mysqli_close($con);
?>
