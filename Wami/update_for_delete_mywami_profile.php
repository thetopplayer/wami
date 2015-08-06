<?php
/**
 *
 * update_for_delete_mywami_profile.php
 *
 * Created Rob Lanter
 * Date: 6/13/14
 * Time: 12:26 PM
 *
 * Delete a MyWami profile identity.
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$identity_profile_id = $_POST["identity_profile_id"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT default_profile_ind FROM identity_profile WHERE default_profile_ind = 1 AND identity_profile_id = " .$identity_profile_id;
$result = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result) > 0) {
    $response["ret_code"] = -1;
    $response["message"] = "You are not allowed to delete the Default Profile. Set another profile as the default, then you can delete this one. ";
    echo json_encode($response);
    return;
}

try {
    $con->autocommit(FALSE);
    // Update for delete identity_profile
    $sql =  "UPDATE identity_profile SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating identity_profile table. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //update for delete identity_profile_collection
    $sql =  "UPDATE identity_profile_collection SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id. "
             OR assign_to_identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating identity_profile_collection. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete profile_group
    $sql =  "UPDATE profile_group SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating profile_group table. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete profile_group_assign
    $sql =  "UPDATE profile_group_assign SET delete_ind = 1, modified_date = NOW() WHERE assign_to_identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating profile_group_assign table. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete profile_flash
    $sql =  "UPDATE profile_flash SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating profile_flash table. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete identity_profiler
    $sql =  "UPDATE identity_profiler SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating identity_profiler table. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete image media type
    $sql =  "UPDATE profiler_image_gallery SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating image gallery data. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete audio media type
    $sql =  "UPDATE profiler_audio_jukebox SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating audio file data. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete text media type
    $sql =  "UPDATE profiler_text_files SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating text file data. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Update for delete pdf media type
    $sql =  "UPDATE profiler_pdf_files SET delete_ind = 1, modified_date = NOW() WHERE identity_profile_id = " .$identity_profile_id;
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = 1;
        $response["message"] = "update_for_delete_mywami_profile.php: Problem updating pdf file data. MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    $con->commit();

} catch (Exception $e) {
    $response["ret_code"] = -2;
    $response["message"] = "update_for_delete_mywami_profile.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    echo json_encode($response);
    return;
}

$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Identity Profile deleted. ";
echo json_encode($response);

?>