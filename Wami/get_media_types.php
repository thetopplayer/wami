<?php
/**
 * get_media_types.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * Gets list of media types
 */
$response["media_type"] = array();
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT media_type FROM profiler_media_type WHERE delete_ind = 0";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        array_push($response["media_type"], $row[0]);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = -1;
    $response["message"] = "get_media_types.php: No profiler media type data found";
    echo json_encode($response);
}
?>
