<html>
<head>
    <h2>LEMP Stack Test</h2>
</head>
    <body>
    <?php echo '<p>Your Installation is Successful </p>';

    // Define PHP variables for the MySQL connection.
    $servername = "db";
    $username = "root";
    $password = "mysupersecret";

	$ip = $_SERVER['REMOTE_ADDR'];
	echo "<h2>Client IP Information</h2>";
	echo "Your IP address : " . $ip;
	echo "<br>Your hostname : ". gethostbyaddr($ip) ;

    // Create a MySQL connection.
    $conn = mysqli_connect($servername, $username, $password);

    // Report if the connection fails or is successful.
    if (!$conn) {
        exit('<p>Your DB connection has failed.<p>' .  mysqli_connect_error());
    }
    echo '<h3>You have connected to Database successfully.</h3>';
    ?>
</body>
</html>