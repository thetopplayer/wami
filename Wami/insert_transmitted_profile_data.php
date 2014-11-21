<?php
/**
 * insert_transmitted_profile_data.php
 *
 * Created by Rob Lanter
 * Date: 2/23/14
 * Time: 2:19 PM
 *
 * Transmit profile to another profile
 */
require_once __DIR__ . '/db_connect.php';

$profile_ids_to_transmit = array();
$transmit_to_profile_name = array();
$no_profile_name_found = '';
$record_exist_in_collection = '';
$response =  array();
$response["no_records_found"] = array();
$response["record_already_exist"] = array();
$result = '';
$num_profile_name_not_exist = 0;
$num_profiles_transmitted = 0;

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

$num_profiles_to_transmit = $_POST["num_profiles_to_transmit"];
$from_profile_id = $_POST["from_profile_id"];
$num_transmit_to_profile = $_POST["num_transmit_to_profile"];
for ($i = 0; $i < $num_profiles_to_transmit; $i++) {
    $profile_ids_to_transmit[$i] = $_POST["profile_ids_to_transmit" .$i];
}

for ($i = 0; $i < $num_transmit_to_profile; $i++) {
    $transmit_to_profile_name[$i] = $_POST["transmit_to_profile" .$i];
    $to_profile_name = $transmit_to_profile_name[$i];
    $sql = "SELECT identity_profile_id FROM identity_profile WHERE delete_ind = 0 AND profile_name = '" .$to_profile_name."'";

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["db_error"] = "Problem transmitting WAMI to profile(1): " .$to_profile_name. " MySQL Error: " .mysqli_error($con);
        $con->rollback();
        $con->autocommit(TRUE);
        echo json_encode($response);
        exit(-1);
    }

    //Check if profile name exists
    $row_count = $result->num_rows;
    if ($row_count < 1) {
        $num_profile_name_not_exist++;
        $no_profile_name_found = "<br>Profile Name does not exist: <strong>" .$to_profile_name. "</strong>. Either send to email address or choose another name.";
        array_push($response["no_records_found"], $no_profile_name_found);
        continue;
    }

    $row = mysqli_fetch_row($result);
    $assign_to_profile_id = $row[0];
    for ($j = 0; $j < $num_profiles_to_transmit; $j++) {
        //Check for dups
        $sql = "SELECT identity_profile_collection_id, profile_name FROM identity_profile_collection ipc, identity_profile ip
                WHERE ipc.delete_ind = 0 AND assign_to_identity_profile_id = " .$assign_to_profile_id. " AND ipc.identity_profile_id = " .$profile_ids_to_transmit[$j].
                " AND ipc.identity_profile_id = ip.identity_profile_id";
        $result = mysqli_query($con, $sql) or die(mysqli_error($con));
        if (!$result) {
            $response["db_error"] = "Problem transmitting WAMI to profile(2): " .$to_profile_name. " MySQL Error: " .mysqli_error($con);
            $con->rollback();
            $con->autocommit(TRUE);
            echo json_encode($response);
            exit(-1);
        }
        $row_count = $result->num_rows;
        if ($row_count > 0) {
            $row = mysqli_fetch_row($result);
            $profile_name = $row[1];
            $record_exist_in_collection = "<br>Profile: <strong>" .$profile_name. " </strong> already exists in the collection for " .$to_profile_name;
            array_push($response["record_already_exist"], $record_exist_in_collection);
            continue;
        }
        try {
            $sql = "INSERT INTO identity_profile_collection (assign_to_identity_profile_id, identity_profile_id, from_identity_profile_id,
                    transmission_receive_date, transmission_accept_date, transmission_status, delete_ind, create_date, modified_date)
                    VALUES(" .$assign_to_profile_id. "," .$profile_ids_to_transmit[$j]. "," .$from_profile_id. ",  NOW(), NULL , 'NA', 0, NOW(), NOW())";
            $result = mysqli_query($con, $sql) or die(mysqli_error($con));
            if (!$result) {
                $response["db_error"] = "Problem transmitting WAMI to profile(3): " .$to_profile_name. " MySQL Error: " .mysqli_error($con);
                $con->rollback();
                $con->autocommit(TRUE);
                echo json_encode($response);
                exit(-1);
            }
            $num_profiles_transmitted++;
        } catch (Exception $e) {
            $response["db_error"] = "insert_transmitted_profile_data.php: Transaction failed: " . $e->getMessage();
            $con->rollback();
            $con->autocommit(TRUE);
            echo json_encode($response);
            exit(-1);
        }
    }
}

$con->commit();
$con->autocommit(TRUE);
$response["num_profiles_transmitted"] = $num_profiles_transmitted;
$response["num_profile_name_not_exist"] = $num_profile_name_not_exist;
echo json_encode($response);

?>