<?php
/**
 * Created by IntelliJ IDEA.
 * User: robertlanter
 * Date: 2/2/14
 * Time: 9:21 PM
 */
class DB_CONNECT {
    private $con;

    function __construct() {
    }

    function __destruct() {
        $this->close();
    }

    function connect() {
        require_once __DIR__ . '/db_config.php';
        $this->con = mysqli_connect(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE) or die(mysql_error());
        return $this->con;
    }

    function close() {
        mysqli_close($this->con);
    }
}
?>


