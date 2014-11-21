<?php
/**
 * get_text_data.php
 *
 * Created by Rob Lanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Gets Text data for Profiler section of mywami.
 */
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$category = $_POST["category"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql_file = "SELECT file_location, file_name, text_file_name, text_file_description FROM profiler_text_files " .
    " WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";

$response_file["file"] = array();
$result_file = mysqli_query($con, $sql_file) or die(mysql_error($con));
if (mysqli_num_rows($result_file) > 0) {
    $row_file = mysqli_fetch_row($result_file);
    $file = array();
    $file["file_location"]  = $row_file[0];
    $file["file_name"]  = $row_file[1];
    $file["text_file_name"]  = $row_file[2];
    $file["text_file_description"]  = $row_file[3];
    $file["category"] = $category;

    $contents = file_get_contents($row_file[0] .$row_file[1]);
    $file["contents"]  = $contents;

    array_push($response_file["file"], $file);
    $response_file["ret_code"] = 0;
    $response_file["message"] = "Successfully refreshed profiler Text data ";
    echo json_encode($response_file);

} else {
    $response_file["ret_code"] = 1;
    $response_file["message"] = "Refresh Text data: No profiler Text data found for category: " .$category;
    echo json_encode($response_file);
}
?>

