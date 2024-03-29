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
$identity_profile_id = $_POST["identity_profile_id"];
require_once __DIR__ . '/db_connect.php';
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT identity_profiler_id, identity_profile_id, category, media_type FROM identity_profiler WHERE delete_ind = 0 AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY category";

$response = array();
$response["message"] = array();
$response["ret_code"] = 0;
$result = mysqli_query($con, $sql)  or  die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["identity_profiler_data"] = array();
    while ($row = mysqli_fetch_array($result)) {
        $profiler = array();
        $profiler["identity_profiler_id"] = $row["identity_profiler_id"];
        $profiler["identity_profile_id"] = $row["identity_profile_id"];
        $profiler["category"] = $row["category"];
        $profiler["media_type"] = $row["media_type"];

        if ($row["media_type"] == 'Image') {
            $profiler["images"] = get_image_gallery_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["images"] === -1) {
                $response["ret_code"] = 1;
                array_push($response["message"], "No Profiler Images found for this profile.  ");
//                continue;
            }
        }

        if ($row["media_type"] == 'Text') {
            $profiler["file"] = get_text_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["file"] === -1) {
                $response["ret_code"] = 1;
                array_push($response["message"], "No Profiler Text File uploaded for this profile.  ");
            }
        }

        if ($row["media_type"] == 'PDF') {
            $profiler["file"] = get_PDF_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["file"] === -1) {
                $response["ret_code"] = 1;
                array_push($response["message"], "No Profiler PDF File uploaded for this profile.  ");
            }
        }

        if ($row["media_type"] == 'Audio') {
            $profiler["file"] = get_audio_data($row["identity_profile_id"], $row["category"], $con);
            if ($profiler["file"] === -1) {
                $response["ret_code"] = 1;
                array_push($response["message"], "No Profiler Audio Files found for this profile.  ");
//                continue;
            }
        }
        array_push($response["identity_profiler_data"], $profiler);
    }
} else {
    $response["ret_code"] = 1;
    array_push($response["message"], "No Profiler Media Info found for this profile.  ");
}
if ($response["ret_code"] > 0) echo json_encode($response);
else {
    $response["ret_code"] = 0;
    echo json_encode($response);
}
mysqli_free_result($result);
return;

//Get images for image gallery
function get_image_gallery_data($identity_profile_id, $category, $con) {
    $sql_image = "SELECT profiler_image_gallery_id, file_location, file_name, image_name, image_description FROM profiler_image_gallery " .
        " WHERE delete_ind = 0 AND category = '" .$category. "' AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY image_name ASC";

    $response_images["images"] = array();
    $result_image = mysqli_query($con, $sql_image)  or  die(mysqli_error($con));
    if (mysqli_num_rows($result_image) > 0) {
        while ($row_image = mysqli_fetch_array($result_image)) {
            $images = array();
            $images["profiler_image_gallery_id"] = $row_image["profiler_image_gallery_id"];
            $images["file_location"]  = $row_image["file_location"];
            $images["file_name"]  = $row_image["file_name"];
            $images["image_name"]  = $row_image["image_name"];
            $images["image_description"]  = $row_image["image_description"];
            $images["category"]  = $category;

            array_push($response_images["images"], $images);
        }
    } else {
        return -1;
    }
    mysqli_free_result($result_image);
    return $response_images;
}

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

        $contents = file_get_contents($row_file[0] .$row_file[1]);
        $file["contents"]  = $contents;

        array_push($response_file["file"], $file);
    } else {
        return -1;
    }
    mysqli_free_result($result_file);
    return ($response_file);
}

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

        array_push($response_file["file"], $file);
    } else {
        return -1;
    }
    mysqli_free_result($result_file);
    return ($response_file);
}

function get_audio_data ($identity_profile_id, $category, $con) {
    $sql_audio = "SELECT profiler_audio_jukebox_id, file_location, file_name, audio_file_name, audio_file_description FROM profiler_audio_jukebox " .
        " WHERE delete_ind = 0 AND category = '" .$category. "' AND identity_profile_id = " .$identity_profile_id.
        " ORDER BY audio_file_name ASC";

    $response_audio["audio"] = array();
    $result_audio = mysqli_query($con, $sql_audio)  or  die(mysqli_error($con));
    if (mysqli_num_rows($result_audio) > 0) {
        while ($row_audio = mysqli_fetch_array($result_audio)) {
            $audio_files = array();
            $audio_files["profiler_audio_jukebox_id"] = $row_audio["profiler_audio_jukebox_id"];
            $audio_files["file_location"]  = $row_audio["file_location"];
            $audio_files["file_name"]  = $row_audio["file_name"];
            $audio_files["audio_file_name"]  = $row_audio["audio_file_name"];
            $audio_files["audio_file_description"]  = $row_audio["audio_file_description"];
            $audio_files["category"]  = $category;

            array_push($response_audio["audio"], $audio_files);
        }
    } else {
        return -1;
    }
    mysqli_free_result($result_audio);
    return $response_audio;
}