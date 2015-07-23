<?php
/**
 * insert_profiler_categories.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts new profiler categories
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$identity_profile_id = $_POST["identity_profile_id"];
$num_categories = $_POST["num_categories"];
$max_categories = $_POST["max_categories"];
$profile_name = $_POST["profile_name"];
$delete_ind = 0;
$url = '';
$file_type = '';
$categories = array();
$media_types = array();

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$index = 0;
for ($i = 0; $i < $max_categories; $i++) {
    if (isset($_POST["category_names" .$i])) {
        $categories[$index] = $_POST["category_names" .$i];
        $media_types[$index] = $_POST["media_types" .$i];
        $index++;
    }
}

for ($i = 0; $i < $num_categories; $i++) {
    try {
        $sql = "INSERT INTO identity_profiler (identity_profile_id, category, media_type, delete_ind, create_date, modified_date)
                VALUES (".$identity_profile_id.", '".$categories[$i]."', '".$media_types[$i]."', ".$delete_ind.", NOW(), NOW())";
        $result = mysqli_query($con, $sql) or die(mysqli_error($con));
        if (!$result) {
            $response["message"] = "insert_profiler_categories: Problem creating profile categories: " .$categories[$i]. " MySQL Error: " .mysqli_error($con);
            $response["ret_code"] = -1;
            $con->rollback();
            $con->autocommit(TRUE);
            echo json_encode($response);
            exit(-1);
        }

        $file_location = '';
        $file_name = '';
        $table_name = '';
        $delete_ind = 0;
        if ($media_types[$i] === "Text") {
            $table_name = "profiler_text_files";
            $file_location = "assets/text_files/" .$profile_name. "/";
            $file_name = 'default_text.txt';
            $exists = file_exists($file_location);
            if (!$exists) {
                mkdir($file_location, 0777);
            }
            copy('assets/default/default_text.txt', $file_location. "default_text.txt");
        }
        if ($media_types[$i] === "PDF") {
            $table_name = "profiler_pdf_files";
            $file_location = "assets/pdf_files/" .$profile_name. "/";
            $file_name = 'default_pdf.pdf';
            $exists = file_exists($file_location);
            if (!$exists) {
                mkdir($file_location, 0777);
            }
            copy('assets/default/default_pdf.pdf', $file_location. "default_pdf.pdf");
        }

        if ($media_types[$i] === "Image") {
            $file_location = "assets/image_gallery/" .$profile_name. "/";
            $exists = file_exists($file_location);
            if (!$exists) {
                mkdir($file_location, 0777);
            }

            $file_location_thumb = "assets/image_gallery/" .$profile_name. "/thumbs/";
            $exists = file_exists($file_location_thumb);
            if (!$exists) {
                mkdir($file_location_thumb, 0777);
            }
        }
        if ($media_types[$i] === "Audio") {
            $file_location = "assets/audio/" .$profile_name. "/";
            $exists = file_exists($file_location);
            if (!$exists) {
                mkdir($file_location, 0777);
            }
        }

        if ($media_types[$i] === "PDF" || $media_types[$i] === "Text") {
            $sql = "INSERT INTO " . $table_name . " (identity_profile_id, category, file_location, file_name, delete_ind, create_date, modified_date)
                        VALUES (" . $identity_profile_id . ", '" . $categories[$i] . "', '" . $file_location . "', '" . $file_name . "', " . $delete_ind . ", NOW(), NOW())";
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["message"] = "insert_profiler_categories: Problem inserting record into media table MySQL Error: " . mysqli_error($con);
                $response["ret_code"] = -1;
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }
        }

    } catch (Exception $e) {
        $response["ret_code"] = -1;
        $response["message"] = "insert_profiler_categories.php: Transaction failed: " . $e->getMessage();
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        return;
    }
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Profile categories created. ";
echo json_encode($response);
?>

