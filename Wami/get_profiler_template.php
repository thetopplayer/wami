<?php
/**
 * get_profiler_template.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * Gets list of profiler templates
 */
$response["template"] = array();
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT template FROM profiler_template WHERE delete_ind = 0";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));

if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        array_push($response["template"], $row[0]);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = -1;
    $response["message"] = "get_profiler_template.php: No profiler template data found";
    echo json_encode($response);
}
?>
