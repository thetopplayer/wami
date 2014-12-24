<?php
/**
 *
 * update_for_delete_account.php
 *
 * Created Rob Lanter
 * Date: 6/13/14
 * Time: 12:26 PM
 *
 * Delete an account.
 */
$response = array();
require_once __DIR__ . '/db_connect.php';
$user_id = $_POST["user_id"];
$db = new DB_CONNECT();
$con = $db->connect();

$sql = "SELECT identity_profile_id FROM identity_profile WHERE delete_ind = 0 AND user_id = " .$user_id;
$result_set = mysqli_query($con, $sql) or die(mysqli_error($con));
if (mysqli_num_rows($result_set) > 0) {
    $con->autocommit(FALSE);
    while ($row = mysqli_fetch_array($result_set)) {
        $identity_profile_id = $row["identity_profile_id"];
        try {

            // Update for delete identity_profile
            $sql =  "UPDATE identity_profile SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["ret_code"] = 1;
                $response["message"] = "update_for_delete_account.php: Problem updating identity_profile table. MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }

            //update for delete identity_profile_collection
            $sql =  "UPDATE identity_profile_collection SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id. "
             OR assign_to_identity_profile_id = " .$identity_profile_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["ret_code"] = 1;
                $response["message"] = "update_for_delete_account.php: Problem updating identity_profile_collection. MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }

            //Update for delete profile_group
            $sql =  "UPDATE profile_group SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["ret_code"] = 1;
                $response["message"] = "update_for_delete_account.php: Problem updating profile_group table. MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }

            //Update for delete profile_group_assign
            $sql =  "UPDATE profile_group_assign SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["ret_code"] = 1;
                $response["message"] = "update_for_delete_account.php: Problem updating profile_group_assign table. MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }

            //Update for delete profile_flash
            $sql =  "UPDATE profile_flash SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["ret_code"] = 1;
                $response["message"] = "update_for_delete_account.php: Problem updating profile_flash table. MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }

            //Update for delete identity_profiler
            $sql =  "UPDATE identity_profiler SET delete_ind = 1 WHERE identity_profile_id = " .$identity_profile_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["ret_code"] = 1;
                $response["message"] = "update_for_delete_account.php: Problem updating identity_profiler table. MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }

            // Update for delete user table
            $sql =  "UPDATE user SET delete_ind = 1 WHERE user_id = " .$user_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["ret_code"] = 1;
                $response["message"] = "update_for_delete_account.php: Problem updating user table. MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }

        } catch (Exception $e) {
            $response["ret_code"] = -1;
            $response["message"] = "update_for_delete_account.php: Transaction failed: " . $e->getMessage();
            $con->rollback();
            $con->autocommit(TRUE);
            echo json_encode($response);
            return;
        }
    }
}
$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Account deleted. ";
echo json_encode($response);

?>