import com.ecommerce.model.DbConnection;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.*;
import java.sql.*;

@WebServlet("/updateProduct")
@MultipartConfig
public class UpdateProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int productId    = Integer.parseInt(request.getParameter("productId"));
        String name      = request.getParameter("name");
        double price     = Double.parseDouble(request.getParameter("price"));
        int quantity     = Integer.parseInt(request.getParameter("quantity"));

        // Upload folder path (same as addProduct servlet)
        String uploadPath = getServletContext().getRealPath("") + "uploads" + File.separator;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        Connection conn = null;
        try {
            conn = DbConnection.getConnection();

            // 1. Update name, price, quantity
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE products SET name=?, price=?, quantity=? WHERE id=?");
            ps.setString(1, name);
            ps.setDouble(2, price);
            ps.setInt(3, quantity);
            ps.setInt(4, productId);
            ps.executeUpdate();
            ps.close();

            // 2. Check if any new image is uploaded
            boolean anyImage = false;
            for (int i = 1; i <= 8; i++) {
                Part p = request.getPart("image" + i);
                if (p != null && p.getSize() > 0) {
                    anyImage = true;
                    break;
                }
            }

            // 3. If new images uploaded → delete old images → insert new
            if (anyImage) {
                PreparedStatement delImg = conn.prepareStatement(
                    "DELETE FROM product_images WHERE product_id=?");
                delImg.setInt(1, productId);
                delImg.executeUpdate();
                delImg.close();

                for (int i = 1; i <= 8; i++) {
                    Part filePart = request.getPart("image" + i);
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = "product_" + productId + "_" + i + "_" + filePart.getSubmittedFileName();
                        filePart.write(uploadPath + fileName);
                        String imageUrl = "uploads/" + fileName;

                        PreparedStatement imgPs = conn.prepareStatement(
                            "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)");
                        imgPs.setInt(1, productId);
                        imgPs.setString(2, imageUrl);
                        imgPs.executeUpdate();
                        imgPs.close();
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }

        response.sendRedirect(request.getContextPath() + "/views/adminhome.jsp");
    }
}
