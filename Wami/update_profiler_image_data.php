<?php
/**
 * update_profiler_image_data.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates text fields associated with image.
 *
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$imageId = $_POST["image_id"];
$imageTitle = $_POST["image_title"];
$imageDescription = $_POST["image_description"];

$db = new DB_CONNECT();
$con = $db->connect();

$sql = "UPDATE profiler_image_gallery SET image_name = '" .$imageTitle. "', image_description = '".$imageDescription. "', modified_date = NOW()
                    WHERE profiler_image_gallery_id = " .$imageId;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "update_profiler_image_date.php: Problem updating profiler_image_gallery table. MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}

$response["ret_code"] = 0;
$response["message"] = "Image data updated. ";
echo json_encode($response);
?>