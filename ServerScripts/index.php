<html>
<head>
<style>
table
{
	border-collapse:collapse;
}
table, td, th
{
	border:1px solid black;
}
td,th
{
	font-size:12px;
}

</style>
</head>
<body>
<?php
include('pgconfig.php');
$con = mysqli_connect($dbhost,$dbusername,$dbpassword,$dbname);
// Check connection
if (mysqli_connect_errno())
  {
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
  }

$result = mysqli_query($con,"SELECT * FROM Posts ORDER BY Time DESC");

echo "<table>
<tr>
<th>Name</th>
<th>Post</th>
<th>Time</th>
</tr>";

while($row = mysqli_fetch_array($result))
  {
  echo "<tr>";
  echo "<td>" . $row['Name'] . "</td>";
  echo "<td>" . $row['PostContent'] . "</td>";
  echo "<td>" . $row['Time'] . "</td>";
  echo "</tr>";
  }
echo "</table>";

mysqli_close($con);
?></p>
</body>
</html>
