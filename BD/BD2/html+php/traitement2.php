<html>
    <head>
        <meta charset="UTF-8">
    </head> 

    <body bgcolor=green>
        
        <?php
            $id = $_REQUEST['idc'];
            $v = $_REQUEST['ville'];
            $j = $_REQUEST['jour'];
            echo "(debug : idc : ".$id.", ville : ".$v.", jour : ".$j.")<br>";
    
            $c = ocilogon('c##mduan_a', 'mduan_a', 'dbinfo');
            $texte = "select idv, prix, activite
                from village
                where ville = '".$v."' order by prix desc";
            echo "(debug : ".$texte.")<br>";
            
            $ordre = ociparse($c, $texte);
            ociexecute($ordre);

            if(ocifetchinto($ordre,$ligne)){ 
                echo "idv : ".$ligne[0].", prix : ".$ligne[1].", activité : ".$ligne[2]."<br>";
                
                $ids = "select seq_sejour.nextval from dual";
                $ordre3 = ociparse($c, $ids);
                ociexecute($ordre3);
                if(ocifetchinto($ordre3,$ligne_ids)){
                    echo "ids : ".$ligne_ids[0]; //pas de ."<br>" sinn une ligne des titres de table en trop
                } 
 
                $texte1 = "insert into sejour values(".$ligne_ids[0].", ".$id.", ".$ligne[0].", ".$j.")";
                echo "(debug : ".$texte1.")<br>";
                $texte2 = "update client set avoir = avoir - ".$ligne[1]." where idc = ".$id;
                echo "(debug : ".$texte2.")<br>";

                $ordre1 = ociparse($c, $texte1);
                ociexecute($ordre1);
                $ordre2 = ociparse($c, $texte2);
                ociexecute($ordre2);
            }
                
            ocilogoff($c);
        ?>
    




    </body>
</html>
