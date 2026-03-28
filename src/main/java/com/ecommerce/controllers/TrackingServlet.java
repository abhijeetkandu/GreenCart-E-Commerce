package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/track")
public class TrackingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String action = req.getParameter("action");
        String sessionId = req.getSession().getId();

        try (Connection conn = DbConnection.getConnection()) {

            // 🟢 SESSION START
            if ("session_start".equals(action)) {

                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO user_sessions (session_id, device_type, started_at) VALUES (?, ?, NOW())"
                );

                ps.setString(1, sessionId);
                ps.setString(2, req.getParameter("deviceType"));
                ps.executeUpdate();
                ps.close();
            }


            else if ("event".equals(action)) {

                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO user_events (session_id, event_type, page_url, time_on_page) VALUES (?, ?, ?, ?)"
                );

                ps.setString(1, sessionId);
                ps.setString(2, req.getParameter("eventType"));
                ps.setString(3, req.getParameter("pageUrl"));

                int time = 0;
                try {
                    time = Integer.parseInt(req.getParameter("timeOnPage"));
                } catch (Exception ignored) {}

                ps.setInt(4, time);

                ps.executeUpdate();
                ps.close();
            }

            else if ("session_end".equals(action)) {

                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE user_sessions SET duration_seconds=? WHERE session_id=?"
                );

                int duration = 0;
                try {
                    duration = Integer.parseInt(req.getParameter("timeOnPage"));
                } catch (Exception ignored) {}

                ps.setInt(1, duration);
                ps.setString(2, sessionId);

                ps.executeUpdate();
                ps.close();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}