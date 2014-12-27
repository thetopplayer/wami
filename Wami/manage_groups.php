<?php
/**
 * manage_groups.php
 *
 * Created by Robert Lanter
 * Date: 5/15/14
 * Time: 6:10 PM
 *
 * Manage groups assigned to profiles
 */
require_once __DIR__ . '/db_connect.php';
$selected_profile_id = $_POST["selected_profile_id"];
$assign_to_identity_profile_id = $_POST["assign_to_identity_profile_id"];
$selected_group_id_list = explode(',', $_POST["selected_group_id_list"]);
$manage_state = $_POST["manage_state"];
$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$selected_group_id = null;
$num_selected_groups = count($selected_group_id_list);
for ($i = 0; $i < $num_selected_groups; $i++) {
    $exists = false;
    $selected_group_id = $selected_group_id_list[$i];
    $sql = "SELECT count(*) FROM profile_group_assign WHERE profile_group_id = " .$selected_group_id.
        " AND identity_profile_id = " .$selected_profile_id;

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_row($result);
        $num_groups_assigned = $row[0];
        if ($num_groups_assigned > 0) {
            $exists = true;
        }
    }
    mysqli_free_result($result);

    if ($manage_state === "remove") {
        try {
            $sql = "UPDATE profile_group_assign SET delete_ind = 1 WHERE profile_group_id = " .$selected_group_id.
                " AND identity_profile_id = " .$selected_profile_id;
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["message"] = "manage_groups.php: Problem updating Group Assign. MySQL Error: " .mysqli_error($con);
                $response["ret_code"] = -1;
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }
        } catch (Exception $e) {
            $response["ret_code"] = -1;
            $response["message"] = "manage_groups.php: Transaction failed: " . $e->getMessage();
            $con->rollback();
            $con->autocommit(TRUE);
            echo json_encode($response);
            return;
        }
    }

    if ($manage_state === "assign") {
        if ($exists) {
            try {
                $sql = "UPDATE profile_group_assign SET delete_ind = 0 WHERE profile_group_id = " .$selected_group_id.
                    " AND identity_profile_id = " .$selected_profile_id;
                $result = mysqli_query($con, $sql) or die(mysqli_error($con));
                if (!$result) {
                    $response["message"] = "manage_groups.php: Problem updating Group Assign. MySQL Error: " .mysqli_error($con);
                    $response["ret_code"] = -1;
                    $con->rollback();
                    $con->autocommit(TRUE);
                    echo json_encode($response);
                    exit(-1);
                }
            } catch (Exception $e) {
                $response["ret_code"] = -1;
                $response["message"] = "manage_groups.php: Transaction failed: " . $e->getMessage();
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                return;
            }
        }
        else {
            $delete_ind = 0;
            try {
                $sql = "INSERT INTO profile_group_assign (assign_to_identity_profile_id, identity_profile_id, profile_group_id, delete_ind, create_date, modified_date)
                    VALUES ( ".$assign_to_identity_profile_id. ","  .$selected_profile_id. ", " .$selected_group_id. ", " . $delete_ind. ", NOW(), NOW())";
                $result = mysqli_query($con, $sql) or die(mysqli_error($con));
                if (!$result) {
                    $response["message"] = "manage_groups.php: Problem inserting Group Assign. MySQL Error: " .mysqli_error($con);
                    $response["ret_code"] = -1;
                    $con->rollback();
                    $con->autocommit(TRUE);
                    echo json_encode($response);
                    exit(-1);
                }
            } catch (Exception $e) {
                $response["ret_code"] = -1;
                $response["message"] = "manage_groups.php: Transaction failed: " . $e->getMessage();
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                return;
            }
        }
    }
}
$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "Groups assigned/removed successfully. ";
echo json_encode($response);

?>
