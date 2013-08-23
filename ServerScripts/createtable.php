<?php
	include('pgconfig.php');

	$con = mysqli_connect($dbhost,$dbusername,$dbpassword,$dbname);
	
	if (mysqli_connect_errno())
  	{
 		echo "Failed to connect to MySQL: " . mysqli_connect_error();
  	}
	
	$sql = "CREATE TABLE Posts
	(
	 PID INT NOT NULL AUTO_INCREMENT,
	 PRIMARY KEY(PID),
	 PostContent CHAR(140),
	 Name CHAR(15),
	 Time TIMESTAMP
	 )";
	
	if (mysqli_query($con,$sql))
	{
		echo "Table created successfully";
	}
	else
	{
		echo "Error creating table: " . mysqli_error($con);
	}
	
	mysqli_close($con);
?>