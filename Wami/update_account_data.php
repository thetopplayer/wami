<?php
/**
 * update_account_data.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates user table.
 *
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$userId = $_POST["user_id"];
$password = $_POST["password"];
$first_name = $_POST["first_name"];
$last_name = $_POST["last_name"];
$email = $_POST["email"];
$street_address = $_POST["street_address"];
$city = $_POST["city"];
$state = $_POST["state"];
$country = $_POST["country"];
$zipcode = $_POST["zipcode"];
$telephone = $_POST["telephone"];
$active_ind = $_POST["active_ind"];

$db = new DB_CONNECT();
$con = $db->connect();

$sql = "UPDATE user SET first_name = '" .$first_name. "', last_name = '".$last_name. "', password = '" .$password. "', email = '".$email.
                    "', street_address = '" .$street_address. "', city = '".$city. "', state = '" .$state. "', country = '".$country.
                    "', zipcode = '" .$zipcode. "', telephone = '".$telephone. "', active_ind = " .$active_ind. ", modified_date = NOW()
                    WHERE user_id = " .$userId;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "update_account_data.php: Problem updating user table. MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}

$response["ret_code"] = 0;
$response["message"] = "Account data updated. ";
echo json_encode($response);
?>
