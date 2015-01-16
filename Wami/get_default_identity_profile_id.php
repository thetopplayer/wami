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
$user_id = $_POST["user_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT identity_profile_id FROM identity_profile WHERE user_id = " .$user_id.  " AND default_profile_ind = 1 AND delete_ind = 0";

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response = array();
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["default_identity_profile_id"] = $row[0];

    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Default Identity Profile Id found";
    echo json_encode($response);
}

?>
