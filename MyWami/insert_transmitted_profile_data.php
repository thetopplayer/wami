<?php
/**
 * insert_transmitted_profile_data.php
 *
 * Created by Rob Lanter
 *
 * Date: 2/23/14
 * Time: 2:19 PM
 *
 * Insert profiles into profile collections
 */
$json = file_get_contents('php://input');
$data = json_decode($json);
require_once __DIR__ . '/db_connect.php';

$profiles_to_transmit = array();
$transmit_to_profiles = array();
$no_profile_name_found = '';
$record_exist_in_collection = '';
$response =  array();
$response["no_records_found"] = array();
$response["record_already_exist"] = array();
$response["sql"] = array();
$result = '';
$num_profile_name_not_exist = 0;
$num_profiles_transmitted = 0;

$num_to_transmit = $data->num_to_transmit;
$num_transmit_to = $data->num_transmit_to;
$from_profile_id = $data->from_profile_id;
$profiles_to_transmit = $data->profiles_to_transmit;
$transmit_to_profiles = $data->transmit_to_profiles;

$db = new DB_CONNECT();
$con = $db->connect();

$transmit_to_profiles_array = array();
$transmit_to_str = substr($transmit_to_profiles, 1, -1);
$start_str = $transmit_to_str;
$beg_pos = 0;
for ($i = 0; $i < $num_transmit_to; $i++) {
    $end_pos = strpos($transmit_to_str, ",");
    if ($end_pos === false) {
        $transmit_to_profiles_array[$i] = trim(substr($transmit_to_str, 0));
        break;
    }
    $transmit_to_profiles_array[$i] = trim(substr($transmit_to_str, $beg_pos, $end_pos));
    $beg_pos = $end_pos + 1;
    $end_pos = strlen($transmit_to_str);
    $transmit_to_str = substr($start_str, $beg_pos, $end_pos);
}

$profiles_to_transmit_array = array();
$to_transmit_str = substr($profiles_to_transmit, 1, -1);
$start_str = $to_transmit_str;
$beg_pos = 0;
for ($i = 0; $i < $num_to_transmit; $i++) {
    $end_pos = strpos($to_transmit_str, ",");
    if ($end_pos === false) {
        $profiles_to_transmit_array[$i] = trim(substr($to_transmit_str, 0));
        break;
    }
    $profiles_to_transmit_array[$i] = trim(substr($to_transmit_str, $beg_pos, $end_pos));
    $beg_pos = $end_pos + 1;
    $end_pos = strlen($to_transmit_str);
    $to_transmit_str = substr($start_str, $beg_pos, $end_pos);
}

for ($i = 0; $i < $num_transmit_to; $i++) {
    $to_profile_name = $transmit_to_profiles_array[$i];
    //Get profile_id. ALso make sure profile exists.
    $sql = "SELECT identity_profile_id FROM identity_profile WHERE delete_ind = 0 AND profile_name = '" .$to_profile_name."'";
    array_push($response["sql"], "*****select for exist_sql=" .$sql);

    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["db_error"] = "insert_transmitted_profile_data: Problem transmitting WAMI to profile(1): " .$to_profile_name. " MySQL Error: " .mysqli_error($con);
        echo json_encode($response);
        exit(-1);
    }

    //Check if profile name exists
    $row_count = $result->num_rows;
    if ($row_count < 1) {
        $num_profile_name_not_exist++;
        $no_profile_name_found = "insert_transmitted_profile_data: Profile Name does not exist: " .$to_profile_name. ". Either send to email address or choose another name.";
        array_push($response["no_records_found"], $no_profile_name_found);
        continue;
    }

    $row = mysqli_fetch_row($result);
    $assign_to_profile_id = $row[0];
    for ($j = 0; $j < $num_to_transmit; $j++) {
        //Check for dups
        $sql = "SELECT identity_profile_collection_id, profile_name FROM identity_profile_collection ipc, identity_profile ip
                WHERE ipc.delete_ind = 0 AND assign_to_identity_profile_id = " .$assign_to_profile_id. " AND ipc.identity_profile_id = " .$profiles_to_transmit_array[$j].
                " AND ipc.identity_profile_id = ip.identity_profile_id";
        array_push($response["sql"],"*****select for dups_sql=" .$sql);


        $result = mysqli_query($con, $sql) or die(mysqli_error($con));
        if (!$result) {
            $response["db_error"] = "insert_transmitted_profile_data: Problem transmitting WAMI to profile(2): " .$to_profile_name. " MySQL Error: " .mysqli_error($con);
            echo json_encode($response);
            exit(-1);
        }
        $row_count = $result->num_rows;
        if ($row_count > 0) {
            $row = mysqli_fetch_row($result);
            $profile_name = $row[1];
            $record_exist_in_collection = "Profile: " .$profile_name. " already exists in the collection for " .$to_profile_name;
            array_push($response["record_already_exist"], $record_exist_in_collection);
            continue;
        }
        $sql = "INSERT INTO identity_profile_collection (assign_to_identity_profile_id, identity_profile_id, from_identity_profile_id,
                transmission_receive_date, transmission_accept_date, transmission_status, delete_ind, create_date, modified_date)
                VALUES(" .$assign_to_profile_id. "," .$profiles_to_transmit_array[$j]. "," .$from_profile_id. ",  NOW(), NULL , 'NA', 0, NOW(), NOW())";
        array_push($response["sql"], "*****Insert_sql=" .$sql);

        $result = mysqli_query($con, $sql) or die(mysqli_error($con));
        if (!$result) {
            $response["db_error"] = "insert_transmitted_profile_data: Problem transmitting WAMI to profile(3): " .$to_profile_name. " MySQL Error: " .mysqli_error($con);
            echo json_encode($response);
            exit(-1);
        }
        $num_profiles_transmitted++;
    }
}
$response["num_profiles_transmitted"] = $num_profiles_transmitted;
$response["num_profile_name_not_exist"] = $num_profile_name_not_exist;
echo json_encode($response);

?>
