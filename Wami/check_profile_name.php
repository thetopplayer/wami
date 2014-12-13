<?php
/**
 * check_profile_name.php
 *
 * Created Rob Lanter
 * Date: 5/27/14
 * Time: 9:42 PM
 *
 * Check new profile data for duplicate profile names
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$profile_name = $_POST["profile_name"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT * FROM identity_profile WHERE delete_ind = 0 AND profile_name = '" .$profile_name. "'";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["ret_code"] = 1;
    $response["message"] = "Profile name already exists, choose another one!";
    echo json_encode($response);
    return;
}
$response["ret_code"] = 0;
$response["message"] = "New Profile being created.";
echo json_encode($response);
?>