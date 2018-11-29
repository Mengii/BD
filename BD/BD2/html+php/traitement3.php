<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=green>
        
        <?php
            $j = $_REQUEST['jour'];
            echo "(debug : ".$j.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');
            $texte = "delete sejour where jour < ".$j;
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ociexecute($ordre);
            //après l'exécution
            $nb = oci_num_rows($ordre); 
            echo "nombre de ligne executé : ".$nb;
            
            ocilogoff($c);
        ?>
    




    </body>
</html>
