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
$identityProfileId = $_POST["param1"];
$profile_group_id = $_POST["param2"];
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();

$sql = "SELECT first_name, last_name, image_url, profile_name, tags, ip.identity_profile_id, assign_to_identity_profile_id, rating, default_profile_ind
        FROM profile_group_assign pga, identity_profile ip
        WHERE  pga.assign_to_identity_profile_id = " .$identityProfileId. " AND pga.profile_group_id = " .$profile_group_id. "
        AND pga.identity_profile_id = ip.identity_profile_id AND  pga.delete_ind = 0 AND active_ind = 1";

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
    echo json_encode($response);
} else {
    $response["profile_ret_code"] = 1;
    $response["message"] = "No Collection found for selected profile and group.";
    mysqli_free_result($result);
    echo json_encode($response);
}
?>