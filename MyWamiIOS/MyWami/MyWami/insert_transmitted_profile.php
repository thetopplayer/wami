<?php
    /**
     * insert_transmitted_profile.php
     *
     * Created by Rob Lanter
     *
     * Date: 2/23/14
     * Time: 2:19 PM
     *
     * Insert profiles into profile collections
     */
    $profiles_to_transmit = array();
       $transmit_to_profile = '';
    
    $json = file_get_contents('php://input');
    $data = json_decode($json);
    $num_to_transmit = $data->param1;
    $from_profile_id = $data->param2;
    $profiles_to_transmit = $data->param3;
    $transmit_to_profile = $data->param4;
    
    $no_profile_name_found = '';
    $record_exist_in_collection = '';
    $response = array();
    $response["no_records_found"] = array();
    $response["record_already_exist"] = array();
    $response["sql"] = array();
    $result = '';
    $num_profile_name_not_exist = 0;
    $num_profiles_transmitted = 0;
    
    require_once __DIR__ . '/db_connect.php';
    $db = new DB_CONNECT();
    $con = $db->connect();
    
    $profiles_to_transmit_array = array();
    $to_transmit_str = $profiles_to_transmit;
    
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
    
    $sql = "SELECT identity_profile_id FROM identity_profile WHERE delete_ind = 0 AND profile_name = '" .$transmit_to_profile."'";
    array_push($response["sql"], "*****select for exist_sql=" .$sql);
        
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["db_error"] = "insert_transmitted_profile_data: Problem transmitting WAMI to profile(1): " .$transmit_to_profile. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        echo json_encode($response);
        exit(-1);
    }
        
    //Check if profile name exists
    $row_count = $result->num_rows;
    if ($row_count < 1) {
        $num_profile_name_not_exist++;
        $no_profile_name_found = "Profile Name does not exist: " .$transmit_to_profile. ". Either send to email address or choose another name.";
        array_push($response["no_records_found"], $no_profile_name_found);
        $response["ret_code"] = 1;
        echo json_encode($response);
        exit(-1);
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
            $response["db_error"] = "insert_transmitted_profile_data: Problem transmitting WAMI to profile(2): " .$transmit_to_profile. " MySQL Error: " .mysqli_error($con);
            $response["ret_code"] = -1;
            echo json_encode($response);
            exit(-1);
        }
        $row_count = $result->num_rows;
        if ($row_count > 0) {
            $row = mysqli_fetch_row($result);
            $profile_name = $row[1];
            $record_exist_in_collection = "Profile: " .$profile_name. " already exists in the collection for " .$transmit_to_profile;
            array_push($response["record_already_exist"], $record_exist_in_collection);
            continue;
        }
        $sql = "INSERT INTO identity_profile_collection (assign_to_identity_profile_id, identity_profile_id, from_identity_profile_id,
        transmission_receive_date, transmission_accept_date, transmission_status, delete_ind, create_date, modified_date)
        VALUES(" .$assign_to_profile_id. "," .$profiles_to_transmit_array[$j]. "," .$from_profile_id. ",  NOW(), NULL , 'NA', 0, NOW(), NOW())";
        array_push($response["sql"], "*****Insert_sql=" .$sql);
        
        $result = mysqli_query($con, $sql) or die(mysqli_error($con));
        if (!$result) {
            $response["db_error"] = "insert_transmitted_profile_data: Problem transmitting WAMI to profile(3): " .$transmit_to_profile. " MySQL Error: " .mysqli_error($con);
            $response["ret_code"] = -1;
            echo json_encode($response);
            exit(-1);
        }
        $num_profiles_transmitted++;
    }
    $response["num_profiles_transmitted"] = $num_profiles_transmitted;
    $response["num_profile_name_not_exist"] = $num_profile_name_not_exist;
    $response["ret_code"] = 0;
    echo json_encode($response);
    
    ?>

