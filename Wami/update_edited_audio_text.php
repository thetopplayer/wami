<?php
/**
 * update_edited_audio_text.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates edited audio text.
 *
 */
require_once __DIR__ . '/db_connect.php';
$audio_ids = $_POST["audio_ids"];
$audio_descriptions = $_POST["audio_descriptions"];
$audio_titles = $_POST["audio_titles"];
$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$ids = array();
$ids = explode(",", $audio_ids);

$num_elements = count($id);

for ($i = 0; $i < $num_elements; $i++) {
    $sql =  "UPDATE profiler_audio_jukebox SET delete_ind = 1 WHERE profiler_audio_jukebox_id = " .$id[$i];

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        $response["message"] = "update_for_delete_audio_files.php: Problem updating profiler_audio_jukebox_id table for soft delete. MySQL Error: " .mysqli_error($con);
        echo json_encode($response);
        exit(-1);
    }
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
echo json_encode($response);
?>
