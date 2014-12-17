<?php
/**
 * get_account_data.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * Gets user account information
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$userId = $_POST["user_id"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT username, password, first_name, last_name, email, street_address, city, state, country, zipcode, telephone, active_ind, create_date
        FROM user WHERE delete_ind = 0 AND user_id = " .$userId;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));

if (mysqli_num_rows($result) > 0) {
    $response["account_profile"] =  array();
    $accountProfile = array();
    $row = mysqli_fetch_row($result);
    $accountProfile["username"] = $row[0];
    $accountProfile["password"] = $row[1];
    $accountProfile["first_name"] = $row[2];
    $accountProfile["last_name"] = $row[3];
    $accountProfile["email"] = $row[4];
    $accountProfile["street_address"] = $row[5];
    $accountProfile["city"] = $row[6];
    $accountProfile["state"] = $row[7];
    $accountProfile["country"] = $row[8];
    $accountProfile["zipcode"] = $row[9];
    $accountProfile["telephone"] = $row[10];
    $accountProfile["active_ind"] = $row[11];
    $accountProfile["create_date"] = $row[12];

    array_push($response["account_profile"], $accountProfile);
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = -1;
    $response["message"] = "No account data found";
    echo json_encode($response);
}
?>