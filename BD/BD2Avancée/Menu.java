//-----------------------------------------------------------------------------
// Menu.java
//-----------------------------------------------------------------------------

import java.io.*; // pour la fonction lireClavier uniquement
import java.sql.*;
import oracle.jdbc.OracleTypes; //type Oracle ref cursor => tp6b

class Menu {
        
    //version initiale
    /*
    static void creerVillage(Connection c) throws SQLException, ClassNotFoundException {
	    System.out.println("ici action1");

        String texte = "insert into village values(2,'Paris','TourEiffel',120,10)";
        System.out.println(texte);
        Statement s = c.createStatement();   
        s.executeUpdate(texte);
        
        s.close(); 
    }
    */


    // tp 4b
    static void creerVillage(Connection c) throws SQLException {
        System.out.println("ici action1");

        String v = lireClavier ("ville : ");
        String a = lireClavier ("activité : ");
        int p = Integer.parseInt(lireClavier("prix : "));
        int cap = Integer.parseInt(lireClavier("capacité : "));

        CallableStatement cs = c.prepareCall("{call creerVillage('"+v+"', '"+a+"', "+p+", "+cap+")}");
        cs.execute();

        System.out.println("ok");
        
        cs.close();
    }

    //tp 5b
    static void creerVillage_boucle(Connection c) throws SQLException{
        System.out.println("ici action1");
        
        String texte = "insert into village values (seq_village.nextval, ?, ?, ?, ?)";
        System.out.println(texte);
        PreparedStatement p = c.prepareStatement(texte);
        while(Integer.parseInt(lireClavier("on continue (1/0)? "))==1){
            p.setString(1,lireClavier("ville? "));
            p.setString(2,lireClavier("activité? "));
            p.setInt(3,Integer.parseInt(lireClavier("prix? ")));
            p.setInt(4,Integer.parseInt(lireClavier("capacité? ")));
            p.executeUpdate();
        }
        p.close();
    }
    
    //pas de proc creerVillage
    /*
    static void creerVillage_callProc(Connection c) throws SQLException{
        System.out.println("ici action1");

        String texte = "";
    }*/
    
///////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /*    
    static void traitement3(Connection c) throws SQLException {
	    System.out.println("ici traitement3");  
        
        String jour = lireClavier ("Entrez le jour : ");
        String texte = "delete sejour where jour < " + jour;
        System.out.println(texte);
        Statement s = c.createStatement();   
        
        int n;
        n = s.executeUpdate(texte);
        System.out.println("nombre de lignes traitées : " + n);        
        
        s.close();  
    }
    */
    
    //td3b
    /*
    static void traitement3(Connection c){
        try {
            System.out.println("ici traitement3");  
        
            String jour = lireClavier ("Entrez le jour : ");
            String texte = "delete sejour where jour < " + jour;
            System.out.println(texte);
            Statement s = c.createStatement();   
        
            int n;
            n = s.executeUpdate(texte);
            System.out.println("nombre de lignes traitées : " + n);        
        
            s.close(); 
        }
	    catch (SQLException e){
			System.out.println(e);
		}
    }
    */
    
    //td4b ===> appel de fonction stochée
    static void traitement3(Connection c) throws SQLException {
        int j = Integer.parseInt(lireClavier("Entrez le jour : "));
        CallableStatement cs = c.prepareCall("{? = call traitement3("+j+")}");
        cs.registerOutParameter(1, Types.INTEGER);
        cs.execute();
        
        int nb = cs.getInt(1);
        System.out.println("nombre : " + nb);
        
        cs.close();
    }

    //tp5b
    static void traitement3_call_boucle(Connection c) throws SQLException {
        System.out.println("ici traitement3");

        String texte = "{? = call traitement3(?)}";
        CallableStatement cs = c.prepareCall(texte);
        while(Integer.parseInt(lireClavier("on continue (1/0)? "))==1){
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, Integer.parseInt(lireClavier("Entrez le jour : ")));
            cs.execute();
            int nb = cs.getInt(1);
            System.out.println("nombre détruit: " + nb);
        }
        cs.close();
    }

    static void traitement3_out(Connection c) throws SQLException {
        int j = Integer.parseInt(lireClavier("Entrez le jour : "));
        CallableStatement cs = c.prepareCall("{call traitement3_out("+j+",?)}");
        cs.registerOutParameter(1, Types.INTEGER);
        cs.execute();
        
        int nb = cs.getInt(1);
        System.out.println("nombre : " + nb);
        
        cs.close();
    }
    
    //tp5b
    static void traitement3_call_boucle_out(Connection c) throws SQLException {
        System.out.println("ici traitement3");

        String texte = "{call traitement3_out(?,?)}";
        CallableStatement cs = c.prepareCall(texte);
        while(Integer.parseInt(lireClavier("on continue (1/0)? "))==1){
            cs.setInt(1, Integer.parseInt(lireClavier("Entrez le jour : ")));            
            cs.registerOutParameter(2, Types.INTEGER);
            cs.execute();
            
            int nb = cs.getInt(2);
            System.out.println("nombre détruit: " + nb);
        }
        
        cs.close();
    }

