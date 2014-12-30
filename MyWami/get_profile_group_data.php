<?php
/**
 * get_profile_group_data.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * get group data
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["param1"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profile_group_id, group_name FROM profile_group WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;

$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "get_profile_group_data.php: Problem getting Profile Group data for Profile: " .$identity_profile_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $response["profile_group_data"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $item = array();
        $item["profile_group_id"] = $row["profile_group_id"];
        $item["group"] = $row["group_name"];
        array_push($response["profile_group_data"], $item);
    }
    $response["success"] = 0;
    echo json_encode($response);
} else {
    $response["success"] = 1;
    $response["message"] = "No profile group data found";
    echo json_encode($response);
}
?>