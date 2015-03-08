<?php
/**
 * get_default_profile_collection.php
 *
 * Created by Rob Lanter
 *
 * Date: 5/15/14
 * Time: 7:13 PM
 *
 *  List of profiles collected by user. Users Wami Network, or Wami List
 */
$jsonInput = file_get_contents('php://input');
$data = json_decode($jsonInput);
$user_id = $data->param1;

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$response = array();
$sql = "SELECT u2.first_name, u2.last_name, image_url, profile_name, tags, ipc.identity_profile_id, assign_to_identity_profile_id, ip2.email, ip2.telephone
        FROM identity_profile_collection ipc, identity_profile ip2, user u2
        WHERE ip2.delete_ind = 0 AND ipc.delete_ind = 0 AND ipc.identity_profile_id = ip2.identity_profile_id AND u2.user_id = ip2.user_id AND assign_to_identity_profile_id =
        (SELECT identity_profile_id FROM user u, identity_profile ip
         WHERE ip.delete_ind = 0 AND u.user_id = " .$user_id. " AND u.user_id = ip.user_id AND default_profile_ind = 1)
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
    $response["message"] = "No default profile collection found";
    mysqli_free_result($result);
    echo json_encode($response);
}
?>