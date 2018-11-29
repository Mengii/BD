//l'action 1 : créer un village

import java.sql.*;
class Action1 {
    public static void main(String[] args)
        throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection c = DriverManager.getConnection(
            "jdbc:oracle:thin:c##mduan_a/mduan_a@tp-oracle:1522:dbinfo");  
        Statement s = c.createStatement();      
        String texte = "insert into  village values(1,'aaa','bla',10,100)";
        System.out.println(texte);
        s.executeUpdate(texte);
        s.close();
        c.close();      
    }
}
