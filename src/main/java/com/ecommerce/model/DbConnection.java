
package com.ecommerce.model;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
public class DbConnection {
    public static Connection getConnection() throws ClassNotFoundException, SQLException{
             
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommerce_db","root","root");
        //System.out.println("Connection Built Successfull");
        return conn;
    }
    public static void main(String[] args) throws ClassNotFoundException, SQLException{
        //System.out.println(getConnection());
    }
    
}
