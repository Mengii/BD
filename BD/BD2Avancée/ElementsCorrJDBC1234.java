//-----------------------------------------------------------------------------
// ElementsCorrJDBC1234.java
// 20 avril 2017
// Tourne le 17 decembre 2013 sur ancienne version corr_pl.sql de BD2.
// Attention : non verifie le 20 avril 2017, et pas forcement complet.
//-----------------------------------------------------------------------------

import java.io.*;
import java.sql.*;

class CorrJDBC {

    //-------------------------------------------------------------------------
    static Connection connexion(String login, String password, 
				String serveur, String base) 
	throws SQLException, ClassNotFoundException {
	System.out.println("ici connexion "+login);
	Connection c = DriverManager.getConnection(
            "jdbc:oracle:thin:"+login+"/"+password+"@"+serveur+":1521:"+base); 
	return c;
    }

    //-------------------------------------------------------------------------
    static void deconnexion(Connection c) 
	throws SQLException {
	System.out.println("ici deconnexion");
	c.close();
    }

    //-------------------------------------------------------------------------
    static void creerVillage(Connection c) 
	throws SQLException {

	// parametres :
	String v = lireClavier("entrez ville : ");
	String a = lireClavier("entrez activite : ");
	int p = Integer.parseInt(lireClavier("entrez prix : "));
	int cap = Integer.parseInt(lireClavier("entrez capacite : "));

	// construction texte ordre :
        String texte = 
	    "insert into village values(seq_village.nextval,'"
	    +v+"','"+a+"',"+p+","+cap+")";
        System.out.println(texte);

	// acces serveur :
	Statement stmt = c.createStatement();
	stmt.executeUpdate(texte);
	stmt.close();

	// retours : neant
    }

    //-------------------------------------------------------------------------
    static void traitement3(Connection c) throws SQLException {
	System.out.println("ici traitement3");

	// parametres :
	int jour = Integer.parseInt(lireClavier("entrez jour : "));

	// construction texte ordre :
        String texte = "delete sejour where jour<"+jour;
        System.out.println(texte);

	// acces serveur :
	Statement stmt = c.createStatement();
	int nb = stmt.executeUpdate(texte);
	stmt.close();

	// retours :
	System.out.println("Retour : nombre de sejours detruits : "+nb);
    }

    //-------------------------------------------------------------------------
    static void traitement3TryCatch(Connection c) {
	System.out.println("ici traitement3TryCatch");
	int jour = Integer.parseInt(lireClavier("entrez jour : "));
        String texte = "delete sejour where jour<"+jour;
        System.out.println(texte);
	try {
	    Statement stmt = c.createStatement();
	    int nb = stmt.executeUpdate(texte);
	    stmt.close();
	    System.out.println("Retour : nombre de sejours detruits : "+nb);
	} catch (SQLException e) {
	    System.out.print("argl ! : ");
	    System.err.println(e);
	}
    }

    //-------------------------------------------------------------------------
    static void consulterVillagesEmploye(Connection c) 
	throws SQLException {
	System.out.println("ici consulterVillagesEmploye");
        String texte = "select * from village";
        System.out.println(texte);
	Statement stmt = c.createStatement();
	ResultSet r = stmt.executeQuery(texte);
	while (r.next())
	    System.out.println(r.getInt(1)+", "+r.getString(2)+", "
			       +r.getString(3)+", "+r.getInt(4)+", "
			       +r.getInt(5));
	r.close();
	stmt.close();
    }

    //-------------------------------------------------------------------------
    static void consulterVillagesClient(Connection c) 
	throws SQLException {
	System.out.println("ici consulterVillagesClient");
	int ic = Integer.parseInt(lireClavier("entrez identifiant client : "));
        String texte =
	    "select village.idv, ville, activite,prix, capacite\n"
	    +"from village, sejour\n"
	    +"where village.idv = sejour.idv and idc = "+ic;
        System.out.println(texte);
	Statement stmt = c.createStatement();
	ResultSet r = stmt.executeQuery(texte);
	while (r.next())
	    System.out.println(r.getInt(1)+", "+r.getString(2)+", "
			       +r.getString(3)+", "+r.getInt(4)+", "
			       +r.getInt(5));
	r.close();
	stmt.close();
    }

