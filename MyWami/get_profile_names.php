<?php
/**
 * get_profile_names.php
 *
 * Created by Rob Lanter
 *
 * Date: 5/15/14
 * Time: 7:13 PM
 *
 *  Gets identity profile names for auto complete
 */
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profile_name FROM identity_profile WHERE delete_ind = 0 AND active_ind = 1";
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
$response = array();
$profile_names = array();
$index = 0;
if (mysqli_num_rows($result) > 0) {
    while ($row = mysqli_fetch_array($result)) {
        $profile_names[$index] = $row["profile_name"];
        $index++;
    }

    $response["ret_code"] = 0;
    $response["profile_names"] = $profile_names;
    echo json_encode($response);
}
else {
    $response["ret_code"] = 1;
    $response["message"] = "No Profile Names found";
    echo json_encode($response);
}

?>
