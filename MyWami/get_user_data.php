<?php
/**
 * get_user_data.php
 *
 * Created by Robert Lanter
 * Date: 5/15/14
 * Time: 6:10 PM
 *
 * Gets user data from login
 */
$response = array();
$username = $_POST["param1"];
$password = $_POST["param2"];

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT user_id, username, password
        FROM user
        WHERE delete_ind = 0 AND username = '" .$username. "' and password = '" .$password. "'";

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["db_error"] = "get_user_data: Problem accessing user data: " .$username. " MySQL Error: " .mysqli_error($con);
    $response["ret_code"] = -1;
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $response["user_info"] =  array();
    $row = mysqli_fetch_row($result);
    $user["user_id"] = $row[0];
    $user["username"] = $row[1];
    $user["password"] = $row[2];

    array_push($response["user_info"], $user);
    $response["ret_code"] = 1;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 0;
    $response["message"] = "User not found. Username or Password might be incorrect.";
    echo json_encode($response);
}
?>