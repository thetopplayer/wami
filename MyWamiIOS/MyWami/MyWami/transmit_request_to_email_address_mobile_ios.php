<?php
    /**
     *
     * transmit_request_to_email_address_mobile_ios.php
     *
     * Created by Rob Lanter
     * Date: 6/11/14
     * Time: 8:44 PM
     */
    
    $json = file_get_contents('php://input');
    $data = json_decode($json);
    
    $to = $data->param1;
    $from_email = $data->param2;
    $requester_profile_name = $data->param3;
    
    $subject = 'Request For WAMI Profile';
    
    $message =
    "<html><body style='background-color: rgba(204, 255, 254, 0.13)'>" .
        "<link href='http://www.mywami.com/css/bootstrap.css' rel='stylesheet'>" .
        "<link href='http://www.mywami.com/css/wami.css' rel='stylesheet'>" .
        "<script src='http://www.mywami.com/js/jquery-1.11.0.min.js'></script>" .
        
        "<div class='panel' style='background-color: #606060; height: 45px'>" .
            "<img  style='margin-left: 30px; vertical-align: middle' src='http://www.mywami.com/assets/wami-navbar.jpg'>" .
        "</div>" .
        
        "<div style='margin-left: 10px; margin-right: 10px'>" .
            "<h4> Wami user: <span style='color: #f87c08'>" .$requester_profile_name. "</span> wants to subscribe to your WAMI profile. Log into Wami " .
                "<a href='http://www.mywami.com'> http://www.mywami.com </a> to publish your Profile if you want." .
            "</h4><br>" .
            "<hr>" .
            "<div>" .
                "<h5> You can create a WAMI account by going to " .
                    "<a href='http://www.mywami.com'> http://www.mywami.com </a>" .
                    "then download the WAMI app from <br><br>" .
                    "<img src='http://www.mywami.com/assets/android_app_logo.png' height='25px' width='80px'> " .
                    " <img src='http://www.mywami.com/assets/apple_app_logo.png' height='25px' width='80px'>" .
                "</h5>" .
            "</div>" .
            "<hr>" .
            "<br><br>" .
            "<h6 style='margin-left: 4px; color: #808080'>WAMI Logos, Site Design, and Content © 2014 WAMI Inc. All rights reserved. Several aspects of the WAMI site are patent pending.</h6> " .
            "<p> <img src='http://www.mywami.com/assets/wami-logo-footer.jpg' class='left' ></p>" .
            "<br><br><br>" .
        "</div>" .
    "</body></html>";
    
    $headers = "From: " .$from_email. "\n";
    $headers .= "Reply-To: " .$from_email. "\n";
    $headers .= "MIME-Version: 1.0\n";
    $headers .= "Content-Type: text/html; charset=ISO-8859-1\n";
    header('Access-Control-Allow-Origin: http://localhost');
    
    $retCode = mail($to, $subject, $message, $headers);
    $response["ret_code"] = $retCode;
    if ($retCode) {
        $response["message"] = "Request has been sent.";
    }
    else {
        $response["message"] =  "Problem with emailing request(s).";
    }
    echo json_encode($response);
?>