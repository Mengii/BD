<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=lightgreen>
        
        <?php
            $l_idc = $_REQUEST['idc'];
            $le_nom = $_REQUEST['nom'];
            echo "(debug : idc : ".$l_idc.", nom : ".$le_nom.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');
            $texte = "select * from client where idc = ".$l_idc." and nom = "."'$le_nom'"; //attention nom de type varchar
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ociexecute($ordre);
            if(ocifetchinto($ordre, $ligne))
                echo "Bienvenue ".$ligne[1]."<br>";
            else 
                echo "identifiant existe pas";
            ocilogoff($c);
        ?>
    




    </body>
</html>
