<?php
/**
 *
 * transmit_profile_to_email_address.php
 *
 * Created by Rob Lanter
 * Date: 6/11/14
 * Time: 8:44 PM
 */

//change this to your email.
$to = "rob@roblanter.com";
$from = "rob@roblanter.com";
$subject = "Hello! This is HTML email";

//begin of HTML message
$message ="
<html>
  <body>
    <p style=\"text-align:center;height:100px;background-color:#abc;border:1px solid #456;border-radius:3px;padding:10px;\">
        <b>I am receiving HTML email</b>
    </p>
    <br/><br/>Now you Can send HTML Email
  </body>
</html>";
//end of message

$headers  = 'MIME-Version: 1.0' . "\r\n";
$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
$headers .= "From: \r\n"."X-Mailer: php";

//options to send to cc+bcc
//$headers .= "Cc: [email]maa@p-i-s.cXom[/email]";
//$headers .= "Bcc: [email]email@maaking.cXom[/email]";

// now lets send the email.
$retVal = mail($to, $subject, $message, $headers);
$response["ret_code"] = $retVal;
echo json_encode($response);


echo "Message has been sent....!";
?>