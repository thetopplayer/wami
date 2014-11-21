<?php
/**
 * insert_to_image_gallery.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 *
 * Inserts image to image gallery
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$identity_profile_id = $_POST["identity_profile_id"];
$profile_name = $_POST["profile_name"];
$file_name = $_POST["file_name"];
$image_description = $_POST["image_description"];
$image_name = $_POST["image_name"];
$category = $_POST["category"];
if ($image_name === '') {
    $image_name = $file_name;
}
$image_src = $_POST["image_src"];
$delete_ind = 0;
$file_location = 'assets/image_gallery/' .$profile_name. '/';
$file_location_thumb = 'assets/image_gallery/' .$profile_name. '/thumbs/';

//get rid of file header then save to file system.
$image = strstr($image_src, ',');
$image = substr($image, 1);
$image = str_replace(' ', '+', $image);
$data = base64_decode($image);

$byte_cnt = file_put_contents($file_location .$file_name, $data);
if ($byte_cnt < 1) {
    $response["ret_code"] = -9;
    $response["message"] = "insert_to_image_gallery: Problem writing image file to file system";
    echo json_encode($response);
    exit(-1);
}

$byte_cnt = file_put_contents($file_location_thumb .$file_name, $data);
if ($byte_cnt < 1) {
    $response["ret_code"] = -9;
    $response["message"] = "insert_to_image_gallery: Problem writing image thumbnail file to file system";
    unlink($file_location .$file_name);
    echo json_encode($response);
    exit(-1);
}

// create thumb
$file_type = explode('.', $file_name);
$location = $file_location_thumb .$file_name;
list($width_orig, $height_orig) = getimagesize($location);
if (preg_match('/jpg|jpeg/', $file_type[1])) {
    $img = imagecreatefromjpeg($location);
    if ($img === false) {
        $response["ret_code"] = -9;
        $response["message"] = "insert_to_image_gallery: Problem converting image to thumbnail. JPG image not created!";
        unlink($file_location .$file_name);
        unlink($file_location_thumb .$file_name);
        echo json_encode($response);
        exit(-1);
    }
    $tmp_img = imagecreatetruecolor(100, 100);
    imagecopyresampled($tmp_img, $img, 0, 0, 0, 0, 100, 100, $width_orig, $height_orig);
    imagejpeg($tmp_img, $location, 100);
    imagedestroy($img);
}
if (preg_match('/png/', $file_type[1])) {
    $img = imagecreatefrompng($location);
    if ($img ===  false) {
        $response["ret_code"] = -9;
        $response["message"] = "insert_to_image_gallery: Problem converting image to thumbnail. PNG image not created!";
        unlink($file_location .$file_name);
        unlink($file_location_thumb .$file_name);
        echo json_encode($response);
        exit(-1);
    }
    $tmp_img = imagecreatetruecolor(100, 100);
    imagealphablending($tmp_img, false);
    imagesavealpha($tmp_img, false);
    imagecopyresampled($tmp_img, $img, 0, 0, 0, 0, 100, 100, $width_orig, $height_orig);
    imagepng($tmp_img, $location, 0);
    imagedestroy($img);
}
if (preg_match('/gif/', $file_type[1])) {
    $img = imagecreatefromgif($location);
    if ($img ===  false) {
        $response["ret_code"] = -9;
        $response["message"] = "insert_to_image_gallery: Problem converting image to thumbnail. GIF image not created!";
        unlink($file_location .$file_name);
        unlink($file_location_thumb .$file_name);
        echo json_encode($response);
        exit(-1);
    }
    $tmp_img = imagecreatetruecolor(100, 100);
    imagecopyresampled($tmp_img, $img, 0, 0, 0, 0, 100, 100, $width_orig, $height_orig);
    imagegif($tmp_img, $location, 100);
    imagedestroy($img);
}

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

try {
    $sql = "INSERT INTO profiler_image_gallery (identity_profile_id, category, file_location, file_name, image_name, image_description, delete_ind, modified_date, create_date)
            VALUES (".$identity_profile_id.", '".$category."', '".$file_location_thumb."', '".$file_name."', '".$image_name."',  '".$image_description."', ".$delete_ind.", NOW(), NOW())";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "insert_to_image_gallery: Problem inserting new image: " .$file_name. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        unlink($file_location .$file_name);
        unlink($file_location_thumb .$file_name);
        echo json_encode($response);
        exit(-1);
    }
} catch (Exception $e) {
    $response["ret_code"] = -1;
    $response["message"] = "insert_to_image_gallery.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    unlink($file_location .$file_name);
    unlink($file_location_thumb .$file_name);
    echo json_encode($response);
    return;
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Image uploaded successfully. ";
echo json_encode($response);

?>
