static void exercice (String u, Connection c) throws SQLException {
    String texte = "select idc from demande where statut = 'ignore'";

    String f = lireClavier("Le nom de fonction suppression : ");
    
    Statement s = c.createStatement();   
    ResultSet r = s.executeQuery(texte);
    while(r.next()){
		System.out.println("idc selectes : " + r.getInt(1));
        
        texte = "{? = call "+u+"."+f+"("+r.getInt(1)+")}";
        CallableStatement cs = c.prepareCall(texte);
        cs.registerOutParameter(1, Types.VARCHAR);
        cs.execute();
    
        String num = cs.getString(1);
        System.out.println("numéro de téléphone : "+num);
    
        cs.close();
    }
    
    s.close();
}
