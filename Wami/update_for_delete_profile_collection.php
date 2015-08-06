<?php
/**
 * update_for_delete_profile_collection.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates identity_profile_collection table.
 *
 */
require_once __DIR__ . '/db_connect.php';
$num_elements = $_POST["num_profiles_to_remove"];
$assign_to_identity_profile_id = $_POST["assign_to_identity_profile_id"];
$identity_profile_id = array();
for ($i = 0; $i < $num_elements; $i++) {
    $identity_profile_id[$i] = $_POST["identity_profile_id" .$i];
}

$db = new DB_CONNECT();
$con = $db->connect();

$where = '';
for ($i = 0; $i < $num_elements; $i++) {
   $id = $identity_profile_id[$i];
   $where = $where. " identity_profile_id = " .$id. " OR ";
}

$where = substr($where, 0, -3);
$sql =  "UPDATE identity_profile_collection SET delete_ind = 1, modified_date = NOW() WHERE assign_to_identity_profile_id = " .$assign_to_identity_profile_id. " AND (" .$where. ")";

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "update_for_delete_profile_collection.php: Problem updating profile_collection table for soft delete. MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}
$response["ret_code"] = 0;
echo json_encode($response);
?>
