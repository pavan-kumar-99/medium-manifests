<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "ecommercedb";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

// sql to delete a record
$sql = 'DELETE FROM tblcategory WHERE ID= ' . $_GET['CATEGID'];

if ($conn->query($sql) === TRUE) {
   //dislay a message box that the saving is successfully save
    echo "<script type=\"text/javascript\">
                alert(\"New member delete successfully.\");
                window.location = \"index.php\"
            </script>";
} else {
    echo "Error deleting record: " . $conn->error;
}

$conn->close();
?>