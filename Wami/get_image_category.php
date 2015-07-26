<?php
/**
 * get_image_category.php
 *
 * Created by IntelliJ IDEA.
 * User: robertlanter
 * Date: 5/31/14
 * Time: 3:36 PM
 *
 * Get category associated with image
 */
$image_id = $_POST["image_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT category FROM profiler_image_gallery WHERE delete_ind = 0 AND profiler_image_gallery_id = " .$image_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "get_image_category.php: Problem getting category for image: " .$image_id. ". MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $row = mysqli_fetch_row($result);
    $response["category"] =  $row[0];
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No category found for specified image.";
    echo json_encode($response);
}

