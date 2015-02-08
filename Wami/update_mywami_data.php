<?php
/**
 * update_mywami_data.php
 *
 * Created by Rob Lanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Updates all data pertaining to  My Wami section of profile..
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$identity_profile_id = $_POST["identity_profile_id"];
$profile_name = $_POST["profile_name"];
$first_name = $_POST["first_name"];
$last_name = $_POST["last_name"];
$email = $_POST["email"];
$profile_type = $_POST["profile_type"];
$description = $_POST["description"];
$street_address = $_POST["street_address"];
$city = $_POST["city"];
$state = $_POST["state"];
$country = $_POST["country"];
$zipcode = $_POST["zipcode"];
$telephone = $_POST["telephone"];
$tags = $_POST["tags"];
$active_ind = $_POST["active_ind"];
$searchable = $_POST["searchable"];

$db = new DB_CONNECT();
$con = $db->connect();

$sql = "UPDATE identity_profile SET first_name = '" .$first_name. "', last_name = '".$last_name. "', profile_name = '" .$profile_name. "', email = '".$email.
    "', profile_type = '" .$profile_type. "', description = '".$description. "', tags = '".$tags.
    "', street_address = '" .$street_address. "', city = '".$city. "', state = '" .$state. "', country = '".$country.
    "', zipcode = '" .$zipcode. "', telephone = '".$telephone. "', active_ind = " .$active_ind. ", searchable = " .$searchable. ", modified_date = NOW()
        WHERE identity_profile_id = " .$identity_profile_id;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "update_account_data.php: Problem updating user table. MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}

$response["ret_code"] = 0;
$response["message"] = "Profile data updated. ";
echo json_encode($response);
?>
