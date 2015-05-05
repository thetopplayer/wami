<?php
/**
 * check_account_data.php
 *
 * Created Rob Lanter
 * Date: 5/27/14
 * Time: 9:42 PM
 *
 * Check account data for duplicate username and email address
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$username = $_POST["param1"];
$email = $_POST["param2"];
$profile_name = $_POST["param3"];

$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT * FROM user WHERE delete_ind = 0 AND username = '" . $username . "'";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["ret_code"] = -1;
    $response["message"] = "Username already exists, choose another one!";
    echo json_encode($response);
    return;
}

$sql = "SELECT * FROM user WHERE delete_ind = 0 AND email = '" .$email. "'";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["ret_code"] = -1;
    $response["message"] = "Email address is already being used, choose another one!";
    echo json_encode($response);
    return;
}

$sql = "SELECT * FROM identity_profile WHERE delete_ind = 0 AND profile_name = '" .$profile_name. "'";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["ret_code"] = -1;
    $response["message"] = "Profile name is already being used, choose another one!";
    echo json_encode($response);
    return;
}

$response["ret_code"] = 0;
$response["message"] = "Success";
echo json_encode($response);
?>