<?php
/**
 * get_profile_group_assign_data.php
 *
 * Created by Robert Lanter
 * Date: 5/15/14
 * Time: 6:10 PM
 *
 * Gets groups assigned to
 */
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$selected_profile_id = $_POST["selected_profile_id"];
$db = new DB_CONNECT();
$con = $db->connect();

//Determine if any groups have been created for specified profile id.
$sql = "SELECT identity_profile_id FROM profile_group
         WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;

$result = mysqli_query($con, $sql)  or  die(mysqli_error($con));
if (mysqli_num_rows($result) == 0) {
    $response["ret_code"] = 2;
    $response["message"] = "No profile groups have been created for selected profile.";
    echo json_encode($response);
    return;
}

$sql = "SELECT group_name, pga.profile_group_id FROM profile_group pg, profile_group_assign pga
        WHERE pg.profile_group_id = pga.profile_group_id AND pga.delete_ind = 0 AND pga.assign_to_identity_profile_id = " .$identity_profile_id.
        " AND pga.identity_profile_id = " .$selected_profile_id;

$result = mysqli_query($con, $sql) or  die(mysql_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "get_profile_group_assign_data.php: Problem getting Profile Groups assigned data for Profile: " .$identity_profile_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
$response["profile_group_assign_data"] = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $item["group"] = $row["group_name"];
        $item["profile_group_id"] = $row["profile_group_id"];
        array_push($response["profile_group_assign_data"], $item);
    }
    $response["ret_code"] = 0;
    $response["message"] = "Profile group assign data found.";
    echo json_encode($response);
} else {
    $response["ret_code"] = 1;
    $response["message"] = "No profile groups assigned for selected profile.";
    echo json_encode($response);
}
?>