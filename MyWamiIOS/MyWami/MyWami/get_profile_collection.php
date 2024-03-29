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
$jsonInput = file_get_contents('php://input');
$data = json_decode($jsonInput);
$identityProfileId = $data->param1;
    
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$response = array();
$sql = "SELECT ip.first_name, ip.last_name, image_url, profile_name, tags, ipc.identity_profile_id, assign_to_identity_profile_id, email, telephone
        FROM identity_profile_collection ipc, identity_profile ip
        WHERE ip.delete_ind = 0 AND ipc.delete_ind = 0 AND active_ind = 1 AND ipc.identity_profile_id = ip.identity_profile_id
        AND assign_to_identity_profile_id = " .$identityProfileId. "
        ORDER BY profile_name";

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
        $collection["email"] = $row["email"];
        $collection["telephone"] = $row["telephone"];

        array_push($response["profile_collection"], $collection);
    }
    $response["ret_code"] = 0;
    mysqli_free_result($result);
    echo json_encode($response);
} else {
    $response["ret_code"] = 1;
    $response["message"] = "No profile collection found";
    mysqli_free_result($result);
    echo json_encode($response);
}
?>