<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=orange>
        
        <?php
            $j = $_REQUEST['jour'];
            echo "(debug : ".$j.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');

            $texte = "begin traitement3_out(".$j.", :1); end;"; 
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ocibindbyname($ordre, ':1', $nb);
            ociexecute($ordre);
            echo "nombre de sejour détruit : ".$nb."<br/>";
            
            ocilogoff($c);
        ?>
    




    </body>
</html>
