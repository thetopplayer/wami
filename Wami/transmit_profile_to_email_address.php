<?php
/**
 *
 * transmit_profile_to_email_address.php
 *
 * Created by Rob Lanter
 * Date: 6/11/14
 * Time: 8:44 PM
 */

$message = $_POST["message"];
$to = $_POST["transmit_to"];
$from = $_POST["from_email"];
$subject = 'Transmitted Wami Profile';

$headers = "From: " .$from. "\r\n";
//$headers .= "Reply-To: rob@roblanter.com\r\n";
//$headers .= "Return-Path: rob@roblanter.com\r\n";
$headers .= "MIME-Version: 1.0 \r\n";
$headers .= "Content-Type: text/html; charset=ISO-8859-1 \r\n";

$retVal = mail($to, $subject, $message, $headers);
$response["ret_code"] = $retVal;
echo json_encode($response);

echo "Message has been sent....!";
?>