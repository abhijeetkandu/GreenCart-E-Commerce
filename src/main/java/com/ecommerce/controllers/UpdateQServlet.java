package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.sql.*;

@WebServlet("/updateQuantity")
public class UpdateQServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String name    = req.getParameter("productName");
        String action  = req.getParameter("action");
        boolean isAjax = "true".equals(req.getParameter("ajax"));

        HttpSession session = req.getSession();
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) cart = new HashMap<>();

        int currentQty = cart.getOrDefault(name, 0);
        String message = "";
        String status  = "ok";

        try {
            Connection conn = DbConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "SELECT quantity FROM products WHERE name=?");
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();

            int availableStock = -1;
            if (rs.next()) availableStock = rs.getInt("quantity");
            rs.close(); ps.close(); conn.close();

            if ("increase".equals(action)) {
                if (availableStock == -1) {
                    cart.put(name, currentQty + 1);
                } else if (availableStock == 0) {
                    status  = "error";
                    message = "Out Of Stock";
                    session.setAttribute("stockMessage", message);
                    session.setAttribute("stockProductName", name);
                } else if (currentQty >= availableStock) {
                    status  = "error";
                    message = "Insufficient Stock";
                    session.setAttribute("stockMessage", message);
                    session.setAttribute("stockProductName", name);
                } else {
                    cart.put(name, currentQty + 1);
                }
            } else if ("decrease".equals(action)) {
                if (currentQty > 1) {
                    cart.put(name, currentQty - 1);
                } else {
                    cart.remove(name);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            status  = "error";
            message = "Server error";
        }

        session.setAttribute("cart", cart);

        if (isAjax) {
            // Return text/html — pipe-separated values: status|qty|cartSize|message
            resp.setContentType("text/html");
            resp.setCharacterEncoding("UTF-8");
            int newQty   = cart.getOrDefault(name, 0);
            int cartSize = cart.size();
            resp.getWriter().write(status + "|" + newQty + "|" + cartSize + "|" + message);
        } else {
            resp.sendRedirect(req.getContextPath() + "/views/user/home.jsp");
        }
    }
}
