<?php
	include('pgconfig.php');

	$con = mysqli_connect($dbhost,$dbusername,$dbpassword,$dbname);
	
	if (mysqli_connect_errno())
  	{
 		echo "Failed to connect to MySQL: " . mysqli_connect_error();
  	}
	$json = file_get_contents("php://input");
	$arr = json_decode($json, true);

	$string = $con->real_escape_string($arr["string"]);
	$name = $con->real_escape_string($arr["name"]);

	if (strlen($string) > 0)
	{
		$sql="INSERT INTO Posts (PostContent, Name)
		VALUES
		('$string','$name')";

		if (!mysqli_query($con,$sql))
		  {
		  die('Error: ' . mysqli_error($con));
		  }
		
		mysqli_close($con);

		echo "Submitted Post";
	} 
	else 
	{
		echo "Nothing submitted";
	}
?>