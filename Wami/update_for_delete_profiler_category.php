<?php
/**
 * update_for_delete_profiler_category.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates profiler_category table.
 *
 */
require_once __DIR__ . '/db_connect.php';
$profiler_ids_to_remove = $_POST["profiler_ids_to_remove"];
$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$profiler_id = array();
$profiler_id = explode("," ,$profiler_ids_to_remove);
$num_elements = count($profiler_id);

for ($i = 0; $i < $num_elements; $i++) {
    $sql =  "UPDATE identity_profiler SET delete_ind = 1 WHERE identity_profiler_id = " .$profiler_id[$i];

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        $response["message"] = "update_for_delete_profiler_category.php: Problem updating identity_profiler table for soft delete. MySQL Error: " .mysqli_error($con);
        echo json_encode($response);
        exit(-1);
    }
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
echo json_encode($response);
?>
