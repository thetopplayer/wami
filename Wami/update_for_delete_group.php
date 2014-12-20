<?php
/**
 * update_for_delete_group.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates profile_group table.
 *
 */
require_once __DIR__ . '/db_connect.php';
$profile_group_id = $_POST["group_ids_to_remove"];
$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$group_id = array();
$group_id = explode("," ,$profile_group_id);
$num_elements = count($group_id);

for ($i = 0; $i < $num_elements; $i++) {
    $sql =  "UPDATE profile_group SET delete_ind = 1 WHERE profile_group_id = " .$group_id[$i];

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        $response["message"] = "update_for_delete_group.php: Problem updating profile_group table for soft delete. MySQL Error: " .mysqli_error($con);
        echo json_encode($response);
        exit(-1);
    }
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
echo json_encode($response);
?>
