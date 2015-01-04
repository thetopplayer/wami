<?php
/**
 * update_for_delete_profiler_category.php
 *
 * Created Rob Lanter
 * Date: 5/9/14
 * Time: 1:53 PM
 *
 * Updates profiler_category table.
 *
 */
require_once __DIR__ . '/db_connect.php';
$profiler_ids_to_remove = $_POST["profiler_ids_to_remove"];
$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$profiler_id = array();
$profiler_id = explode("," ,$profiler_ids_to_remove);
$num_elements = count($profiler_id);
$result = null;

for ($i = 0; $i < $num_elements; $i++) {
    $sql =  "UPDATE identity_profiler SET delete_ind = 1 WHERE identity_profiler_id = " .$profiler_id[$i];

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        $response["message"] = "update_for_delete_profiler_category.php: Problem updating identity_profiler table for soft delete. MySQL Error: " .mysqli_error($con);
        echo json_encode($response);
        exit(-1);
    }

    $sql = "SELECT identity_profile_id, category FROM identity_profiler WHERE identity_profiler_id = " .$profiler_id[$i];
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        if ($row = mysqli_fetch_array($result)) {
            $identity_profile_id = $row["identity_profile_id"];
            $category = $row["category"];
            try {

                //Update for delete image media type
                $sql =  "UPDATE profiler_image_gallery SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";
                $result = mysqli_query($con, $sql) or die(mysqli_error($con));
                if (!$result) {
                    $response["ret_code"] = -1;
                    $response["message"] = "update_for_delete_profiler_category.php: Problem updating image gallery data. MySQL Error: " .mysqli_error($con);
                    $con->rollback();
                    $con->autocommit(TRUE);
                    echo json_encode($response);
                    exit(-1);
                }

                //Update for delete audio media type
                $sql =  "UPDATE profiler_audio_jukebox SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";
                $result = mysqli_query($con, $sql) or die(mysqli_error($con));
                if (!$result) {
                    $response["ret_code"] = -1;
                    $response["message"] = "update_for_delete_profiler_category.php: Problem updating audio file data. MySQL Error: " .mysqli_error($con);
                    $con->rollback();
                    $con->autocommit(TRUE);
                    echo json_encode($response);
                    exit(-1);
                }

                //Update for delete text media type
                $sql =  "UPDATE profiler_text_files SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";
                $result = mysqli_query($con, $sql) or die(mysqli_error($con));
                if (!$result) {
                    $response["ret_code"] = -1;
                    $response["message"] = "update_for_delete_profiler_category.php: Problem updating text file data. MySQL Error: " .mysqli_error($con);
                    $con->rollback();
                    $con->autocommit(TRUE);
                    echo json_encode($response);
                    exit(-1);
                }

                //Update for delete pdf media type
                $sql =  "UPDATE profiler_pdf_files SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";
                $result = mysqli_query($con, $sql) or die(mysqli_error($con));
                if (!$result) {
                    $response["ret_code"] = -1;
                    $response["message"] = "update_for_delete_profiler_category.php: Problem updating pdf file data. MySQL Error: " .mysqli_error($con);
                    $con->rollback();
                    $con->autocommit(TRUE);
                    echo json_encode($response);
                    exit(-1);
                }

            }
            catch (Exception $e) {
                $response["ret_code"] = -1;
                $response["message"] = "update_for_delete_profiler_category.php: Transaction failed: " . $e->getMessage();
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                return;
            }
        }
    }
}

$con->commit();
$con->autocommit(TRUE);;
$response["ret_code"] = 0;
echo json_encode($response);
?>
