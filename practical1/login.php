<?php
session_start();
// Establish a database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "atlab1";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
// Retrieve user input
$username_email = $_POST['username_email'];
$password = $_POST['password'];

// Check if the user exists
$sql = "SELECT * FROM users WHERE username='$username_email' OR
email='$username_email'";
$result = $conn->query($sql);
if ($result->num_rows == 1) {
    $row = $result->fetch_assoc();
    // Verify the password
    if ($password == $row['password']) {
        $_SESSION['username'] = $row['username'];
        echo "Login successful!";
        // Redirect to a protected page or dashboard
    } else {
        echo "Incorrect password!";
    }
} else {
    echo "User not found!";
}
$conn->close();
?>