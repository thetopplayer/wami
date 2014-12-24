<?php
/**
 * get_selected_profile_name.php
 *
 * Created by Robert Lanter
 * Date: 5/15/14
 * Time: 6:10 PM
 *
 * Gets profile name for identity_profile_id.
 */
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profile_name FROM identity_profile WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "get_selected_profile_name.php: Problem getting Profile Name for Profile: " .$identity_profile_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["profile_name"] = $row[0];
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "Profile name not found";
    echo json_encode($response);
    return;
}
?>

