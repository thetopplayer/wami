<?php
/**
 * update_for_delete_gallery_images.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates profiler_image_gallery table for soft delete.
 *
 */
require_once __DIR__ . '/db_connect.php';
$gallery_image_id = $_POST["image_ids_to_remove"];
$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$image_id = array();
$image_id = explode(",", $gallery_image_id);
$num_elements = count($image_id);

for ($i = 0; $i < $num_elements; $i++) {
    $sql =  "UPDATE profiler_image_gallery SET delete_ind = 1 WHERE profiler_image_gallery_id = " .$image_id[$i];

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        $response["message"] = "update_for_delete_gallery_images.php: Problem updating profiler_image_gallery table for soft delete. MySQL Error: " .mysqli_error($con);
        echo json_encode($response);
        exit(-1);
    }
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
echo json_encode($response);
?>
