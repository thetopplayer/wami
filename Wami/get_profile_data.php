<?php
/**
 * get_profile_data.php
 *
 * Created by Robert Lanter
 * Date: 5/15/14
 * Time: 6:10 PM
 *
 * Gets identity profile data keyed by identity_profile_id.
 */
$identity_profile_id = $_POST["identity_profile_id"];
$from_identity_profile_id = $_POST["from_identity_profile_id"];

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();

$sql = "SELECT first_name, last_name, profile_name, image_url, email, profile_type, street_address, city, state, zipcode, country, telephone,
        create_date, tags, searchable, active_ind, description
        FROM identity_profile WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response["identity_profile_data"] =  array();
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $item["first_name"] = $row[0];
    $item["last_name"] = $row[1];
    $item["profile_name"] = $row[2];
    $item["image_url"] = $row[3];
    $item["email"] = $row[4];
    $item["profile_type"] = $row[5];
    $item["street_address"] = $row[6];
    $item["city"] = $row[7];
    $item["state"] = $row[8];
    $item["zipcode"] = $row[9];
    $item["country"] = $row[10];
    $item["telephone"] = $row[11];
    $item["create_date"] = $row[12];
    $item["tags"] = $row[13];
    $item["searchable"] = $row[14];
    $item["active_ind"] = $row[15];
    $item["description"] = $row[16];
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Identity Profile data found";
    echo json_encode($response);
    return;
}

$sql = "SELECT first_name, last_name, profile_name, email
        FROM identity_profile WHERE delete_ind = 0 AND identity_profile_id = " .$from_identity_profile_id;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $item["from_first_name"] = $row[0];
    $item["from_last_name"] = $row[1];
    $item["from_profile_name"] = $row[2];
    $item["from_email"] = $row[3];

    array_push($response["identity_profile_data"], $item);
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Identity Profile data found";
    echo json_encode($response);
}

?>
