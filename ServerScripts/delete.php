<?php
	include('pgconfig.php');

	$con = mysqli_connect($dbhost,$dbusername,$dbpassword,$dbname);
	
	if (mysqli_connect_errno())
  	{
 		echo "Failed to connect to MySQL: " . mysqli_connect_error();
  	}

  	$jsonString = file_get_contents('php://input');
  	$jsonArray = json_decode($jsonString, true);
  	$postContent = $jsonArray['content'];
  	$postTime = $jsonArray['timestamp'];

	$sql="DELETE FROM Posts WHERE PostContent = '$postContent' AND Time = '$postTime'";

	if (!mysqli_query($con,$sql))
	  {
	  die('Error: ' . mysqli_error($con));
	  }
	
	mysqli_close($con);

	echo "Deleted Post";
	

?>