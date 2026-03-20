package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

@WebServlet("/regForm")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("text/html;charset=UTF-8");

        try {
            Connection conn     = DbConnection.getConnection();
            String reg_name     = req.getParameter("name");
            String reg_email    = req.getParameter("email");
            String reg_password = req.getParameter("password");
            String confPass     = req.getParameter("confpassword");
            String reg_role     = req.getParameter("role");

            // Name Validation — at least 3 characters
            if (reg_name == null || reg_name.trim().length() < 3) {
                req.setAttribute("error", "Name must contain at least 3 characters!");
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
                return;
            }

            // Confirm Password must match
            if (!reg_password.equals(confPass)) {
                req.setAttribute("error", "Password and Confirm Password do not match!");
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
                return;
            }

            
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO register (name, email, password, role) VALUES (?, ?, ?, ?)");
            ps.setString(1, reg_name.trim());
            ps.setString(2, reg_email);
            ps.setString(3, reg_password);
            ps.setString(4, reg_role);
            int count = ps.executeUpdate();

            if (count > 0) {
                resp.sendRedirect(req.getContextPath() + "/views/login.jsp");
            } else {
                req.setAttribute("error", "Registration Failed! Please try again.");
                req.getRequestDispatcher("/views/register.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
