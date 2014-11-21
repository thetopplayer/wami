<?php
/**
 * get_audio_jukebox_data.php
 *
 * Created by Rob Lanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Gets data for profiler audio jukebox section of mywami.
 */
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$category = $_POST["category"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT profiler_audio_jukebox_id, file_location, file_name, audio_file_name, audio_file_description FROM profiler_audio_jukebox " .
    " WHERE delete_ind = 0 AND category = '" .$category. "' AND identity_profile_id = " .$identity_profile_id.
    " ORDER BY create_date ASC";

$result = mysqli_query($con, $sql)  or  die(mysql_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["audio"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $audio_files = array();
        $audio_files["profiler_audio_jukebox_id"] = $row["profiler_audio_jukebox_id"];
        $audio_files["file_location"]  = $row["file_location"];
        $audio_files["file_name"]  = $row["file_name"];
        $audio_files["audio_file_name"]  = $row["audio_file_name"];
        $audio_files["audio_file_description"]  = $row["audio_file_description"];
        $audio_files["category"]  = $category;

        array_push($response["audio"], $audio_files);
    }
    $response["ret_code"] = 0;
    $response["message"] = "Successfully accessed profiler Audio Jukebox files ";
    echo json_encode($response);
} else {
    $response["ret_code"] = 1;
    $response["message"] = "Audio Jukebox: No profiler Audio Jukebox files found";
    echo json_encode($response);
}
?>

