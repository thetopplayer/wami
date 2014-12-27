<?php
/**
 * get_extended_profile_data.php
 *
 * Created by robertlanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * get extended profile data for profiles selected from collection list.
 */
$identity_profile_id = $_POST["identity_profile_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();

//get MyWami data
$sql = "SELECT first_name, last_name, profile_name, image_url, email, profile_type, street_address, city, state, zipcode, country, telephone,
        create_date, tags, searchable, active_ind, description
        FROM identity_profile WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response["identity_profile_data"] =  array();
$item = array();
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

    array_push($response["identity_profile_data"], $item);
    $response["ret_code"] = 0;
}
else {
    $response["ret_code"] = -1;
    $response["message"] = "get_extended_profile_data.php: No Identity Profile found";
    echo json_encode($response);
    exit(-1);
}
mysqli_free_result($result);

//get flash data
$sql = "SELECT identity_profile_id, flash, media_type, media_url, create_date FROM profile_flash WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id.
    " ORDER BY create_date DESC";
$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["profile_flash_data"] = array();

    while ($row = mysqli_fetch_array($result)) {
        $item = array();
        $item["identity_profile_id"] = $row["identity_profile_id"];
        $item["flash"] = $row["flash"];
        $item["media_url"] = $row["media_url"];
        $item["create_date"] = $row["create_date"];
        array_push($response["profile_flash_data"], $item);
    }
    $response["flash_ret_code"] = 0;
}
else {
    $response["flash_ret_code"] = 1;
    $response["message"] = "No profile flash data found";
}
mysqli_free_result($result);
echo json_encode($response);

?>