<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=lightgreen>
        
        <?php
            $l_idc = $_REQUEST['idc'];
            echo "(debug : idc : ".$l_idc.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');
            $texte = "select distinct village.idv, ville, activite, prix, capacite
            from village, sejour
            where sejour.idc = ".$l_idc.
                " and village.idv = sejour.idv";
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ociexecute($ordre);
            while(ocifetchinto($ordre, $ligne))
                echo "idv : ".$ligne[0].", ville : ".$ligne[1].", activité : ".$ligne[2].", prix : ".$ligne[3]."<br>";
            
            ocilogoff($c);
        ?>
    




    </body>
</html>