    //-------------------------------------------------------------------------
    static void consulterVillagesSansSejoursClient(Connection c) 
	throws SQLException {
	System.out.println("ici consulterVillagesSansSejoursClient");
        String texte = "select * from vue_village_sans_sejour";
        System.out.println(texte);
	Statement stmt = c.createStatement();
	ResultSet r = stmt.executeQuery(texte);
	while (r.next())
	    System.out.println(r.getInt(1)+", "+r.getString(2)+", "
			       +r.getString(3)+", "+r.getInt(4));
	r.close();
	stmt.close();
    }

    //-------------------------------------------------------------------------
    static void traitement1(Connection c) 
	throws SQLException {
	System.out.println("ici traitement1");

	// parametre(s) :
	String n = lireClavier("entrez nom : ");
	int a = Integer.parseInt(lireClavier("entrez age : "));

        String texte = "select seq_client.nextval from dual";
        System.out.println(texte);
	Statement s = c.createStatement();
	ResultSet r = s.executeQuery(texte);
	r.next();
	int ic = r.getInt(1); 
	r.close();
	// ideal serait un select into au lieu d'un curseur puisqu'il y a 
	// exactement une valeur de retour

        texte = 
	    "insert into client(idc,nom,age) values("+ic+",'"+n+"',"+a+")";
        System.out.println(texte);
	// acces serveur :
	Statement stmt = c.createStatement();
	stmt.executeUpdate(texte);
	stmt.close();

	// retour(s) :
	System.out.println("identifiant client : "+ic);
    }

    //-------------------------------------------------------------------------
    static void traitement2(Connection c) 
	throws SQLException {
	System.out.println("ici traitement2");

	// parametres :
	int ic = Integer.parseInt(lireClavier("entrez identifiant client : "));
	String v = lireClavier("entrez ville : ");
	int j = Integer.parseInt(lireClavier("entrez jour : "));

	// initialisation valeurs retour pour cas ou pas de village :
	int iv=-1;
	int is=-1;
	String a="neant";

	int p;
	String texte = "select idv, activite, prix from village"
                       +" where ville = '"+v+"' order by prix desc";
	System.out.println(texte);

	Statement s = c.createStatement();
	ResultSet r = s.executeQuery(texte);
	if (r.next()) {
	    iv = r.getInt(1); // affectation valeur de retour 
	    a = r.getString(2); // affectation valeur de retour 
	    p = r.getInt(3); 
	    r.close();
	    
	    // achat sejour :
	    texte = "insert into sejour values(seq_sejour.nextval,"+ic+","
                    +iv+","+j+")";
	    System.out.println(texte);
	    s.executeUpdate(texte); 
	    texte = "update client set avoir=avoir-"+p+" where idc="+ic; 
	    System.out.println(texte);
	    s.executeUpdate(texte);
	    
	    // affectation valeur de retour :
	    texte = "select seq_sejour.currval from dual";
	    // ideal serait select into au lieu curseur, comme dans traitement1
	    r = s.executeQuery(texte);
	    r.next();
	    is = r.getInt(1); 
	    r.close();
	}
	
	// retours :	
	System.out.println("village "+iv+", sejour "+is+", activite "+a);
    }

    //-------------------------------------------------------------------------
    static void doubleConnexion(Connection c) 
	throws SQLException, 
	       ClassNotFoundException { // a noter !
	System.out.println("ici doubleConnexion");

        String texte = "select count(*) from village";
        System.out.println(texte);
	Statement s = c.createStatement();
	ResultSet r = s.executeQuery(texte);
	r.next();
	int nb_moi = r.getInt(1); 
	r.close();
        s.close();

	Connection c2 = 
	    connexion("waller2_a", "AQWzsx34", "soracle", "dbinfo"); 
	s = c2.createStatement();
	r = s.executeQuery(texte);
	r.next();
	int nb_waller = r.getInt(1); 
	c2.close();
        s.close();

	String result;
	if (nb_moi<nb_waller)
	    result = "moi";
	else
	    result = "waller";
	System.out.println("c'est "+result);
    }

    //-------------------------------------------------------------------------
    static void traitement3Fun(Connection c) 
	throws SQLException {
	int j = Integer.parseInt(lireClavier("entrez le jour : "));
	CallableStatement cs = c.prepareCall("{? = call traitement3("+j+")}");
	cs.registerOutParameter(1, Types.INTEGER);
	cs.execute();
	int nb = cs.getInt(1);
	cs.close();
	System.out.println(" nombre de sejours detruits : "+nb);
    }

