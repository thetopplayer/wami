<?php
/**
 * get_profile_collection.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * List of profiles collected by user. Users Wami Network, or Wami List
 */
require_once __DIR__ . '/db_connect.php';
$identityProfileId = $_POST["identity_profile_id"];
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();

// Get profile collection data
$sql = "SELECT first_name, last_name, image_url, profile_name, tags, ipc.identity_profile_id, assign_to_identity_profile_id, rating, default_profile_ind
        FROM identity_profile_collection ipc, identity_profile ip
        WHERE ipc.identity_profile_id = ip.identity_profile_id AND ipc.delete_ind = 0 AND assign_to_identity_profile_id = " .$identityProfileId;

$result = mysqli_query($con, $sql) or  die(mysqli_error($con));
$response["profile_collection"] = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $collection = array();
        $collection["first_name"] = $row["first_name"];
        $collection["last_name"] = $row["last_name"];
        $collection["profile_name"] = $row["profile_name"];
        $collection["image_url"] = $row["image_url"];
        $collection["tags"] = $row["tags"];
        $collection["rating"] = $row["rating"];
        $collection["identity_profile_id"] = $row["identity_profile_id"];
        $collection["assign_to_identity_profile_id"] = $row["assign_to_identity_profile_id"];
        $collection["default_profile_ind"] = $row["default_profile_ind"];

        array_push($response["profile_collection"], $collection);
    }
    $response["ret_code"] = 0;
    mysqli_free_result($result);
} else {
    $response["profile_ret_code"] = 1;
    $response["message"] = "No Collection found for profile.";
    echo json_encode($response);
    return;
}

//Get group data
$sql = "SELECT pg.group_name, pga.identity_profile_id FROM profile_group_assign pga, profile_group pg
         WHERE pg.profile_group_id = pga.profile_group_id
         AND pga.delete_ind = 0 AND pg.identity_profile_id = " .$identityProfileId. "
         ORDER BY identity_profile_id ASC, pga.profile_group_id ASC";

$result = mysqli_query($con, $sql)  or  die(mysqli_error($con));
$response["profile_group_assign_data"] = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $group = array();
        $group["group"] = $row["group_name"];
        $group["identity_profile_id"] = $row["identity_profile_id"];
        array_push($response["profile_group_assign_data"], $group);
    }
    $response["ret_code"] = 0;
    mysqli_free_result($result);
    echo json_encode($response);
} else {
    $response["group_ret_code"] = 1;
    $response["message"] = "No profile groups assigned to profiles in collection.";
    echo json_encode($response);
}
?>