<html>

    <body bgcolor=pink>

        
        <?php
	    $c = ocilogon('c##noel', 'betty', 'quentin');
            
	    $texte = "begin traitement(".$_REQUEST['idc'].", :1); end;";
            
            $ordre = ociparse($c, $texte);
	    ocibinbyname($ordre, ':1', $numtel);
            
            ociexecute($ordre);
            
	    echo "<ul>";
	    
	    echo "<li>";
            echo "numero de telephone client : ".$numtel;
            echo "</li>";
            
            echo "</ul>";

	    ///////////////////////////2/////////////////////////////////
	
	    $texte = "select demande.idc, covoiturage.idc, telephone from client, demande, covoiturage where cliente.idc = ".$_REQUEST['idc']." and demande.idc = client.idc and covoiturage.idc = demande.idc";
;
	    $ordre = ociparse($c, $texte);
	    ociexecute($ordre);
	    while(ocifetchinto($ordre, $ligne)){
		$texte = "delete client where idc = ".$_REQUEST['idc'];
		$ordre = ociparse($c, $texte);
	    	ociexecute($ordre);
		$texte = "delete demande where idc = ".$ligne[0];
		$ordre = ociparse($c, $texte);
	    	ociexecute($ordre);
		$texte = "delete covoiturage where idc = ".$ligne[1];
		$ordre = ociparse($c, $texte);
	    	ociexecute($ordre);
	    	
		echo "<ul>";
	    
	    	echo "<li>";
            	echo "numero de telephone client : ".$ligne[2];
            	echo "</li>";
            
            	echo "</ul>";
	    }
		
            ocilogoff($c);
        ?>


  </body>
</html>

//////////////////////////////////////////////////////////////////////////////////////////////////////


<!-- https://tp-ssh1.dep-informatique.u-psud.fr/~noel/ex2.html -->

<html>
    <body>
	<form method="post" action="ex2.php">
	  Entrez l'identifiant : (ici 1 par exemple)
	  <input type="text" name="idc"></input>
	  <br>
          <input type="submit" value="Cliquez ici pour déclencher l'action"></input>
	</form>
    </body>
</html>

//////////////////////////////////////////////////////////////////////////////////////////////////////

<html>
   <body bgcolor=pink>
	<ul><li>numero de telephone client : 0612345678</li></ul>
   </body>
</html>




























