<?php
	include('pgconfig.php');

	$con = mysqli_connect($dbhost,$dbusername,$dbpassword,$dbname);
	
	if (mysqli_connect_errno())
  	{
 		echo "Failed to connect to MySQL: " . mysqli_connect_error();
  	}
	$str = $HTTP_RAW_POST_DATA;

	$sql="INSERT INTO Posts (PostContent, Name)
	VALUES
	('$str','Anonymous')";

	if (!mysqli_query($con,$sql))
	  {
	  die('Error: ' . mysqli_error($con));
	  }
	
	mysqli_close($con);

	echo "Submitted Post"
?>