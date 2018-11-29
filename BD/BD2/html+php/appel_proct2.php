<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=orange>
        
        <?php
            $id = $_REQUEST['idc'];
            $v = $_REQUEST['ville'];
            $j = $_REQUEST['jour'];
            echo "(debug : idc : ".$id.", ville : ".$v.", jour : ".$j.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');

            $texte = "begin traitement2(".$id.", '".$v."', ".$j.", :1, :2, :3); end;"; 
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ocibindbyname($ordre, ':1', $idv);
            ocibindbyname($ordre, ':2', $ids);
            ocibindbyname($ordre, ':3', $act, 100); //obligé de réserver mémoire pour type varchar

            ociexecute($ordre);
            echo "idv : ".$idv.", ids : ".$ids.", activité : ".$act."<br/>";
            
            ocilogoff($c);
        ?>
    




    </body>
</html>
