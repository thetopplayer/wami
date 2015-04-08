<?php
/**
 * insert_flash.php
 *
 * Created Byr: Robert Lanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts new flash announcement
 */
$jsonInput = file_get_contents('php://input');
$data = json_decode($jsonInput);
$new_flash = $data->param1;
$identity_profile_id = $data->param2;
    
$priority = 5;
$sticky_ind = 0;
$delete_ind = 0;

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();
$response = array();
$sql = "INSERT INTO profile_flash (identity_profile_id, flash, priority, sticky_ind, delete_ind, create_date, modified_date)
            VALUES (".$identity_profile_id.", '".$new_flash."', ".$priority.", ".$sticky_ind.", ".$delete_ind.", NOW(), NOW())";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["message"] = "insert_flash: Problem inserting new flash announcement: MySQL Error: " .mysqli_error($con);
    $response["ret_code"] = -1;
    echo json_encode($response);
    exit(-1);
}

$response["ret_code"] = 0;
$response["message"] = "New flash announcement added ";
echo json_encode($response);
?>

