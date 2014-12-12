<?php
/**
 * check_account_data.php
 *
 * Created Rob Lanter
 * Date: 5/27/14
 * Time: 9:42 PM
 *
 * Check account data for duplicate username and email address
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$cur_username = $_POST["username"];
$email = $_POST["email"];
$account_status = $_POST["account_status"];
$db = new DB_CONNECT();
$con = $db->connect();

if ($account_status === 'new') {
    $sql = "SELECT * FROM user WHERE delete_ind = 0 AND username = '" . $cur_username . "'";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        $response["ret_code"] = -1;
        $response["message"] = "Username already exists, choose another one!";
        echo json_encode($response);
        return;
    }

    $sql = "SELECT * FROM user WHERE delete_ind = 0 AND email = '" .$email. "'";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        $response["ret_code"] = -1;
        $response["message"] = "Email address is already being used, choose another one!";
        echo json_encode($response);
        return;
    }
    $response["ret_code"] = 0;
    $response["message"] = "Success";
    echo json_encode($response);
}

if ($account_status === 'update') {
    $sql = "SELECT username, email FROM user WHERE delete_ind = 0 AND email = '" . $email . "'";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_row($result);
        $username = $row[0];
        $cur_email = $row[1];
        if ($username === $cur_username and $cur_email === $email) {
            $response["ret_code"] = 0;
            $response["message"] = "Success";
            echo json_encode($response);
            return;
        }
        $response["ret_code"] = -1;
        $response["message"] = "Email address is already being used, choose another one!";
        echo json_encode($response);
        return;
    }
    $response["ret_code"] = 0;
    $response["message"] = "Success";
    echo json_encode($response);
    return;
}
?>