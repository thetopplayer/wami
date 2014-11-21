<?php
/**
 * get_user_data.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Gets user info
 */
$response = array();
$username = $_POST["username"];
$password = $_POST["password"];

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT user_id, username, password FROM user WHERE delete_ind = 0 AND username = '" .$username. "' and password = '" .$password. "'";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["user_info"] =  array();
    $row = mysqli_fetch_row($result);
    $user["user_id"] = $row[0];
    $user["username"] = $row[1];
    $user["password"] = $row[2];

    array_push($response["user_info"], $user);
    $response["ret_code"] = 0;
    $response["message"] = "Success, user logged in.";
    echo json_encode($response);
    return;
}
else {
    $response["ret_code"] = -1;
    $response["message"] = "User not found. Check username or password or create a new account!";
    echo json_encode($response);
    return;
}
?>