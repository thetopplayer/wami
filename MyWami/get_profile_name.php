<?php
/**
 * get_profile_name.php
 *
 * Created by Rob Lanter
 *
 * Date: 5/15/14
 * Time: 7:13 PM
 *
 *  Gets identity profile name for the profile id.
 */
$response = array();
$identity_profile_id = $_POST["param1"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profile_name, email FROM identity_profile WHERE identity_profile_id = " .$identity_profile_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["profile_name"] = $row[0];
    $response["email"] = $row[1];

    $response["ret_code"] = 0;
    echo json_encode($response);    ;
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Identity Name Id found";
    echo json_encode($response);
}

?>
