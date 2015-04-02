<?php
/**
 * get_profiler_data.php
 *
 * Created by robertlanter
 * Date: 5/26/14
 * Time: 9:12 PM
 *
 * Get all data pertaining to identity_profiler.
 */
$jsonInput = file_get_contents('php://input');
$data = json_decode($jsonInput);
$identity_profile_id = $data->param1;

require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT identity_profiler_id, identity_profile_id, category, media_type FROM identity_profiler WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id.
    " ORDER BY category";

$response = array();
$response["message"] = array();
$result = mysqli_query($con, $sql)  or  die(mysqli_error($con));
if (!$result) {
    $response["db_error"] = "get_profiler_data(1): Problem accessing profiler data: " .$identity_profile_id. " MySQL Error: " .mysqli_error($con);
    $response["ret_code"] = -1;
    echo json_encode($response);
    exit(-1);
}
if (mysqli_num_rows($result) > 0) {
    $response["identity_profiler_data"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $profiler = array();
        $profiler["identity_profiler_id"] = $row["identity_profiler_id"];
        $profiler["identity_profile_id"] = $row["identity_profile_id"];
        $profiler["category"] = $row["category"];
        $profiler["media_type"] = $row["media_type"];

        if ($row["media_type"] == 'Image') {
            $profiler["file"] = get_image_gallery_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["file"] === -1) {
                $response["no_images_ret_code"] = 1;
                array_push($response["message"], "INFO ALERT: No Profiler Images found for this profile!");
            }
        }

        if ($row["media_type"] == 'Text') {
            $profiler["file"] = get_text_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["file"] === -1) {
                $response["no_text_ret_code"] = 1;
                array_push($response["message"], "INFO ALERT: No Profiler Text File uploaded for this profile!");
            }
        }

        if ($row["media_type"] == 'PDF') {
            $profiler["file"] = get_PDF_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["file"] === -1) {
                $response["no_pdf_ret_code"] = 1;
                array_push($response["message"], "INFO ALERT: No Profiler PDF File uploaded for this profile!");
            }
        }

        if ($row["media_type"] == 'Audio') {
            $profiler["file"] = get_audio_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["file"] === -1) {
                $response["no_audio_ret_code"] = 1;
                array_push($response["message"], "INFO ALERT: No Profiler Audio Files found for this profile!");
            }
        }
        array_push($response["identity_profiler_data"], $profiler);
    }
}
else {
    $response["no_categories_ret_code"] = 1;
    array_push($response["message"], "INFO ALERT: No Profiler Categories found for this profile!");
}
$response["ret_code"] = 0;
mysqli_free_result($result);
echo json_encode($response);

return;

// get text files
function get_text_data($identity_profile_id, $category, $con) {
    $sql_file = "SELECT file_location, file_name, text_file_name, text_file_description FROM profiler_text_files " .
        " WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";

    $response_file["file"] = array();
    $result_file = mysqli_query($con, $sql_file) or die(mysqli_error($con));
    if (mysqli_num_rows($result_file) > 0) {
        $row_file = mysqli_fetch_row($result_file);
        $file = array();
        $file["file_location"]  = $row_file[0];
        $file["file_name"]  = $row_file[1];
        $file["text_file_name"]  = $row_file[2];
        $file["text_file_description"]  = $row_file[3];
        $file["category"] = $category;
    }
    else {
        return -1;
    }

    mysqli_free_result($result_file);
    return ($file);
}

// get PDF files
function get_PDF_data($identity_profile_id, $category, $con) {
    $sql_file = "SELECT file_location, file_name, pdf_file_name, pdf_file_description FROM profiler_pdf_files " .
        " WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";

    $response_file["file"] = array();
    $result_file = mysqli_query($con, $sql_file) or die(mysqli_error($con));
    if (mysqli_num_rows($result_file) > 0) {
        $row_file = mysqli_fetch_row($result_file);
        $file = array();
        $file["file_location"]  = $row_file[0];
        $file["file_name"]  = $row_file[1];
        $file["pdf_file_name"]  = $row_file[2];
        $file["pdf_file_description"]  = $row_file[3];
        $file["category"] = $category;
    }
    else {
        return -1;
    }

    mysqli_free_result($result_file);
    return ($file);
}

// get Audio files
function get_audio_data ($identity_profile_id, $category, $con) {
    $sql_audio = "SELECT profiler_audio_jukebox_id, file_location, file_name, audio_file_name, audio_file_description FROM profiler_audio_jukebox " .
        " WHERE delete_ind = 0 AND category = '" .$category. "' AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY create_date ASC";

    $audio_files["audio"] = array();
    $result_audio = mysqli_query($con, $sql_audio)  or  die(mysqli_error($con));
    $audio_file = array();
    if (mysqli_num_rows($result_audio) > 0) {
        while ($row_audio = mysqli_fetch_array($result_audio)) {
            $audio_file["profiler_audio_jukebox_id"] = $row_audio["profiler_audio_jukebox_id"];
            $audio_file["file_location"]  = $row_audio["file_location"];
            $audio_file["file_name"]  = $row_audio["file_name"];
            $audio_file["audio_file_name"]  = $row_audio["audio_file_name"];
            $audio_file["audio_file_description"]  = $row_audio["audio_file_description"];
            $audio_file["category"]  = $category;

            array_push($audio_files["audio"], $audio_file);
        }
    }
    else {
        return -1;
    }
    mysqli_free_result($result_audio);
    return $audio_files;
}

//Get images for image gallery
function get_image_gallery_data($identity_profile_id, $category, $con) {
    $sql_image = "SELECT profiler_image_gallery_id, file_location, file_name, image_name, image_description FROM profiler_image_gallery " .
        " WHERE delete_ind = 0 AND category = '" .$category. "' AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY create_date ASC";

    $image_files["image"] = array();
    $result_image = mysqli_query($con, $sql_image)  or  die(mysqli_error($con));
    $image_file = array();
    if (mysqli_num_rows($result_image) > 0) {
        while ($row_image = mysqli_fetch_array($result_image)) {
            $image_file["profiler_image_gallery_id"] = $row_image["profiler_image_gallery_id"];
            $image_file["file_location"]  = $row_image["file_location"];
            $image_file["file_name"]  = $row_image["file_name"];
            $image_file["image_name"]  = $row_image["image_name"];
            $image_file["image_description"]  = $row_image["image_description"];
            $image_file["category"]  = $category;

            array_push($image_files["image"], $image_file);
        }
    }
    else {
        return -1;
    }
    mysqli_free_result($result_image);
    return $image_files;
}
?>