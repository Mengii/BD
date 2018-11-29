<html>

    <body bgcolor=yellow>

        
        <?php
            $user = $_REQUEST['u'];
            $nplace = $_REQUEST['nbplace'];
    	    
	    $texte = "begin ".$user."traitement('".$_REQUEST['nom']."','".$_REQUEST['destination']."','".$_REQUEST['marque']."',".$nplace." :1, :2); end;";
            echo "(debug : ".$texte.")<br>";
            $c = ocilogon('c##quentin', 'baba', 'noel');
            
            $ordre = ociparse($c, $texte);
	    ocibinbyname($ordre, ':1', $id_client);
            ocibinbyname($ordre, ':2', $id);
            ociexecute($ordre);
            
	    echo "<table border>";
	   
	    echo "<tr>";
            echo "<td>";
            echo "identifiant client : ".$id_client;
            echo "</td>";
            echo "</tr>";
	   
    	    if ($nplace === -1){
		echo "<tr>";
	        echo "<td>";
	    	echo "identifiant demande : ".$id;
	    	echo "</td>";
	    	echo "</tr>";
	    } else {
		echo "<tr>";
            	echo "<td>";
            	echo "identifiant offre : ".$id;
            	echo "</td>";
            	echo "</tr>";
	      }
	    
         echo "</table>"
            
            ocilogoff($c);
        ?>
    

    </body>
</html>


<!-- https://tp-ssh1.dep-informatique.u-psud.fr/~quentin/ex2.php?u=quentin&nom=Riton&destination=Berlin&marque=Porsche&nbplace=-1 -->


<html>
   <body bgcolor=yellow>
	<table border>
	<tr><td>identifiant client : 1</td></tr>
	<tr><td>identifiant offre : 20</td></tr>
	</table>
   </body>
</html>
