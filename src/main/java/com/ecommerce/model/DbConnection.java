package com.ecommerce.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {

        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://sql12.freesqldatabase.com:3306/sql12820648";
        String username = "sql12820648";
        String password = "D95vdyh6lQ";

        Connection conn = DriverManager.getConnection(url, username, password);

        System.out.println("Connected Successfully ✅");
        return conn;
    }

    public static void main(String[] args) throws Exception {
        getConnection();
    }
}
