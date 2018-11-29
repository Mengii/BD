<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=pink>
        <?php
            $a = $_REQUEST['x'];
            $b = $_REQUEST['y'];
            echo "(debug x = ".$a.")<br>";
            echo "(debug y = ".$b.")<br>";
            echo "<table border>";
            for($i=$a+1; $i<$b; $i++){
                echo "<tr>";
                echo "<td>";
                echo $i;
                echo "</td>";
                echo "</tr>";
            }
            echo "</table>";  
        ?>

        <! https://tp-ssh1.dep-informatique.u-psud.fr/~mduan/ex2.php?x=6&y=12>
    </body>
</html>
