package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/updateOrderStatus")
public class Updateorderstatusservlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int orderId = Integer.parseInt(req.getParameter("orderId"));
        String status = req.getParameter("status");

        Connection conn = null;
        try{
            conn = DbConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement("UPDATE order SET status = ? WHERE id= ?");
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
            ps.close();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            try{
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        resp.sendRedirect(req.getContextPath() + "/views/admin/adminorders.jsp");
    }

}
