<?php
/**
 * insert_to_audio_jukebox.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts audio files
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$identity_profile_id = $_POST["identity_profile_id"];
$profile_name = $_POST["profile_name"];
$file_name = $_POST["file_name"];
$audio_file_description = $_POST["audio_file_description"];
$audio_file_name = $_POST["audio_file_name"];
$category = $_POST["category"];
if ($audio_file_name === '') {
    $audio_file_name = $file_name;
}
$audio_file_src = $_POST["audio_file_src"];
$delete_ind = 0;
$file_location = 'assets/audio/' .$profile_name. '/';

$audio = strstr($audio_file_src, ',');
$audio = substr($audio, 1);
$audio = str_replace(' ', '+', $audio);
$data = base64_decode($audio);

$byte_cnt = file_put_contents($file_location .$file_name, $data);
if ($byte_cnt < 1) {
    $response["ret_code"] = -9;
    $response["message"] = "insert_to_audio_jukebox: Problem writing audio file to file system";
    echo json_encode($response);
    exit(-1);
}

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

try {
    $sql = "INSERT INTO profiler_audio_jukebox (identity_profile_id, category, file_location, file_name, audio_file_name, audio_file_description, delete_ind, modified_date, create_date)
            VALUES (".$identity_profile_id.", '".$category."', '".$file_location."', '".$file_name."', '".$audio_file_name."',  '".$audio_file_description."', ".$delete_ind.", NOW(), NOW())";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "insert_to_audio_jukebox.php: Problem inserting new audio file: " .$file_name. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        unlink($file_location .$file_name);
        echo json_encode($response);
        exit(-1);
    }
} catch (Exception $e) {
    $response["ret_code"] = -1;
    $response["message"] = "insert_to_audio_jukebox.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    unlink($file_location .$file_name);
    echo json_encode($response);
    return;
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Audio file uploaded successfully. ";
echo json_encode($response);

?>
