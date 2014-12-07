<?php
/**
 *
 * transmit_request_to_email_address.php
 *
 * Created by Rob Lanter
 * Date: 6/11/14
 * Time: 8:44 PM
 */
header('Access-Control-Allow-Origin: http://localhost');
$message = $_POST["message"];
$to = $_POST["transmit_to"];
$from_email = $_POST["from_email"];
$subject = 'Request For WAMI Profile';

$headers = "From: " .$from_email. "\n";
$headers .= "Reply-To: " .$from_email. "\n";
$headers .= "MIME-Version: 1.0\n";
$headers .= "Content-Type: text/html; charset=ISO-8859-1\n";

$retVal = mail($to, $subject, $message, $headers);
$response["ret_code"] = $retVal;
echo json_encode($response);

echo "Message has been sent....!";
?>