///////////////////////////////////////////////////////////////////////////////////////////////////::

    static String lireClavier(String message) {
	    // Dans cette fonction l'exception est catchee pour ne pas avoir a la 
        // gerer dans le main, et donc mieux voir les exceptions BD. 
	    try {
            System.out.print(message);
	        BufferedReader clavier =
		    new BufferedReader(new InputStreamReader(System.in));
	        return clavier.readLine();
	    } catch (Exception e) {
	        return "erreur dans fonction lireClavier";
	    }
    }
 
////////////////////////////////////////////////////////////////////////////////////////////////////////////   

    static Connection connection (String user, String mdp) throws SQLException {
          Connection c = DriverManager.getConnection(
            "jdbc:oracle:thin:c##"+user+"/"+mdp+"@tp-oracle:1522:dbinfo");  
          return c;
    }

    static void deconnection (Connection c) throws SQLException, ClassNotFoundException {
           c.close();
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////

    static void creerVillage2(Connection c) throws SQLException {
	    System.out.println("ici action 1");

        String texte = "insert into village values(3,'Lille','GrandPlace',80,150)";
        System.out.println(texte);
        Statement s = c.createStatement();   
        s.executeUpdate(texte);
        
        s.close(); 

        //connection avec compte de l'enseignant
        lireClavier("Pause programme (entrez return) :");
        Connection c2 = connection ("ewaller2_a", "ewaller_a");
        s = c2.createStatement();
        texte = "insert into village values(20,'Nice','GrandBleu',180,50)";
        System.out.println(texte);
        s.executeUpdate(texte);

        s.close(); 
        c2.close(); 
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    static void consulterVillage(Connection c) throws SQLException {
		System.out.println("ici action 2");
		
		String l_idc = lireClavier ("Entrez l'identifiant : ");
        String le_nom = lireClavier ("Entrez le nom : ");
        
        Statement s = c.createStatement();
        ResultSet r = 
            s.executeQuery(
                "select village.idv, ville, activite, prix, capacite from village, sejour, client where client.idc = "+l_idc+
                " and client.nom = '"+le_nom+"'" +
                " and client.idc = sejour.idc"+
                " and sejour.idv = village.idv");
        while (r.next()) {
			System.out.println(r.getInt(1) + " , " + r.getString(2) + " , " + r.getString(3) + " , " + r.getInt(4) + " , " + r.getInt(5));
		}
		
		r.close();
        s.close();
	}
    
    //tp6b
    static void consulterVillage_refcursor(Connection c) throws SQLException{
        System.out.println("ici action 2");
        
        int client = Integer.parseInt(lireClavier("Entrez votre identifiant : "));
        
        String texte = "{? = call renvoyer_sejours(?)}";
        CallableStatement cs = c.prepareCall(texte);
        cs.registerOutParameter(1, OracleTypes.CURSOR);
        cs.setInt(2, client);
        cs.execute();
        
        ResultSet r = (ResultSet) cs.getObject(1);
        while(r.next()){
            System.out.println("ids : "+r.getInt(1)+" idv : "+r.getInt(2)+" jour : "+r.getInt(3));
        }

        r.close();
        cs.close();
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

    static void modifierVillage(Connection c) throws SQLException {
        System.out.println("ici action 3");
        
        String id = lireClavier ("Entrez l'identifiant : ");
        String cap = lireClavier ("Entrez la capacité : ");
        String act = lireClavier ("Entrez l'activité : ");
        
        String texte = "update village set activite = '" +act+ "'" + ", capacite = " +cap+ " where idv = " +id;
        System.out.println(texte);

        Statement s = c.createStatement();  
        int n;
        n = s.executeUpdate(texte);
        System.out.println("nombre de lignes traitées : " + n);        
        
        s.close();  
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

    static void authentification(Connection c) throws SQLException {
		System.out.println("ici action 9-1");
		
        String l_idc = lireClavier ("Entrez l'identifiant : ");
        String le_nom = lireClavier ("Entrez le nom : ");
        
        Statement s = c.createStatement();
        ResultSet r = 
            s.executeQuery(
                "select * from client where idc = "+l_idc+"and nom = '"+le_nom+"'");
        if(r.next()){
			System.out.println("age = " + r.getInt(3) + " avoir = " + r.getInt(4));
		} else {
			System.out.println("desolé, erreur identifiant/nom");
		}
            
		r.close();
        s.close();
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //tp9b exo9.1.a.ii
    static void detruire_tab(Connection c) throws SQLException {
        System.out.println("ici action pour détruire une table");
        
        String table = lireClavier ("Entrez le nom de la table : ");
        
        String texte = "drop table "+table;
        System.out.println(texte);

        Statement s = c.createStatement();
        s.executeUpdate(texte);

        s.close();
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //tp9b exo9.1.b
    static void traitement2Login(Connection c) throws SQLException {
        System.out.println("ici action pour login du traitement 2 (achat de séjour)");
        
        //fait attention à c## !!!
        String l = "c##"+lireClavier ("Entrez votre login : "); //mduan_a ou zzhang4_a
        int l_idc = Integer.parseInt(lireClavier("Entrez votre identifiant client : "));
        //acheter les villes avec un prix moins de l'avoir resté
        String la_ville = lireClavier ("Entrez la ville : ");
        int le_jour = Integer.parseInt(lireClavier("Entrez le jour : "));
        
        String texte = "{call "+l+".traitement2("+l_idc+", '"+la_ville+"', "+le_jour+", ?, ?, ?)";
        System.out.println(texte);

        CallableStatement cs = c.prepareCall(texte);
        cs.registerOutParameter(1, Types.INTEGER);
        cs.registerOutParameter(2, Types.INTEGER);
        cs.registerOutParameter(3, Types.VARCHAR);
        cs.execute();
        
        int idv = cs.getInt(1);
        int ids = cs.getInt(2);
        String act = cs.getString(3);
        System.out.println("idv = "+idv+" ids = "+ids+" activite = "+act);

        cs.close();
    }    

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //tp9b exo9.1.c
    static void fonctionLogin(Connection c) throws SQLException {
        System.out.println("ici action pour appel de fonction");
        
        String l = "c##"+lireClavier ("Entrez votre login : ");
        String f = lireClavier ("Entrez la fonction : ");
        String p1 = lireClavier ("Entrez param 1 (string) : ");
        int p2 = Integer.parseInt(lireClavier("Entrez param 1 (int) : "));
        
        String texte = "{ ? = call "+l+"."+f+"('"+p1+"', "+p2+")}";
        System.out.println(texte);

        CallableStatement cs = c.prepareCall(texte);
        cs.registerOutParameter(1, Types.INTEGER);
        cs.execute();

        System.out.println("retour : "+cs.getInt(1));

        cs.close();
    }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        String user = lireClavier ("Entrez l'utilisateur : ");
        String mdp = lireClavier ("Entrez le mot de passe : ");

        Connection c = connection(user,mdp);
	    
        while (true) {
	        System.out.println("-------------------------------");
	        System.out.println("Bienvenue dans le menu Menu");
	        System.out.println("1 : creerVillage");
            System.out.println("11 : creerVillage boucle");
	        System.out.println("2 : consulterVillage");
            System.out.println("21 : consulterVillage refcursor");
	        System.out.println("3 : modifierVillage");
            System.out.println("5 : traitement3");
            System.out.println("51 : traitement3_call_boucle");
            System.out.println("52 : traitement3_out");
            System.out.println("53 : traitement3_call_boucle_out");         
            System.out.println("91 : authentification");
            System.out.println("10 : deconnexion");
            System.out.println("100 : detruire table");
            System.out.println("101 : login pour traitement2 (achat de séjour)");
            System.out.println("102 : login pour tester avec traitement1 (inscription client)");
	        System.out.println("0 : terminer");
   
	        int n = Integer.parseInt(lireClavier("Entrez votre choix : "));
	        switch (n) {
	        case 1 : creerVillage(c); break;
            case 11 : creerVillage_boucle(c); break;
	        case 2 : consulterVillage(c); break;
            case 21 : consulterVillage_refcursor(c); break;
            case 3 : modifierVillage(c); break;
	        case 5 : traitement3(c); break;
            case 51 : traitement3_call_boucle(c); break;
            case 52 : traitement3_out(c); break;
            case 53 : traitement3_call_boucle_out(c); break;
            case 91 : authentification(c); break;
            case 10 : deconnection(c); break;
            case 100 : detruire_tab(c); break;
            case 101 : traitement2Login(c); break;
            case 102 : fonctionLogin(c); break;
	        case 0 : return;
			}
        
			c.close();
	}
    }

}

//-----------------------------------------------------------------------------
