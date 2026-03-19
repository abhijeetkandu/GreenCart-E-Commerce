package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
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
        PrintWriter out = resp.getWriter();

        try {
            Connection conn = DbConnection.getConnection();

            String reg_name = req.getParameter("name");
            String reg_email = req.getParameter("email");
            String reg_password = req.getParameter("password");
            String confPass = req.getParameter("confpassword");
            String reg_role = req.getParameter("role");

            // Name Validation
            if (reg_name.length() < 3) {
                req.setAttribute("error", "Name must contain at least 3 characters!");
                RequestDispatcher rd = req.getRequestDispatcher("/views/register.jsp");
                rd.forward(req, resp);
                return;
            }

            // Password Validation
            if (!reg_password.matches("(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@#$%&!]).{8,}$")) {
                req.setAttribute("error",
                        "Password must contain 1 capital, 1 small, 1 digit and 1 special character!");
                RequestDispatcher rd = req.getRequestDispatcher("/views/register.jsp");
                rd.forward(req, resp);
                return;
            }

            // Confirm Password
            if (!reg_password.equals(confPass)) {
                req.setAttribute("error", "Password and Confirm Password do not match!");
                RequestDispatcher rd = req.getRequestDispatcher("/views/register.jsp");
                rd.forward(req, resp);
                return;
            }

            // Insert Query
            PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO register (name, email, password, role) VALUES (?, ?, ?, ?)"
            );
            ps.setString(1, reg_name);
            ps.setString(2, reg_email);
            ps.setString(3, reg_password);
            ps.setString(4, reg_role);

            int count = ps.executeUpdate();

            if (count > 0) {
                resp.sendRedirect(req.getContextPath() + "/views/login.jsp");
            } else {
                req.setAttribute("error", "Registration Failed! Try Again.");
                RequestDispatcher rd = req.getRequestDispatcher("/views/register.jsp");
                rd.include(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}