    //-------------------------------------------------------------------------
    static void traitement1Fun(Connection c) 
	throws SQLException {
	CallableStatement cs = 
	    c.prepareCall("{? = call traitement1('"+
			  lireClavier("nom client : ")+"',"+
			  Integer.parseInt(lireClavier("age : "))+")}");
	cs.registerOutParameter(1, Types.INTEGER);
	cs.execute();
	System.out.println("identifiant client : "+cs.getInt(1));
	cs.close();
    }

    //-------------------------------------------------------------------------
    static void traitement2Proc(Connection c) 
	throws SQLException {

	int idc = Integer.parseInt(lireClavier("identifiant client : "));
	String ville = lireClavier("ville ? ");
	int jour = Integer.parseInt(lireClavier("jour ? "));
	CallableStatement cs = 
	    c.prepareCall("{call traitement2("+idc+",'"+ville+"',"+jour+
			  ",?,?,?)}");
	cs.registerOutParameter(1, Types.INTEGER);
	cs.registerOutParameter(2, Types.INTEGER);
	cs.registerOutParameter(3, Types.VARCHAR);
	cs.execute();
	int idv=cs.getInt(1);
	int ids=cs.getInt(2);
	String activite=cs.getString(3);
	cs.close();
	System.out.println("identifiants village "+idv+", sejour "+ids+
			   ", activite "+activite);
    }

    //-------------------------------------------------------------------------
    static String lireClavier(String message) {
	// dans cette fonction l'exception est catchee pour ne pas avoir a la 
        // gerer dans le main, et donc mieux voir les exceptions BD
	try {
	    System.out.print(message);
	    BufferedReader clavier =
		new BufferedReader(new InputStreamReader(System.in));
	    return clavier.readLine();
	} catch (Exception e) {
	    return "erreur dans fonction lireClavier";
	}
    }

    //-------------------------------------------------------------------------
    public static void main(String[] args) 
	throws SQLException, ClassNotFoundException {
	// rem : une seule fois dans programme (donc pas dans connnexion) :
	Class.forName("oracle.jdbc.driver.OracleDriver"); 
	Connection c = connexion("waller_a", "AQWzsx34", "soracle", "dbinfo"); 
	while (true) {
	    System.out.println("-------------------------------");
	    System.out.println("Bienvenue dans le menu CorrJDBC");
	    System.out.println("0 : deconnexion");
	    System.out.println("1 : creer village (employe)");
	    System.out.println("2 : traitement 3 (employe)");
	    System.out.println("3 : traitement 3 avec try-catch");
	    System.out.println("4 : consulter villages (employe)");
	    System.out.println("5 : traitement 1 (client)");
	    System.out.println("6 : consulter villages (client)");
	    System.out.println("7 : consulter villages sans sejours (client)");
	    System.out.println("8 : traitement 2 (client)");
	    System.out.println("9 : double connexion");
	    System.out.println("10 : creerVillageBoucle"); 
	    System.out.println("11 : traitement3Fun"); 
	    System.out.println("12 : traitement1Fun"); 
	    System.out.println("13 : traitement2Proc"); 
	    System.out.println("14 : dropTable"); 
	    System.out.println("15 : dropToutesTables"); 
	    System.out.println("16 : traitement2ProcPlus"); 
	    System.out.println("17 : traitementFunPlus"); 
	    System.out.println("-1 : terminer");
	    int n = Integer.parseInt(lireClavier("Entrez votre choix : "));
	    switch (n) {
	    case 0 : deconnexion(c); break;
	    case 1 : creerVillage(c); break;
	    case 2 : traitement3(c); break;
	    case 3 : traitement3TryCatch(c); break;
	    case 4 : consulterVillagesEmploye(c); break;
	    case 5 : traitement1(c); break;
	    case 6 : consulterVillagesClient(c); break;
	    case 7 : consulterVillagesSansSejoursClient(c); break;
	    case 8 : traitement2(c); break;
	    case 9 : doubleConnexion(c); break;
	    case 10 : creerVillageBoucle(c); break;
	    case 11 : traitement3Fun(c); break;
	    case 12 : traitement1Fun(c); break;
	    case 13 : traitement2Proc(c); break;
	    case 14 : dropTable(c); break;
	    case 15 : dropToutesTables(c); break;
	    case 16 : traitement2ProcPlus(c); break;
	    case 17 : traitementFunPlus(c); break;
	    case -1 : return;
	    }
	}
    }
}

//-----------------------------------------------------------------------------
