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
$audio_titles = $_POST["audio_names"];
$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$ids = array();
$ids = explode(",", $audio_ids);
$descriptions = array();
$descriptions = explode(",", $audio_descriptions);
$titles = array();
$titles = explode(",", $audio_titles);
$num_elements = count($ids);

for ($i = 0; $i < $num_elements; $i++) {
    $sql =  "UPDATE profiler_audio_jukebox SET audio_file_name = '" .$titles[$i]. "', audio_file_description =  '" .$descriptions[$i]. "' WHERE profiler_audio_jukebox_id = " .$ids[$i];

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        $response["message"] = "update_edited_audio_text.php: Problem updating profiler_audio_jukebox_id table for edited auddio text. MySQL Error: " .mysqli_error($con);
        echo json_encode($response);
        exit(-1);
    }
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
echo json_encode($response);
?>
