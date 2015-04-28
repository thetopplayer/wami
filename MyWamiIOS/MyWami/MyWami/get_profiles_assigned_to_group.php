<?php
/**
 * get_profiles_assigned_to_group.php
 *
 * Created by Robert Lanter
 * Date: 5/15/14
 * Time: 6:10 PM
 *
 * Gets groups assigned to
 */
    
$jsonInput = file_get_contents('php://input');
$data = json_decode($jsonInput);
$identity_profile_id = $data->param1;
$profile_group_id = $data->param2;
    
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT DISTINCT group_name, pga.profile_group_id FROM profile_group pg, profile_group_assign pga
        WHERE pg.profile_group_id = pga.profile_group_id AND pga.delete_ind = 0 AND pga.assign_to_identity_profile_id = " .$identity_profile_id.
        " AND pga.profile_group_id = " .$profile_group_id;

$result = mysqli_query($con, $sql) or  die(mysql_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "get_profiles_assigned_to_group.php: Problem getting Profile Groups assigned data for Profile: " .$identity_profile_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
$response = array();
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["group"] = $row[0];
    $response["profile_group_id"] = $row[1];
    
    $response["ret_code"] = 0;
    $response["message"] = "Profile group assign data found.";
    echo json_encode($response);
} else {
    $response["ret_code"] = 1;
    $response["message"] = "No profiles found for selected group.";
    echo json_encode($response);
}
?>