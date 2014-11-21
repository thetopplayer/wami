<?php
/**
 * insert_new_profile_data.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts new profile
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$profile_name = $_POST["profile_name"];
$email = $_POST["email"];
$user_id = $_POST["user_id"];
$identity_profile_id = '';
$active_ind = 1;
$delete_ind = 0;
$default_profile_ind = 0;
$rating = 0.0;

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

try {
    // Create profile
    $sql = "INSERT INTO identity_profile (user_id, profile_name, email, rating, default_profile_ind, active_ind, delete_ind, image_url, create_date, modified_date)
            VALUES (".$user_id.", '".$profile_name."', '".$email."', ".$rating.", ".$default_profile_ind.",  ".$active_ind.", ".$delete_ind.",'defaultimage', NOW(), NOW())";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "insert_new_profile_data: Problem creating profile: " .$profile_name. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    // Get profile id  needed to insert profile into collection
    $sql = "SELECT identity_profile_id FROM identity_profile WHERE delete_ind = 0 AND profile_name = '" .$profile_name. "' AND user_id = " .$user_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_row($result);
        $identity_profile_id = $row[0];
    }
    else {
        $response["message"] = "insert_new_profile_data: Problem getting identity profile id: " .$profile_name. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }
    // Create first profile in collection which is profile previously created
    $sql = "INSERT INTO identity_profile_collection (assign_to_identity_profile_id, identity_profile_id, from_identity_profile_id, transmission_receive_date, transmission_accept_date, transmission_status, delete_ind, create_date, modified_date)
            VALUES (".$identity_profile_id.", ".$identity_profile_id.", ".$identity_profile_id.", NOW(), NULL, 'A', ".$delete_ind.", NOW(), NOW())";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "insert_new_profile_data: Problem adding profile to collection: " .$profile_name. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }
} catch (Exception $e) {
    $response["ret_code"] = -1;
    $response["message"] = "insert_new_profile_data.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    echo json_encode($response);
    return;
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Profile created. ";
echo json_encode($response);
?>