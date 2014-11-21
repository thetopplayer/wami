<?php
/**
 * get_mywami_data.php
 *
 * Created by robertlanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Get all data pertaining to identity_profile_id.
 */
$identity_profile_id = $_POST["identity_profile_id"];
$username = $_POST["username"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

//get MyWami data
$sql = "SELECT first_name, last_name, profile_name, image_url, email, profile_type, street_address, city, state, zipcode, country, telephone,
        create_date, tags, searchable, active_ind, description
        FROM identity_profile WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;

$response = array();
$response["ret_code"] = 0;
$response["message"] = array();
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response["identity_profile_data"] =  array();
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $profile["first_name"] = $row[0];
    $profile["last_name"] = $row[1];
    $profile["profile_name"] = $row[2];
    $profile["image_url"] = $row[3];
    $profile["email"] = $row[4];
    $profile["profile_type"] = $row[5];
    $profile["street_address"] = $row[6];
    $profile["city"] = $row[7];
    $profile["state"] = $row[8];
    $profile["zipcode"] = $row[9];
    $profile["country"] = $row[10];
    $profile["telephone"] = $row[11];
    $profile["create_date"] = $row[12];
    $profile["tags"] = $row[13];
    $profile["searchable"] = $row[14];
    $profile["active_ind"] = $row[15];
    $profile["description"] = $row[16];
    array_push($response["identity_profile_data"], $profile);
}
else {
    $response["ret_code"] = -1;
    array_push($response["message"], "My Wami Profile: Error, no Identity Profiles found for user: " .$username);
    echo json_encode($response);
    exit(-1);
}

//get group data
$sql = "SELECT `group` FROM profile_group WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id;
$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["profile_group_data"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $group = array();
        $group["group"] = $row["group"];
        array_push($response["profile_group_data"], $group);
    }
}
else {
    $response["ret_code"] = 1;
    array_push($response["message"], "My Wami Profile: No Profile Groups found for profile: " .$profile["profile_name"]);
}

//get flash data
$sql = "SELECT profile_flash_id, identity_profile_id, flash, media_type, media_url, create_date FROM profile_flash WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY create_date DESC";
$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["profile_flash_data"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $flash = array();
        $flash["profile_flash_id"] = $row["profile_flash_id"];
        $flash["identity_profile_id"] = $row["identity_profile_id"];
        $flash["flash"] = $row["flash"];
        $flash["media_url"] = $row["media_url"];
        $flash["create_date"] = $row["create_date"];
        array_push($response["profile_flash_data"], $flash);
    }
}
else {
    $response["ret_code"] = 1;
    array_push($response["message"], "My Wami Profile: No Profile Flashes found for profile: " .$profile["profile_name"]);
}

if ($response["ret_code"] > 0) echo json_encode($response);
else {
    $response["ret_code"] = 0;
    echo json_encode($response);
}
?>
