package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.cloudinary.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.stream.Collectors;

@WebServlet("/track")
public class TrackingServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            // Parse JSON from request
            BufferedReader reader = request.getReader();
            String json = reader.lines().collect(Collectors.joining());
            JSONObject obj = new JSONObject(json);

            String action = obj.getString("action");
            conn = DbConnection.getConnection(); // your DB connection helper

            if (action.equals("session_start")) {
                String deviceType = obj.getString("deviceType");
                String pageUrl = obj.getString("pageUrl");

                ps = conn.prepareStatement(
                        "INSERT INTO user_sessions (session_id, device_type, started_at, page_url) VALUES (?, ?, NOW(), ?)"
                );
                ps.setString(1, request.getSession().getId());
                ps.setString(2, deviceType);
                ps.setString(3, pageUrl);
                ps.executeUpdate();

            } else if (action.equals("product_click")) {
                String productName = obj.getString("productName");
                ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url, extra_info) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, request.getSession().getId());
                ps.setString(2, "product_click");
                ps.setString(3, obj.getString("pageUrl"));
                ps.setString(4, productName);
                ps.executeUpdate();

            } else if (action.equals("order_completed")) {
                String orderId = obj.getString("orderId");
                ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url, extra_info) VALUES (?, ?, ?, ?)"
                );
                ps.setString(1, request.getSession().getId());
                ps.setString(2, "order_completed");
                ps.setString(3, obj.getString("pageUrl"));
                ps.setString(4, orderId);
                ps.executeUpdate();
            }

            response.setStatus(200);
        } catch(Exception e) {
            e.printStackTrace();
            response.setStatus(500);
        } finally {
            try { if(ps!=null) ps.close(); } catch(Exception e){}
            try { if(conn!=null) conn.close(); } catch(Exception e){}
        }
    }
}