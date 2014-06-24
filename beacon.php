<!DOCTYPE html>
<html>
<body>


Population: <?php echo $_POST["population"]; ?><br>
Genome: <?php echo $_POST["genome"]; ?><br>
Chromosome: <?php echo $_POST["chr"]; ?><br>
Coordinate: <?php echo $_POST["coord"]; ?><br>
Allele: <?php echo $_POST["allele"]; ?><br>


<?php
$pop=$ref=$chr=$coord=$allele="";

$pop=$_POST["population"];
$ref=$_POST["genome"];
$chr=$_POST["chr"];
$coord=$_POST["coord"];
$allele=$_POST["allele"];

$output=shell_exec("./beacon.sh $ref $chr $coord $allele 2>&1");
echo "<pre>$output<pre>";
?>

</body>
</html> 
