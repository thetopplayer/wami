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
$selected_item = $_POST["param1"];
$search_str = $_POST["param2"];
//$search_context = $_POST["param3"];

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();
$condition = '';

if ($selected_item === "Profile Name") {
    $condition = "profile_name LIKE '%" .$search_str. "%'";
}
if ($selected_item === "First Name") {
    $condition = "first_name LIKE '%" .$search_str. "%'";
}
if ($selected_item === "Last Name") {
    $condition = "last_name LIKE '%" .$search_str. "%'";
}
if ($selected_item === "Tags") {
    $condition = "tags LIKE '%" .$search_str. "%'";
}
if ($selected_item === "Description") {
    $condition = "description LIKE '%" .$search_str. "%'";
}

// get profile data
$sql = "SELECT first_name, last_name, profile_name, image_url, email, tags, rating, description, identity_profile_id
        FROM identity_profile WHERE " .$condition. " AND delete_ind = 0 AND searchable = 1 AND active_ind = 1 ";

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
        $item["rating"] = $row[6];
        $item["description"] = $row[7];
        $item["identity_profile_id"] = $row[8];
        array_push($response["profile_list"], $item);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Profile data found for search string: <strong>" .$search_str. "</strong>";
    echo json_encode($response);
    exit(-1);
}

?>