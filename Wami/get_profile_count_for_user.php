<?php
/**
 * get_profile_count_for_user.php
 *
 * Created by IntelliJ IDEA.
 * User: robertlanter
 * Date: 5/31/14
 * Time: 3:36 PM
 *
 * Get number of profiles for a specified user
 */
$user_id = $_POST["user_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT count(*) FROM identity_profile WHERE user_id = " .$user_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["profile_count"] =  $row[0];
    $response["success"] = 1;
    echo json_encode($response);
}
else {
    $response["success"] = 0;
    $response["message"] = "No Profiles found for User";
    echo json_encode($response);
}

