<?php
/**
 * get_wami_count_for_profile.php
 *
 * Created by IntelliJ IDEA.
 * User: robertlanter
 * Date: 5/31/14
 * Time: 3:36 PM
 *
 * Get number of wami's for a specified profile
 */
$identity_profile_id = $_POST["identity_profile_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT count(*) FROM identity_profile_collection WHERE delete_ind = 0 AND assign_to_identity_profile_id = " .$identity_profile_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "get_wami_count_for_profile.php: Problem getting number of Wami's for: " .$identity_profile_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["wami_count"] =  $row[0];
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "get_wami_count_for_profile.php: No Wami's found for Profile.";
    echo json_encode($response);
}

