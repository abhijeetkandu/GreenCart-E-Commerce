package com.ecommerce.controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import com.ecommerce.model.DbConnection;

@WebServlet("/logForm")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String log_email = req.getParameter("email");
        String log_pass = req.getParameter("password");

        try {
            Connection conn = DbConnection.getConnection();

            String sql = "SELECT * FROM register WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, log_email);
            ps.setString(2, log_pass);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                // ✅ Session banana (important)
                HttpSession session = req.getSession();
                session.setAttribute("userEmail", log_email);
                session.setAttribute("userRole", rs.getString("role"));

                // ✅ Home page pe redirect
                resp.sendRedirect(req.getContextPath() + "/views/home.jsp");

            } else {

                // ❌ Login failed → error message bhejo
                req.setAttribute("error", "Invalid Email or Password!");
                req.getRequestDispatcher("views/login.jsp")
                   .forward(req, resp);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}