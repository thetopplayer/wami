<?php
/**
 * get_default_identity_profile_id.php
 *
 * Created by Rob Lanter
 *
 * Date: 5/15/14
 * Time: 7:13 PM
 *
 *  Gets identity profile id for the default profile.
 */
$user_id = $_POST["param1"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT identity_profile_id
        FROM identity_profile WHERE user_id = " .$user_id.  " AND default_profile_ind = 1";

$result = mysqli_query($con, $sql) or die(mysqli_error($con));

$response["default_identity_profile_id"] =  array();
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $item["identity_profile_id"] = $row[0];

    array_push($response["default_identity_profile_id"], $item);
    $response["success"] = 1;
    echo json_encode($response);    ;
}
else {
    $response["success"] = 0;
    $response["message"] = "No Default Identity Profile Id found";
    echo json_encode($response);
}

?>
