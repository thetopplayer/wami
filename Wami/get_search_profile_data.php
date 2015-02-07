<?php
/**
 * get_search_profile_data.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * get list of profiles from search criteria
 */
$selected_item = $_POST["selected_item"];
$search_str = $_POST["search_str"];
$search_context = $_POST["search_context"];
$identity_profile_id = $_POST["identity_profile_id"];

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();
$condition = '';

if ($selected_item === "profile_name") {
    $condition = "profile_name LIKE '%" .$search_str. "%'";
}
if ($selected_item === "first_name") {
    $condition = "first_name LIKE '%" .$search_str. "%'";
}
if ($selected_item === "last_name") {
    $condition = "last_name LIKE '%" .$search_str. "%'";
}
if ($selected_item === "tag_keyword") {
    $condition = "tags LIKE '%" .$search_str. "%'";
}
if ($selected_item === "description") {
    $condition = "description LIKE '%" .$search_str. "%'";
}

// get profile data
if ($identity_profile_id === '') {
    $sql = "SELECT first_name, last_name, profile_name, image_url, email, tags, description
            FROM identity_profile WHERE " .$condition. " AND delete_ind = 0 AND searchable = 1 AND active_ind = 1 ";
}
else {
    $sql = "SELECT first_name, last_name, profile_name, image_url, email, tags, description
            FROM identity_profile_collection ipc, identity_profile ip WHERE " .$condition. " AND assign_to_identity_profile_id = " .$identity_profile_id. "
            AND ipc.identity_profile_id = ip.identity_profile_id AND ipc.delete_ind = 0 AND searchable = 1 AND active_ind = 1 ";
}

$response["message"] = array();
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response["profile_list"] = array();

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $item = array();
        $item["first_name"] = $row[0];
        $item["last_name"] = $row[1];
        $item["profile_name"] = $row[2];
        $item["image_url"] = $row[3];
        $item["email"] = $row[4];
        $item["tags"] = $row[5];
        $item["description"] = $row[6];
        array_push($response["profile_list"], $item);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Wami Profiles found for search string: <strong>" .$search_str. "</strong>";
    echo json_encode($response);
    exit(-1);
}

?>