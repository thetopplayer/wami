<?php
/**
 * update_text_file_info.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts Text file \
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$identity_profile_id = $_POST["identity_profile_id"];
$text_file_description = $_POST["description"];
$category = $_POST["category"];

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

try {
    $sql = "UPDATE profiler_text_files SET text_file_description = '" .$text_file_description. "', modified_date = NOW()
            WHERE identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "update_text_file_info: Problem updating text file description: " .$file_name. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        unlink($file_location .$file_name);
        echo json_encode($response);
        exit(-1);
    }
} catch (Exception $e) {
    $response["ret_code"] = -1;
    $response["message"] = "update_text_file_info.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    unlink($file_location .$file_name);
    echo json_encode($response);
    return;
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Text file description updated successfully. ";
echo json_encode($response);

?>
