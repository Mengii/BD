<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=orange>
        
        <?php
            $le_nom = $_REQUEST['nom'];
            $l_age = $_REQUEST['age'];
            $l_idc = // utilise un select pour récupérer la valeur de séquence (voir corrigé tp1b-4b => dual)
            echo "(debug : nom : ".$le_nom.", age : ".$l_age.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');
            $texte = "insert into client(idc, nom, age)
                values (l_idc, ".$le_nom.", ".$l_age.")";
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ociexecute($ordre);
            
            ocilogoff($c);
        ?>
        
    </body>
</html>
