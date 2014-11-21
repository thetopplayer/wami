<?php
/**
 * update_default_profile.php
 *
 * Created by Rob Lanter
 *
 * Date: 6/16/14
 * Time: 6:22 PM
 *
 * Updates identity_profile table to set a default profile
 */

require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$user_id = $_POST["user_id"];

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

// First set all default ind to 0
try {
    $sql =  "UPDATE identity_profile SET default_profile_ind = 0 WHERE user_id = " .$user_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $response["message"] = "1: update_default_profile.php: Problem updating identity_profile table setting default. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    // Then assign default ind to the correct identity profile
    $sql =  "UPDATE identity_profile SET default_profile_ind = 1 WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $response["message"] = "2: update_default_profile.php: Problem updating identity_profile table setting default. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }
} catch (Exception $e) {
    $response["ret_code"] = -1;
    $response["message"] = "update_default_profile.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    echo json_encode($response);
    return;
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Default Profile updated. ";
echo json_encode($response);
?>