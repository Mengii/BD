<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=pink>
        
        <?php
            $j = $_REQUEST['jour'];
            echo "(debug : ".$j.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');

            $texte = "begin :1 := traitement3(".$j."); end;"; 
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ocibindbyname($ordre, ':1', $nb);
            ociexecute($ordre);
            echo "nombre de sejour détruit : ".$nb."<br/>";
            
            ocilogoff($c);
        ?>
    




    </body>
</html>
