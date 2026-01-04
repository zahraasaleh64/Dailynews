<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit();
}

$con = mysqli_connect("fdb1032.awardspace.net", "4717132_fatima", "Zahraa64", "4717132_fatima");

if (mysqli_connect_errno()) {
    echo json_encode([]);
    exit();
}

$sql = "SELECT cid, name FROM categories ORDER BY name ASC";
$result = mysqli_query($con, $sql);

$emparray = array();
if ($result) {
    while($row = mysqli_fetch_assoc($result)) {
        $emparray[] = $row;
    }
}

echo json_encode($emparray);
mysqli_close($con);
exit();
?>
