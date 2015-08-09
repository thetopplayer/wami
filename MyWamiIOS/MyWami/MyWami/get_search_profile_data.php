<?php
    /**
     * get_search_profile_data.php
     *
     * Created by Robert Lanter
     * User: robertlanter
     * Date: 2/3/14
     * Time: 2:48 PM
     *
     * get list of profiles from search criteria
     */
    $jsonInput = file_get_contents('php://input');
    $data = json_decode($jsonInput);
    $selected_item = $data->param1;
    $search_str = $data->param2;
    $search_index = $data->param3;
    $identity_profile_id = $data->param4;

    require_once __DIR__ . '/db_connect.php';
    $db = new DB_CONNECT();
    $con = $db->connect();
    $response = array();
    $condition = '';
    
    if ($selected_item === "Profile Name") {
        $condition = "profile_name LIKE '%" .$search_str. "%'";
    }
    if ($selected_item === "First Name") {
        $condition = "first_name LIKE '%" .$search_str. "%'";
    }
    if ($selected_item === "Last Name") {
        $condition = "last_name LIKE '%" .$search_str. "%'";
    }
    if ($selected_item === "Tags") {
        $condition = "tags LIKE '%" .$search_str. "%'";
    }
    if ($selected_item === "Description") {
        $condition = "description LIKE '%" .$search_str. "%'";
    }
    
    // get profile data
    if ($search_index === "1") {
        $sql = "SELECT first_name, last_name, profile_name, image_url, email, tags, description, identity_profile_id
        FROM identity_profile WHERE " .$condition. " AND delete_ind = 0 AND searchable = 1 AND active_ind = 1 ";
    }
    else {
        $sql = "SELECT first_name, last_name, profile_name, image_url, email, tags, description, ipc.identity_profile_id
        FROM identity_profile_collection ipc, identity_profile ip WHERE " .$condition. " AND assign_to_identity_profile_id = " .$identity_profile_id. "
        AND ipc.identity_profile_id = ip.identity_profile_id AND ipc.delete_ind = 0 AND searchable = 1 AND active_ind = 1 ";
    }
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    $response["profile_list"] = array();
    if (mysqli_num_rows($result) > 0) {
        while ($row = mysqli_fetch_array($result)) {
            $item = array();
            $item["first_name"] = $row[0];
            $item["last_name"] = $row[1];
            $item["profile_name"] = $row[2];
            $item["image_url"] = $row[3];
            $item["email"] = $row[4];
            $item["tags"] = $row[5];
            $item["description"] = $row[6];
            $item["identity_profile_id"] = $row[7];
            array_push($response["profile_list"], $item);
        }
        $response["ret_code"] = 0;
        echo json_encode($response);
    }
    else {
        $response["ret_code"] = 1;
        $response["message"] = "No Profile data found for search string: " .$search_str;
        echo json_encode($response);
        exit(-1);
    }
    
    ?>