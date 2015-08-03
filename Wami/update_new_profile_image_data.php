<?php
/**
 * update_new_profile_image_data.php
 *
 * Created Byr: Robert Lanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Saves profile image data
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$file_name = $_POST["file_name"];
$identity_profile_id = $_POST["identity_profile_id"];
$image_src = $_POST["image_src"];

$db = new DB_CONNECT();
$con = $db->connect();

//get rid of file header then save to file system as a .png
$image = strstr($image_src, ',');
$image = substr($image, 1);
$image = str_replace(' ', '+', $image);
$data = base64_decode($image);
$byte_cnt = file_put_contents("assets/main_image/" .$file_name, $data);
if ($byte_cnt < 1) {
    $response["ret_code"] = -1;
    $response["message"] = "update_new_profile_image_data: Problem writing image thumbnail file to file system";
    echo json_encode($response);
    exit(-1);
}

//get rid of file type extension. File name is saved without the .png.
$file_name = substr($file_name, 0, -4);
$sql = "UPDATE identity_profile SET image_url = '" .$file_name. "', modified_date = NOW()
        WHERE identity_profile_id = " .$identity_profile_id;

$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (!$result) {
    $response["ret_code"] = -1;
    $response["message"] = "update_new_profile_image_data.php: Problem updating identity_profile table. MySQL Error: " .mysqli_error($con);
    echo json_encode($response);
    exit(-1);
}

$response["ret_code"] = 0;
$response["message"] = "New profile image saved. ";
echo json_encode($response);
?>
