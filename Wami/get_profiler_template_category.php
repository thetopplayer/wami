<?php
/**
 * get_profiler_template_category.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * Gets list of profiler category for a template
 */
$response["category"] = array();
require_once __DIR__ . '/db_connect.php';
$template = $_POST["template"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT category, media_type FROM profiler_template_category WHERE delete_ind = 0 AND template = '" .$template. "'";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));

$category_info = array();
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $category_info["category"] = $row[0];
        $category_info["media_type"] = $row[1];
        array_push($response["category"], $category_info);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = -1;
    $response["message"] = "get_profiler_template_category.php: No profiler category data found";
    echo json_encode($response);
}
?>
