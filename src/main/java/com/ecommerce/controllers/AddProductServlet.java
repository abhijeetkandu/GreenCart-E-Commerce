
package com.ecommerce.controllers;

import com.ecommerce.model.DbConnection;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import static java.io.File.separator;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/addProduct")
@MultipartConfig
public class AddProductServlet extends HttpServlet {
    Connection conn;
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)throws IOException, ServletException{
        String pname = req.getParameter("name");
        String priceStr = req.getParameter("price");
        String quantityStr = req.getParameter("quantity");
        
       
        double price  = 0;
        int quantity = 0;
        if(priceStr != null && !priceStr.isEmpty()){
            price = Double.parseDouble(priceStr);
        }
        if(quantityStr != null && !quantityStr.isEmpty()){
            quantity = Integer.parseInt(quantityStr);
        }
        try{
            conn = DbConnection.getConnection();
            String insert_product_query = "INSERT INTO products(name,price,quantity) VALUES (?,?,?)";
            PreparedStatement ps = conn.prepareStatement(insert_product_query, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1,pname);
            ps.setDouble(2,price);
            ps.setInt(3,quantity);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            int productId= 0;
            if(rs.next()){
                productId = rs.getInt(1);
            }
            String uploadPath = getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            if(!uploadDir.exists()) uploadDir.mkdir();
            String insertImageQuery = "INSERT INTO product_images(product_id,image_url) VALUES (?,?)";
            PreparedStatement psImg = conn.prepareStatement(insertImageQuery);
            for(int i=1; i<=8; i++){
                Part filePart = req.getPart("image"+i);
                if(filePart != null && filePart.getSize() > 0){
                    String fileName = System.currentTimeMillis()+"_"+filePart.getSubmittedFileName();
                    filePart.write(uploadPath + separator + fileName);
                    String imgPath = "images/"+fileName;
                    
                    psImg.setInt(1, productId);
                    psImg.setString(2,imgPath);
                    psImg.executeUpdate();
                }
            }
            resp.sendRedirect(req.getContextPath()+"/views/home.jsp");
        }catch(Exception e){
            e.printStackTrace();
        }
    }
}
