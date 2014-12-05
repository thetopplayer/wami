<?php
/**
 * get_all_profile_names.php
 *
 * Created by IntelliJ IDEA.
 * User: robertlanter
 * Date: 5/15/14
 * Time: 12:51 AM
 *
 * Retrieves all profile names
 */

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profile_name FROM identity_profile WHERE delete_ind = 0";

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response["profile_name_list"] = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $item = array();
        $item["profile_name"] = $row["profile_name"];
        array_push($response["profile_name_list"], $item);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Profile names found";
    echo json_encode($response);
}
?>