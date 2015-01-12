<?php
/**
 * insert_group.php
 *
 * Created Byr: Robert Lanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts new group
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$new_group = $_POST["new_group"];
$identity_profile_id = $_POST["identity_profile_id"];
$delete_ind = 0;

$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT group_name FROM profile_group WHERE delete_ind = 0 AND group_name = '" .$new_group. "' AND identity_profile_id = " .$identity_profile_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "insert_group.php: Problem getting Profile Group for Profile: " .$identity_profile_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $response["ret_code"] = 1;
    $response["message"] = "Group already exists ";
    echo json_encode($response);
    return;
}

$sql = "INSERT INTO profile_group (identity_profile_id, group_name, delete_ind, create_date, modified_date)
            VALUES (".$identity_profile_id.", '".$new_group."', ".$delete_ind.", NOW(), NOW())";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["message"] = "insert_group: Problem inserting new group: MySQL Error: " .mysqli_error($con);
    $response["ret_code"] = -1;
    echo json_encode($response);
    exit(-1);
}

$response["ret_code"] = 0;
$response["message"] = "New group added ";
echo json_encode($response);
?>
