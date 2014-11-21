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
$identityProfileId = $_POST["param1"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT ip.first_name, ip.last_name, image_url, profile_name, tags, ipc.identity_profile_id, assign_to_identity_profile_id
        FROM identity_profile_collection ipc, identity_profile ip
        WHERE ip.delete_ind = 0 AND ipc.delete_ind = 0 AND ipc.identity_profile_id = ip.identity_profile_id AND assign_to_identity_profile_id = " .$identityProfileId;

$result = mysqli_query($con, $sql) or  die(mysql_error($con));
$response["profile_collection"] = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $collection = array();
        $collection["first_name"] = $row["first_name"];
        $collection["last_name"] = $row["last_name"];
        $collection["profile_name"] = $row["profile_name"];
        $collection["image_url"] = $row["image_url"];
        $collection["tags"] = $row["tags"];
        $collection["identity_profile_id"] = $row["identity_profile_id"];
        $collection["assign_to_identity_profile_id"] = $row["assign_to_identity_profile_id"];

        array_push($response["profile_collection"], $collection);
    }
    $response["success"] = 1;
    echo json_encode($response);
} else {
    $response["success"] = 0;
    $response["message"] = "No profile collection found";
    echo json_encode($response);
}
?>