<?php
/**
 * get_profiler_id.php
 *
 * Created by Robert Lanter
 * User: robertlanter
 * Date: 2/3/14
 * Time: 2:48 PM
 *
 * Gets list of identity profiler ids
 */
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];

$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT identity_profiler_id FROM identity_profiler WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY category";

$response = array();
$response["ret_code"] = 0;
$result = mysqli_query($con, $sql)  or  die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["identity_profiler_ids"] = array();
    while ($row = mysqli_fetch_array($result)) {
        array_push($response["identity_profiler_ids"], $row[0]);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "get_profiler_id.php: No identity profiler ids found";
    echo json_encode($response);
}
?>
