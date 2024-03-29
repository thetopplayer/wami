<?php
/**
 * get_profile_collection_filtered.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * List of profiles collected by user filtered by group.
 */
require_once __DIR__ . '/db_connect.php';
$identityProfileId = $_POST["identity_profile_id"];
$profile_group_id = $_POST["profile_group_id"];
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();

$sql = "SELECT first_name, last_name, image_url, profile_name, tags, ip.identity_profile_id, assign_to_identity_profile_id, rating, default_profile_ind
        FROM profile_group_assign pga, identity_profile ip
        WHERE  pga.assign_to_identity_profile_id = " .$identityProfileId. " AND pga.profile_group_id = " .$profile_group_id. "
        AND pga.identity_profile_id = ip.identity_profile_id AND pga.delete_ind = 0 AND active_ind = 1
        ORDER BY profile_name";

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
    $response["message"] = "No Collection found for selected profile and group.";
    echo json_encode($response);
    return;
}

//Determine if any groups have been created for specified profile id.
$response["profile_group_assign_data"] = array();
$sql = "SELECT identity_profile_id FROM profile_group
         WHERE delete_ind = 0 AND identity_profile_id = " .$identityProfileId;

$result = mysqli_query($con, $sql)  or  die(mysqli_error($con));
if (mysqli_num_rows($result) == 0) {
    $response["group_ret_code"] = 1;
    $response["message"] = "No profile groups have been created for selected profile.";
    echo json_encode($response);
    return;
}

//Get group data
$sql = "SELECT pg.group_name, pga.identity_profile_id FROM profile_group_assign pga, profile_group pg
         WHERE pg.profile_group_id = pga.profile_group_id
         AND pga.delete_ind = 0 AND pg.identity_profile_id = " .$identityProfileId. "
         ORDER BY identity_profile_id ASC, pga.profile_group_id ASC";

$result = mysqli_query($con, $sql)  or  die(mysqli_error($con));
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