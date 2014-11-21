<?php
/**
 * Created by robert lanter
 * User: robertlanter
 * Date: 3/12/14
 * Time: 12:48 AM
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$userId = $_POST["user_id"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT pg.group, pga.identity_profile_id FROM profile_group_assign pga, profile_group pg
         WHERE assign_to_identity_profile_id = pg.identity_profile_id AND pg.profile_group_id = pga.profile_group_id
         AND assign_to_identity_profile_id =
        (SELECT identity_profile_id FROM user u, identity_profile ip
                  WHERE  u.user_id = " .$userId. " AND u.user_id = ip.user_id AND default_profile_ind=1)
                  ORDER BY identity_profile_id ASC, pga.profile_group_id ASC";

$result = mysqli_query($con, $sql)  or  die(mysql_error($con));

$response["profile_group_assign_data"] = array();
if (mysqli_num_rows($result) > 0) {

    while ($row = mysqli_fetch_array($result)) {
        $user = array();
        $user["group"] = $row["group"];
        $user["identity_profile_id"] = $row["identity_profile_id"];
        array_push($response["profile_group_assign_data"], $user);
    }
    $response["success"] = 1;
    $response["message"] = "Profile group assign data found";
    echo json_encode($response);
} else {
    $response["success"] = 0;
    $response["message"] = "No profile group assign data found";
    echo json_encode($response);
}
?>