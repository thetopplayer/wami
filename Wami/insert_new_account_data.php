<?php
/**
 * insert_new_account_data.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts new account
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$username= $_POST["username"];
$password = $_POST["password"];
$first_name = $_POST["first_name"];
$last_name = $_POST["last_name"];
$email = $_POST["email"];
$profile_name = $_POST["profile_name"];
$active_ind = 1;
$delete_ind = 0;
$user_id = '';
$identity_profile_id = '';
$default_profile_ind = 1;

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);
try {
    // Create user
    $sql = "INSERT INTO user (username, password, first_name, last_name, email, active_ind, delete_ind, create_date, modified_date)
            VALUES ('".$username."', '".$password."','".$first_name."','".$last_name."','".$email."',".$active_ind.", ".$delete_ind.", NOW(), NOW())";

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "insert_new_account_data: Problem creating new account: " .$username. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    $sql = "SELECT user_id FROM user WHERE delete_ind = 0 AND username = '" .$username. "' and password = '" .$password. "'";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_row($result);
        $user_id = $row[0];
    }
    else {
        $response["message"] = "insert_new_account_data: Problem getting user id: " .$username. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    // Create default profile
    $sql = "INSERT INTO identity_profile (user_id, profile_name, first_name, last_name, email, active_ind, delete_ind, default_profile_ind, image_url, create_date, modified_date)
            VALUES (".$user_id.", '".$profile_name."','".$first_name."','".$last_name."', '".$email."',".$active_ind.", ".$delete_ind.",  ".$default_profile_ind.",'defaultimage', NOW(), NOW())";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "insert_new_account_data: Problem creating default profile: " .$username. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    $sql = "SELECT identity_profile_id FROM identity_profile WHERE delete_ind = 0 AND user_id = " .$user_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_row($result);
        $identity_profile_id = $row[0];
    }
    else {
        $response["message"] = "insert_new_account_data: Problem getting identity profile id: " .$username. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    // Create first profile in collection which is default profile previously created
    $sql = "INSERT INTO identity_profile_collection (assign_to_identity_profile_id, identity_profile_id, from_identity_profile_id, transmission_receive_date, transmission_accept_date, transmission_status, delete_ind, create_date, modified_date)
            VALUES (".$identity_profile_id.", ".$identity_profile_id.", ".$identity_profile_id.", NOW(), NULL, 'A', ".$delete_ind.", NOW(), NOW())";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "insert_new_account_data: Problem adding profile to collection: " .$username. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }
} catch (Exception $e) {
    $response["ret_code"] = -1;
    $response["message"] = "insert_new_account_data.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    echo json_encode($response);
    return;
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Account and default profile created. ";
echo json_encode($response);
?>