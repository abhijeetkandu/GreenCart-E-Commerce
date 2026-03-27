package com.ecommerce.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DbConnection {

    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url      = "jdbc:mysql://mysql-34fe7fa-kanduabhi9408-54a5.j.aivencloud.com:20910/defaultdb?ssl-mode=REQUIRED";
        String username = "avnadmin";
        String password = "AVNS_2B4rtwJKBnUfwIcAi5E";
        Connection conn = DriverManager.getConnection(url, username, password);
        System.out.println("Connected Successfully ✅");
        return conn;
    }

    public static void main(String[] args) throws Exception {
        getConnection();
    }
}
