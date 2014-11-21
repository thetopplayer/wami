<?php
/**
 * update_pdf_file.php
 *
 * User: robertlanter
 * Date: 5/28/14
 * Time: 2:36 PM
 *
 * Inserts PDF file
 */
$response = array();
require_once __DIR__ . '/db_connect.php';

$identity_profile_id = $_POST["identity_profile_id"];
$profile_name = $_POST["profile_name"];
$file_name = $_POST["file_name"];
$pdf_file_description = $_POST["pdf_file_description"];
$pdf_file_name = $_POST["pdf_file_name"];
$category = $_POST["category"];
if ($pdf_file_name === '') {
    $pdf_file_name = $file_name;
}

$pdf_file_src = $_POST["pdf_file_src"];

$delete_ind = 0;
$file_location = 'assets/pdf_files/' .$profile_name. '/';

$pdf = strstr($pdf_file_src, ',');
$pdf = substr($pdf, 1);
$pdf = str_replace(' ', '+', $pdf);
$data = base64_decode($pdf);

$location = $file_location .$file_name;
$byte_cnt = file_put_contents($location, $data);
if ($byte_cnt < 1) {
    $response["ret_code"] = -9;
    $response["message"] = "update_pdf_file: Problem writing PDF file to file system";
    echo json_encode($response);
    exit(-1);
}

$db = new DB_CONNECT();
$con = $db->connect();
$con->autocommit(FALSE);

try {
    $sql = "UPDATE profiler_pdf_files SET file_name = '" .$file_name. "', pdf_file_name = '" .$pdf_file_name. "', pdf_file_description = '" .$pdf_file_description. "', modified_date = now()
            WHERE identity_profile_id = " .$identity_profile_id. " AND category = '" .$category. "'";
    $result = mysqli_query($con, $sql) or die(mysqli_error($con));
    if (!$result) {
        $response["message"] = "update_pdf_file: Problem inserting PDF file: " .$file_name. " MySQL Error: " .mysqli_error($con);
        $response["ret_code"] = -1;
        $con->rollback();
        $con->autocommit(TRUE);
        unlink($file_location .$file_name);
        echo json_encode($response);
        exit(-1);
    }
} catch (Exception $e) {
    $response["ret_code"] = -1;
    $response["message"] = "update_pdf_file.php: Transaction failed: " . $e->getMessage();
    $con->rollback();
    $con->autocommit(TRUE);
    unlink($file_location .$file_name);
    echo json_encode($response);
    return;
}

$con->commit();
$con->autocommit(TRUE);
$response["ret_code"] = 0;
$response["message"] = "PDF file uploaded successfully. ";
echo json_encode($response);

?>
