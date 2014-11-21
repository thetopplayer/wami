<?php
/**
 * get_identity_profile_list.php
 *
 * Created by IntelliJ IDEA.
 * User: robertlanter
 * Date: 5/15/14
 * Time: 12:51 AM
 *
 * List of identity profiles belonging to user
 */

$userId = $_POST["user_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profile_name, identity_profile_id, default_profile_ind FROM identity_profile WHERE delete_ind = 0 AND user_id = " .$userId;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response["identity_profile_list_data"] = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $item = array();
        $item["profile_name"] = $row["profile_name"];
        $item["identity_profile_id"] = $row["identity_profile_id"];
        $item["default_profile_ind"] = $row["default_profile_ind"];
        array_push($response["identity_profile_list_data"], $item);
    }
    $response["success"] = 1;
    echo json_encode($response);
}
else {
    $response["success"] = 0;
    $response["message"] = "No Identity Profiles found";
    echo json_encode($response);
}
?>