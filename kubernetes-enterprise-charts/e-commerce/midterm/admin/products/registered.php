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
} else{

$Q = $_POST['PROMODEL'];
$W = $_POST['PRONAME'];
$E= $_POST['PRODESC'];
$R= $_POST['CATEGORY'];
$T= $_POST['PROQTY'];
$Y= $_POST['PROPRICE'];
$U= 'PROSTATS';

$sql = "INSERT INTO tblproduct (PROMODEL,PRONAME, PRODESC,PROQTY,PROPRICE,PROSTATS) 
                    VALUES ( '{$Q}', '{$W}', '{$E}',  '{$T}', '{$Y}', '{$U}')";

if ($conn->query($sql) === TRUE) {
     echo "<script type=\"text/javascript\">
                alert(\"New member added successfully.\");
                window.location = \"student.php\"
            </script>";
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

}
$conn->close();
?>