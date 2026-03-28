<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="com.ecommerce.model.DbConnection"%>
<%
    String admin = (String) session.getAttribute("admin");
    if(admin == null){
        response.sendRedirect(request.getContextPath()+"/views/adminlogin.jsp");
        return;
    }

    Connection conn = DbConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM products");
    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – Green Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --green-dark:  #1a3c2b;
            --green-mid:   #2d6a4f;
            --green-light: #52b788;
            --cream:       #f5f0e8;
            --warm-white:  #fdfaf5;
            --accent:      #e76f51;
            --yellow:      #f4a261;
            --text-dark:   #1a1a1a;
            --text-muted:  #7a7a6a;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'DM Sans', sans-serif; background: #f0f2f0; min-height: 100vh; }

        /* NAVBAR */
        .navbar-custom {
            background: var(--green-dark);
            padding: 0.85rem 0;
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 20px rgba(0,0,0,0.3);
        }
        .brand-text { font-family: 'Playfair Display', serif; font-size: 1.5rem; font-weight: 900; color: #fff; }
        .brand-dot  { color: var(--green-light); }
        .admin-tag  { background: rgba(255,255,255,0.12); color: rgba(255,255,255,0.8); font-size: 0.72rem; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase; padding: 0.2rem 0.7rem; border-radius: 50px; margin-left: 0.6rem; vertical-align: middle; }
        .btn-view-site { background: transparent; border: 1.5px solid rgba(255,255,255,0.35); color: rgba(255,255,255,0.85); border-radius: 50px; padding: 0.4rem 1.1rem; font-size: 0.85rem; font-weight: 600; text-decoration: none; transition: all 0.2s; }
        .btn-view-site:hover { background: rgba(255,255,255,0.1); color: #fff; border-color: rgba(255,255,255,0.6); }

        /* PAGE HEADER */
        .page-header {
            background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
            padding: 2rem 0 1.5rem;
            color: #fff;
        }
        .page-header h1 { font-family: 'Playfair Display', serif; font-size: 1.8rem; font-weight: 900; }
        .page-header p  { color: rgba(255,255,255,0.65); font-size: 0.88rem; margin-top: 0.2rem; }

        /* STAT CARDS */
        .stat-card {
            background: #fff;
            border-radius: 16px;
            padding: 1.3rem 1.5rem;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            display: flex; align-items: center; gap: 1rem;
            border: 1px solid rgba(0,0,0,0.04);
        }
        .stat-icon { font-size: 2rem; width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
        .stat-icon.green  { background: #e8f5ee; }
        .stat-icon.orange { background: #fff3ee; }
        .stat-icon.blue   { background: #eef3ff; }
        .stat-val  { font-family: 'Playfair Display', serif; font-size: 1.7rem; font-weight: 900; color: var(--green-dark); line-height: 1; }
        .stat-label { font-size: 0.78rem; color: var(--text-muted); font-weight: 500; margin-top: 2px; }

        /* SECTION CARD */
        .section-card { background: #fff; border-radius: 18px; box-shadow: 0 4px 20px rgba(0,0,0,0.07); border: 1px solid rgba(0,0,0,0.04); overflow: hidden; margin-bottom: 2rem; }
        .section-head { padding: 1.2rem 1.8rem; display: flex; align-items: center; justify-content: space-between; border-bottom: 2px solid var(--cream); }
        .section-head-title { font-family: 'Playfair Display', serif; font-size: 1.2rem; font-weight: 700; color: var(--green-dark); }
        .section-body { padding: 1.8rem; }

        /* FORM */
        .form-label { font-weight: 600; font-size: 0.83rem; color: var(--text-dark); margin-bottom: 0.3rem; }
        .form-control {
            border-radius: 10px; border: 1.5px solid #e0e0e0;
            padding: 0.65rem 1rem; font-size: 0.9rem;
            font-family: 'DM Sans', sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus { border-color: var(--green-mid); box-shadow: 0 0 0 3px rgba(45,106,79,0.1); outline: none; }
        .section-divider { border: none; border-top: 2px solid var(--cream); margin: 1.2rem 0; }

        .btn-add-product {
            background: var(--green-mid); color: #fff; border: none;
            border-radius: 50px; padding: 0.7rem 2rem;
            font-weight: 700; font-size: 0.95rem;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-add-product:hover { background: var(--green-dark); transform: translateY(-2px); box-shadow: 0 8px 20px rgba(45,106,79,0.3); }

        /* TABLE */
        .products-table { width: 100%; border-collapse: collapse; }
        .products-table thead tr { background: var(--cream); }
        .products-table th { padding: 0.9rem 1rem; font-size: 0.78rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.8px; color: var(--text-muted); text-align: left; border: none; }
        .products-table td { padding: 1rem 1rem; font-size: 0.9rem; color: var(--text-dark); border-bottom: 1px solid #f0f0f0; vertical-align: middle; }
        .products-table tbody tr:hover { background: #fafffe; }
        .products-table tbody tr:last-child td { border-bottom: none; }

        .product-id { font-size: 0.75rem; color: var(--text-muted); font-weight: 600; background: var(--cream); padding: 0.2rem 0.5rem; border-radius: 6px; }
        .product-name { font-weight: 600; color: var(--green-dark); font-family: 'Playfair Display', serif; }
        .price-tag { font-weight: 700; color: var(--green-mid); }

        .badge-stock-ok  { background: #e8f5ee; color: var(--green-mid); font-weight: 700; font-size: 0.8rem; padding: 0.3rem 0.7rem; border-radius: 50px; }
        .badge-stock-out { background: #fff0ee; color: var(--accent);    font-weight: 700; font-size: 0.8rem; padding: 0.3rem 0.7rem; border-radius: 50px; }
        .img-count { font-size: 0.8rem; color: var(--text-muted); }

        /* ACTION BUTTONS */
        .btn-edit {
            background: #fff8e6; color: #b07d00; border: 1.5px solid #f0d080;
            border-radius: 8px; padding: 0.35rem 0.8rem;
            font-size: 0.8rem; font-weight: 600; cursor: pointer;
            transition: all 0.15s; font-family: 'DM Sans', sans-serif;
        }
        .btn-edit:hover { background: #f4d35e; border-color: #e6c200; }

        .btn-delete {
            background: #fff0ee; color: var(--accent); border: 1.5px solid #ffc4b5;
            border-radius: 8px; padding: 0.35rem 0.8rem;
            font-size: 0.8rem; font-weight: 600; cursor: pointer;
            transition: all 0.15s; font-family: 'DM Sans', sans-serif;
        }
        .btn-delete:hover { background: var(--accent); color: #fff; border-color: var(--accent); }

        /* MODAL */
        .modal-content { border-radius: 20px; border: none; overflow: hidden; }
        .modal-header-custom { background: linear-gradient(135deg, var(--green-dark), var(--green-mid)); padding: 1.3rem 1.8rem; }
        .modal-header-custom h5 { font-family: 'Playfair Display', serif; font-size: 1.2rem; font-weight: 700; color: #fff; margin: 0; }
        .modal-header-custom .btn-close { filter: invert(1); opacity: 0.7; }
        .modal-body { padding: 1.8rem; }
        .modal-footer { border-top: 2px solid var(--cream); padding: 1rem 1.8rem; }

        .btn-modal-cancel { background: var(--cream); color: var(--text-dark); border: none; border-radius: 50px; padding: 0.6rem 1.5rem; font-weight: 600; font-family: 'DM Sans', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-modal-cancel:hover { background: #e0dbd0; }
        .btn-modal-update { background: var(--green-mid); color: #fff; border: none; border-radius: 50px; padding: 0.6rem 1.8rem; font-weight: 700; font-family: 'DM Sans', sans-serif; cursor: pointer; transition: all 0.2s; }
        .btn-modal-update:hover { background: var(--green-dark); box-shadow: 0 6px 18px rgba(45,106,79,0.3); }

        /* FADE IN */
        .fade-up { opacity: 0; transform: translateY(16px); animation: fadeUp 0.4s forwards; }
        @keyframes fadeUp { to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <div class="d-flex align-items-center">
            <span style="font-size:1.3rem; margin-right:6px">🌿</span>
            <span class="brand-text">Green<span class="brand-dot">Cart</span></span>
            <span class="admin-tag">Admin</span>
        </div>
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-view-site">
            🌐 View Store
        </a>
    </div>
</nav>

<%-- PAGE HEADER --%>
<div class="page-header">
    <div class="container">
        <h1>Dashboard</h1>
        <p>Welcome back, <strong><%= admin %></strong> — manage your store below</p>
    </div>
</div>

<%
    // Compute stats
    int totalProducts = 0, outOfStock = 0, totalImages = 0;
    PreparedStatement statPs = conn.prepareStatement("SELECT COUNT(*) FROM products");
    ResultSet statRs = statPs.executeQuery();
    if(statRs.next()) totalProducts = statRs.getInt(1);
    statRs.close(); statPs.close();

    statPs = conn.prepareStatement("SELECT COUNT(*) FROM products WHERE quantity = 0");
    statRs = statPs.executeQuery();
    if(statRs.next()) outOfStock = statRs.getInt(1);
    statRs.close(); statPs.close();

    statPs = conn.prepareStatement("SELECT COUNT(*) FROM product_images");
    statRs = statPs.executeQuery();
    if(statRs.next()) totalImages = statRs.getInt(1);
    statRs.close(); statPs.close();
%>

<%-- STAT CARDS --%>
<div class="container mt-4 mb-4">
    <div class="row g-3">
        <div class="col-md-4 fade-up" style="animation-delay:0ms">
            <div class="stat-card">
                <div class="stat-icon green">📦</div>
                <div>
                    <div class="stat-val"><%= totalProducts %></div>
                    <div class="stat-label">Total Products</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 fade-up" style="animation-delay:80ms">
            <div class="stat-card">
                <div class="stat-icon orange">⚠️</div>
                <div>
                    <div class="stat-val"><%= outOfStock %></div>
                    <div class="stat-label">Out of Stock</div>
                </div>
            </div>
        </div>
        <div class="col-md-4 fade-up" style="animation-delay:160ms">
            <div class="stat-card">
                <div class="stat-icon blue">🖼️</div>
                <div>
                    <div class="stat-val"><%= totalImages %></div>
                    <div class="stat-label">Product Images</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">

    <%-- ADD PRODUCT --%>
    <div class="section-card fade-up" style="animation-delay:200ms">
        <div class="section-head">
            <div class="section-head-title">➕ Add New Product</div>
        </div>
        <div class="section-body">
            <form action="<%=request.getContextPath()%>/addProduct" method="post" enctype="multipart/form-data">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Product Name</label>
                        <input type="text" name="name" class="form-control" placeholder="e.g. Organic Tomatoes" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Price (₹)</label>
                        <input type="number" name="price" class="form-control" placeholder="0.00" step="0.01" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Quantity</label>
                        <input type="number" name="quantity" class="form-control" placeholder="0" required>
                    </div>
                </div>

                <hr class="section-divider">
                <p class="form-label mb-3">Upload Product Images <span style="font-weight:400; color:var(--text-muted)">(up to 8)</span></p>

                <div class="row g-2">
                    <% for(int i=1; i<=8; i++){ %>
                    <div class="col-6 col-md-3">
                        <label class="form-label" style="font-size:0.75rem; color:var(--text-muted)">Image <%= i %></label>
                        <input type="file" name="image<%= i %>" class="form-control" style="font-size:0.8rem; padding:0.45rem 0.7rem;">
                    </div>
                    <% } %>
                </div>

                <div class="text-end mt-4">
                    <button type="submit" class="btn-add-product">✅ Add Product</button>
                </div>
            </form>
        </div>
    </div>

    <%-- MANAGE PRODUCTS --%>
    <div class="section-card fade-up" style="animation-delay:280ms">
        <div class="section-head">
            <div class="section-head-title">🗂️ Manage Products</div>
            <span style="font-size:0.8rem; color:var(--text-muted)"><%= totalProducts %> product<%= totalProducts != 1 ? "s" : "" %></span>
        </div>
        <div style="overflow-x:auto;">
            <table class="products-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Images</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    while(rs.next()) {
                        int pid       = rs.getInt("id");
                        String pname  = rs.getString("name");
                        double pprice = rs.getDouble("price");
                        int pqty      = rs.getInt("quantity");

                        PreparedStatement imgPs = conn.prepareStatement(
                            "SELECT COUNT(*) FROM product_images WHERE product_id=?");
                        imgPs.setInt(1, pid);
                        ResultSet imgRs = imgPs.executeQuery();
                        int imgCount = 0;
                        if(imgRs.next()) imgCount = imgRs.getInt(1);
                        imgRs.close(); imgPs.close();

                        String safeName = pname.replace("'", "\\'").replace("\"", "&quot;");
                %>
                <tr>
                    <td><span class="product-id">#<%= pid %></span></td>
                    <td><span class="product-name"><%= pname %></span></td>
                    <td><span class="price-tag">₹<%= String.format("%.2f", pprice) %></span></td>
                    <td>
                        <% if(pqty > 0) { %>
                            <span class="badge-stock-ok">✓ <%= pqty %> in stock</span>
                        <% } else { %>
                            <span class="badge-stock-out">✗ Out of stock</span>
                        <% } %>
                    </td>
                    <td><span class="img-count">🖼️ <%= imgCount %></span></td>
                    <td>
                        <button class="btn-edit me-1"
                            onclick="openEditModal('<%= pid %>','<%= safeName %>','<%= pprice %>','<%= pqty %>')">
                            ✏️ Edit
                        </button>
                        <form action="<%=request.getContextPath()%>/deleteProduct" method="post"
                              style="display:inline"
                              onsubmit="return confirm('Delete \'<%= pname %>\'? This cannot be undone.')">
                            <input type="hidden" name="productId" value="<%= pid %>">
                            <button type="submit" class="btn-delete">🗑️ Delete</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                    rs.close(); ps.close(); conn.close();
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<%-- UPDATE MODAL --%>
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header modal-header-custom d-flex align-items-center justify-content-between">
                <h5>✏️ Update Product</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%=request.getContextPath()%>/updateProduct" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <input type="hidden" name="productId" id="editProductId">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Product Name</label>
                            <input type="text" name="name" id="editName" class="form-control" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Price (₹)</label>
                            <input type="number" step="0.01" name="price" id="editPrice" class="form-control" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">Quantity</label>
                            <input type="number" name="quantity" id="editQuantity" class="form-control" required>
                        </div>
                    </div>
                    <hr class="section-divider">
                    <p class="form-label mb-3" style="color:var(--text-muted); font-weight:400;">
                        Upload new images <small>(optional — only replaces if new images are selected)</small>
                    </p>
                    <div class="row g-2">
                        <% for(int i=1; i<=8; i++){ %>
                        <div class="col-6 col-md-3">
                            <label class="form-label" style="font-size:0.75rem; color:var(--text-muted)">Image <%= i %></label>
                            <input type="file" name="image<%= i %>" class="form-control" style="font-size:0.8rem; padding:0.45rem 0.7rem;">
                        </div>
                        <% } %>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal-cancel" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn-modal-update">✅ Update Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function openEditModal(id, name, price, quantity) {
        document.getElementById('editProductId').value = id;
        document.getElementById('editName').value      = name;
        document.getElementById('editPrice').value     = price;
        document.getElementById('editQuantity').value  = quantity;
        new bootstrap.Modal(document.getElementById('editModal')).show();
    }
</script>

</body>
</html>
