<?php
/**
 * get_profile_flash_data.php
 *
 * Created by robertlanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Get flash data.
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profile_flash_id, flash, media_type, media_url, create_date FROM profile_flash WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY create_date DESC";
$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["profile_flash_data"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $flash_data = array();
        $flash_data["profile_flash_id"] = $row["profile_flash_id"];
        $flash_data["flash"] = $row["flash"];
        $flash_data["media_url"] = $row["media_url"];
        $flash_data["create_date"] = $row["create_date"];
        array_push($response["profile_flash_data"], $flash_data);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
} else {
    $response["ret_code"] = 1;
    $response["message"] = "No profile flash data found";
    echo json_encode($response);
}
?>