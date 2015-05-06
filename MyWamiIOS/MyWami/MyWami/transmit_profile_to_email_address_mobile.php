<?php
/**
 *
 * transmit_profile_to_email_address_mobile.php
 *
 * Created by Rob Lanter
 * Date: 6/11/14
 * Time: 8:44 PM
 */
    
    
    $json = file_get_contents('php://input');
    $data = json_decode($json);
    
    $to = $data->param1;
    $from = $data->param2;
    $profile_name = $data->param3;
    $from_first_name = $data->param4;
    $from_last_name = $data->param5;
    $from_profile_name = $data->param6;
    $contact_name = $data->param7;
    $email = $data->param8;
    $profile_type = $data->param9;
    $description = $data->param10;
    $street_address = $data->param11;
    $city = $data->param12;
    $state = $data->param13;
    $zipcode = $data->param14;
    $country = $data->param15;
    $telephone = $data->param16;
    $tags = $data->param17;
    $create_date = $data->param18;
    
    $subject = 'Transmitted Wami Profile';

    $message =
    "<html><body style='background-color: rgba(204, 255, 254, 0.13)'>" .
    "<link href='http://www.mywami.com/css/bootstrap.css' rel='stylesheet'>" .
    "<link href='http://www.mywami.com/css/wami.css' rel='stylesheet'>" .
    "<script src='http://www.mywami.com/js/jquery-1.11.0.min.js'></script>" .

    "<div class='panel' style='background-color: #606060; height: 45px'>" .
        "<img  style='margin-left: 30px; vertical-align: middle' src='http://www.mywami.com/assets/wami-navbar.jpg'>" .
    "</div>" .

    "<div style='margin-left: 10px; margin-right: 10px'>" .
        "<h4> Wami Profile For: <span style='color: #f87c08'>"  .$profile_name. "</span></h4>" .
        "<h4> From: <span style='color: #f87c08'>"  .$from_first_name. " "  .$from_last_name.  "</span>   Wami Profile: <span style='color: #f87c08'>" .$from_profile_name. "</span> </h4>" .
        "<hr>" .
        "<div style='margin-left: 20px; line-height: 10px'>" .
            "<h5> Contact Name: <span style='color: #f87c08'>" .$contact_name. "</span></h5>" .
            "<h5> Email Address: <span style='color: #f87c08'>" .$email. "</span></h5>" .
            "<h5> Profile Type: <span style='color: #f87c08'>" .$profile_type. "</span></h5>" .
            "<h5> Description: <span style='color: #f87c08'>" .$description. "</span></h5>" .
            "<h5> Street Address: <span style='color: #f87c08'>" .$street_address. "</span></h5>" .
            "<h5> City: <span style='color: #f87c08'>" .$city. "</span></h5>" .
            "<h5> State: <span style='color: #f87c08'>" .$state. "</span></h5>" .
            "<h5> Zip/Postal Code: <span style='color: #f87c08'>" .$zipcode. "</span></h5>" .
            "<h5> Country: <span style='color: #f87c08'>" .$country. "</span></h5>" .
            "<h5> Telephone: <span style='color: #f87c08'>" .$telephone. "</span></h5>" .
            "<h5> Profile Key Words: <span style='color: #f87c08'>" .$tags. "</span></h5>" .
            "<h5> Profile Create Date: <span style='color: #f87c08'>" .$create_date. "</span></h5>" .
        "</div>" .
        "<hr>" .
        "<div>" .
            "<h5> You can create a WAMI account by going to " .
                "<a href='http://www.mywami.com'> http://www.mywami.com </a>" .
                "then download the WAMI app from <br><br>" .
                "<img src='http://www.mywami.com/assets/android_app_logo.png'> " .
                "<img src='http://www.mywami.com/assets/apple_app_logo.png'>" .
            "</h5>" .
        "</div>" .
        "<hr>" .
        "<br><br>" .
        "<h6 style='margin-left: 4px; color: #808080'>WAMI Logos, Site Design, and Content © 2014 WAMI Inc. All rights reserved. Several aspects of the WAMI site are patent pending.</h6> " .
        "<p> <img src='http://www.mywami.com/assets/wami-logo-footer.jpg' class='left' ></p>" .
        "<br><br><br>" .
    "</div>" .
    "</body></html>";


    $headers = "From: " .$from. "\n";
    $headers .= "Reply-To: " .$from. "\n";
    $headers .= "MIME-Version: 1.0\n";
    $headers .= "Content-Type: text/html; charset=ISO-8859-1\n";
    header('Access-Control-Allow-Origin: http://localhost');

    $retCode = mail($to, $subject, $message, $headers);
    $response["ret_code"] = $retCode;
    if ($retCode) {
        $response["message"] = "Profile has been emailed.";
    }
    else {
        $response["message"] =  "Problem with emailing profile.";
    }
    echo json_encode($response);
?>



