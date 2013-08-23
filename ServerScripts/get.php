
<?php
include('pgconfig.php');

$con = mysqli_connect($dbhost,$dbusername,$dbpassword,$dbname);

if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

$result = mysqli_query($con,"SELECT * FROM Posts ORDER BY Time DESC");

while($row = mysqli_fetch_array($result))
  {
  $results_array[] = array (
  	'name' => $row['Name'],
  	'content' => $row['PostContent'],
  	'timestamp' => $row['Time']
  	);
  }

$json = json_encode($results_array);

echo $json;

mysqli_close($con);
?>