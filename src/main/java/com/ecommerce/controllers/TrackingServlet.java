package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.cloudinary.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.stream.Collectors;

@WebServlet("/track")
public class TrackingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            BufferedReader reader = request.getReader();
            String json = reader.lines().collect(Collectors.joining());
            JSONObject obj = new JSONObject(json);

            String action = obj.getString("action");
            conn = DbConnection.getConnection();

            String sessionId = request.getSession().getId();

            // 🔹 SESSION START (also track PAGE VIEW)
            if (action.equals("session_start")) {

                String deviceType = obj.getString("deviceType");
                String pageUrl = obj.getString("pageUrl");

                // Save session
                ps = conn.prepareStatement(
                        "INSERT INTO user_sessions (session_id, device_type, ip_address, started_at, page_url) VALUES (?, ?, ?, NOW(), ?)"
                );
                ps.setString(1, sessionId);
                ps.setString(2, deviceType);
                ps.setString(3, request.getRemoteAddr());
                ps.setString(4, pageUrl);
                ps.executeUpdate();
                ps.close();

                // ALSO track page view (IMPORTANT FOR FUNNEL)
                ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url) VALUES (?, ?, ?)"
                );
                ps.setString(1, sessionId);
                ps.setString(2, "page_view");
                ps.setString(3, pageUrl);
                ps.executeUpdate();
            }

            // 🔹 PRODUCT CLICK
            else if (action.equals("product_click")) {
                ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url, event_data) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, sessionId);
                ps.setString(2, "product_click");
                ps.setString(3, obj.getString("pageUrl"));
                ps.setString(4, obj.getString("productName"));
                ps.executeUpdate();
            }

            // 🔹 ADD TO CART
            else if (action.equals("add_to_cart")) {
                ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url, event_data) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, sessionId);
                ps.setString(2, "add_to_cart");
                ps.setString(3, obj.getString("pageUrl"));
                ps.setString(4, obj.getString("productName"));
                ps.executeUpdate();
            }

            // 🔹 ORDER COMPLETED
            else if (action.equals("order_completed")) {
                ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url, event_data) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, sessionId);
                ps.setString(2, "order_completed");
                ps.setString(3, obj.getString("pageUrl"));
                ps.setString(4, obj.getString("orderId"));
                ps.executeUpdate();
            }

            // 🔹 TIME SPENT
            else if (action.equals("time_spent")) {
                ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url, time_on_page) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, sessionId);
                ps.setString(2, "time_spent");
                ps.setString(3, obj.getString("pageUrl"));
                ps.setInt(4, obj.getInt("time"));
                ps.executeUpdate();
            }

            response.setStatus(200);

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
        } finally {
            try { if (ps != null) ps.close(); } catch (Exception ignored) {}
            try { if (conn != null) conn.close(); } catch (Exception ignored) {}
        }
    }
}