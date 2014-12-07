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

$headers = "From: " .$from. "\n";
$headers .= "Reply-To: " .$from. "\n";
$headers .= "MIME-Version: 1.0\n";
$headers .= "Content-Type: text/html; charset=ISO-8859-1\n";
header('Access-Control-Allow-Origin: http://localhost');

$retVal = mail($to, $subject, $message, $headers);
$response["ret_code"] = $retVal;
echo json_encode($response);

echo "Message has been sent....!";
?>