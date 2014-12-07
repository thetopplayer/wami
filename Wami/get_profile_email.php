<?php
/**
 * get_profile_email.php
 *
 * Created by IntelliJ IDEA.
 * User: robertlanter
 * Date: 5/31/14
 * Time: 3:36 PM
 *
 * Get email address for specified profile_id
 */
$identity_profile_id = $_POST["identity_profile_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT email FROM identity_profile WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "get_profile_email.php: Problem getting email address for Profile: " .$identity_profile_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["from_email"] =  $row[0];
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No email address found for identity_profile.";
    echo json_encode($response);
}

