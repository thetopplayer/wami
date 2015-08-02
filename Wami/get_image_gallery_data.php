<?php
/**
 * get_image_gallery_data.php
 *
 * Created by Rob Lanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Gets data for profiler image gallery section of mywami.
 */
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$category = $_POST["category"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profiler_image_gallery_id, file_location, file_name, image_name, image_description FROM profiler_image_gallery " .
    " WHERE delete_ind = 0 AND category = '" .$category. "' AND identity_profile_id = " .$identity_profile_id.
    " ORDER BY image_name ASC";

$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["images"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $images = array();
        $images["profiler_image_gallery_id"] = $row["profiler_image_gallery_id"];
        $images["file_location"]  = $row["file_location"];
        $images["file_name"]  = $row["file_name"];
        $images["image_name"]  = $row["image_name"];
        $images["image_description"]  = $row["image_description"];
        $images["category"]  = $category;

        array_push($response["images"], $images);
    }
    $response["ret_code"] = 0;
    $response["message"] = "Successfully accessed profiler Image Gallery images.";
    echo json_encode($response);
} else {
    $response["ret_code"] = 1;
    $response["message"] = "Image Gallery: No profiler Image Gallery images found";
    echo json_encode($response);
}
?>

