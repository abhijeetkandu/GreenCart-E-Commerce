package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

@WebServlet("/placeOrder")
public class Placeorderservlet extends HttpServlet {


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        String firstName = req.getParameter("firstName");
        String lastName = req.getParameter("lastName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String pin = req.getParameter("pin");
        String paymentMethod = req.getParameter("paymentMethod");

        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        Integer userId = (Integer) session.getAttribute("userId");

        if(cart == null || cart.isEmpty()){
            resp.sendRedirect(req.getContextPath() + "/views/cart.jsp");
            return;
        }

        Connection conn = null;
        try{
            conn = DbConnection.getConnection();
            double total = 0;
            for(Map.Entry<String, Integer> item : cart.entrySet()){
                PreparedStatement ps = conn.prepareStatement("SELECT price FROM products WHERE name=?");
                ps.setString(1, item.getKey());
                ResultSet rs = ps.executeQuery();
                if(rs.next())
                    total += rs.getDouble("price") * item.getValue();
                rs.close();
                ps.close();

            }
            PreparedStatement orderPs = conn.prepareStatement(
                    "INSERT INTO orders (user_id, total_amount, status, address, city, pin, phone, payment_method) " +
                            "VALUES (?, ?, 'Pending', ?, ?, ?, ?, ?)",
                    PreparedStatement.RETURN_GENERATED_KEYS);
            orderPs.setObject(1, userId);
            orderPs.setDouble(2, total);
            orderPs.setString(3, address + ", " + firstName + " " + lastName);
            orderPs.setString(4, city);
            orderPs.setString(5, pin);
            orderPs.setString(6, phone);
            orderPs.setString(7, paymentMethod);
            orderPs.executeUpdate();

            // Get generated order ID
            ResultSet generatedKeys = orderPs.getGeneratedKeys();
            int orderId = 0;
            if (generatedKeys.next()) orderId = generatedKeys.getInt(1);
            orderPs.close();

            // Insert order items
            PreparedStatement itemPs = conn.prepareStatement(
                    "INSERT INTO order_items (order_id, product_name, quantity, price) VALUES (?, ?, ?, ?)");
            for (Map.Entry<String, Integer> item : cart.entrySet()) {
                PreparedStatement pricePs = conn.prepareStatement(
                        "SELECT price FROM products WHERE name=?");
                pricePs.setString(1, item.getKey());
                ResultSet priceRs = pricePs.executeQuery();
                double price = 0;
                if (priceRs.next()) price = priceRs.getDouble("price");
                priceRs.close(); pricePs.close();

                itemPs.setInt(1, orderId);
                itemPs.setString(2, item.getKey());
                itemPs.setInt(3, item.getValue());
                itemPs.setDouble(4, price);
                itemPs.executeUpdate();
            }
            itemPs.close();

            // Clear cart after order placed
            session.removeAttribute("cart");

            // Store order id in session for confirmation page
            session.setAttribute("lastOrderId", "GC-" + orderId);
            session.setAttribute("lastOrderTotal", total);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        resp.sendRedirect(req.getContextPath() + "/views/checkout.jsp?success=true");
    }
}
