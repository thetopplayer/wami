<?php
/**    
 * get_profile_flash_data.php
 * 
 * Created by robert lanter
 * User: robertlanter
 * Date: 3/12/14
 * Time: 12:48 AM
 *
 * gets flash data
 */
$jsonInput = file_get_contents('php://input');
$data = json_decode($jsonInput);
$identity_profile_id = $data->param1;
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT identity_profile_id, flash, media_type, media_url, create_date FROM profile_flash WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY create_date DESC";
$response = array();
$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["profile_flash_data"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $flash = array();
        $flash["identity_profile_id"] = $row["identity_profile_id"];
        $flash["flash"] = $row["flash"];
        $flash["media_url"] = $row["media_url"];
        $flash["create_date"] = $row["create_date"];
        array_push($response["profile_flash_data"], $flash);
    }
    $response["ret_code"] = 0;
    echo json_encode($response);
} else {
    $response["ret_code"] = 1;
    $response["message"] = "No profile flash data found";
    echo json_encode($response);
}
?>