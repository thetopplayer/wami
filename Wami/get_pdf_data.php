<?php
/**
 * get_pdf_data.php
 *
 * Created by Rob Lanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Gets PDF data for Profiler section of mywami.
 */
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$category = $_POST["category"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql_file = "SELECT file_location, file_name, pdf_file_name, pdf_file_description FROM profiler_pdf_files " .
    " WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";

$response_file["file"] = array();
$result_file = mysqli_query($con, $sql_file) or die(mysqli_error($con));
if (mysqli_num_rows($result_file) > 0) {
    $row_file = mysqli_fetch_row($result_file);
    $file = array();
    $file["file_location"]  = $row_file[0];
    $file["file_name"]  = $row_file[1];
    $file["pdf_file_name"]  = $row_file[2];
    $file["pdf_file_description"]  = $row_file[3];
    $file["category"] = $category;

    array_push($response_file["file"], $file);
    $response_file["ret_code"] = 0;
    $response_file["message"] = "Successfully refreshed profiler PDF data ";
    echo json_encode($response_file);

} else {
    $response_file["ret_code"] = 1;
    $response_file["message"] = "Refresh Text data: No profiler PDF data found for category: " .$category;
    echo json_encode($response_file);
}
?>

