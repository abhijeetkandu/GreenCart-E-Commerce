<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/views/adminlogin.jsp");
        return;
    }
    Connection conn = DbConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement(
        "SELECT o.*, r.name as customer_name, r.email as customer_email " +
        "FROM orders o LEFT JOIN register r ON o.user_id = r.id " +
        "ORDER BY o.created_at DESC");
    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders – Green Cart Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --green-dark:#1a3c2b; --green-mid:#2d6a4f; --green-light:#52b788;
            --cream:#f5f0e8; --warm-white:#fdfaf5; --accent:#e76f51;
            --text-dark:#1a1a1a; --text-muted:#7a7a6a;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'DM Sans',sans-serif; background:#f0f2f0; min-height:100vh; }

        .navbar-custom { background:var(--green-dark); padding:0.85rem 0; position:sticky; top:0; z-index:100; box-shadow:0 2px 20px rgba(0,0,0,0.3); }
        .brand-text { font-family:'Playfair Display',serif; font-size:1.5rem; font-weight:900; color:#fff; }
        .brand-dot { color:var(--green-light); }
        .admin-tag { background:rgba(255,255,255,0.12); color:rgba(255,255,255,0.8); font-size:0.72rem; font-weight:700; letter-spacing:1.5px; text-transform:uppercase; padding:0.2rem 0.7rem; border-radius:50px; margin-left:0.6rem; }
        .btn-nav { color:rgba(255,255,255,0.75); text-decoration:none; border:1px solid rgba(255,255,255,0.25); border-radius:50px; padding:0.35rem 1rem; font-size:0.83rem; transition:all 0.2s; margin-left:0.5rem; }
        .btn-nav:hover { color:#fff; background:rgba(255,255,255,0.1); }

        .page-header { background:linear-gradient(135deg,var(--green-dark),var(--green-mid)); padding:2rem 0 1.5rem; color:#fff; }
        .page-header h1 { font-family:'Playfair Display',serif; font-size:1.8rem; font-weight:900; }

        .section-card { background:#fff; border-radius:18px; box-shadow:0 4px 20px rgba(0,0,0,0.07); border:1px solid rgba(0,0,0,0.04); overflow:hidden; margin-bottom:2rem; }
        .section-head { padding:1.2rem 1.8rem; display:flex; align-items:center; justify-content:space-between; border-bottom:2px solid var(--cream); }
        .section-head-title { font-family:'Playfair Display',serif; font-size:1.2rem; font-weight:700; color:var(--green-dark); }

        .orders-table { width:100%; border-collapse:collapse; }
        .orders-table thead tr { background:var(--cream); }
        .orders-table th { padding:0.9rem 1rem; font-size:0.78rem; font-weight:700; text-transform:uppercase; letter-spacing:0.8px; color:var(--text-muted); text-align:left; border:none; }
        .orders-table td { padding:1rem; font-size:0.88rem; color:var(--text-dark); border-bottom:1px solid #f0f0f0; vertical-align:middle; }
        .orders-table tbody tr:hover { background:#fafffe; }
        .orders-table tbody tr:last-child td { border-bottom:none; }

        .order-id-badge { font-size:0.75rem; font-weight:700; background:var(--cream); color:var(--text-muted); padding:0.2rem 0.5rem; border-radius:6px; }
        .customer-name { font-weight:600; color:var(--green-dark); }
        .customer-email { font-size:0.75rem; color:var(--text-muted); }
        .total-price { font-weight:700; color:var(--green-mid); }

        .badge-pending   { background:#fff8e6; color:#b07d00; border:1px solid #f0d080; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.75rem; font-weight:700; }
        .badge-delivered { background:#e8f5ee; color:var(--green-mid); border:1px solid #b8dfc9; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.75rem; font-weight:700; }
        .badge-cancelled { background:#fff0ee; color:var(--accent); border:1px solid #ffc4b5; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.75rem; font-weight:700; }
        .badge-processing { background:#eef3ff; color:#3a5bd9; border:1px solid #c0cef5; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.75rem; font-weight:700; }

        .status-select { border:1.5px solid #e0e0e0; border-radius:8px; padding:0.3rem 0.6rem; font-size:0.8rem; font-family:'DM Sans',sans-serif; cursor:pointer; transition:border-color 0.2s; }
        .status-select:focus { border-color:var(--green-mid); outline:none; }
        .btn-update-status { background:var(--green-mid); color:#fff; border:none; border-radius:8px; padding:0.3rem 0.8rem; font-size:0.78rem; font-weight:600; cursor:pointer; transition:all 0.2s; font-family:'DM Sans',sans-serif; }
        .btn-update-status:hover { background:var(--green-dark); }

        .fade-up { opacity:0; transform:translateY(16px); animation:fadeUp 0.4s forwards; }
        @keyframes fadeUp { to { opacity:1; transform:translateY(0); } }
        .footer { background:var(--green-dark); color:rgba(255,255,255,0.5); text-align:center; padding:1.2rem; font-size:0.82rem; margin-top:2rem; }
        .footer strong { color:var(--green-light); }
    </style>
</head>
<body>

<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <div class="d-flex align-items-center">
            <span style="font-size:1.3rem; margin-right:6px">🌿</span>
            <span class="brand-text">Green<span class="brand-dot">Cart</span></span>
            <span class="admin-tag">Admin</span>
        </div>
        <div>
            <a href="<%=request.getContextPath()%>/views/adminhome.jsp" class="btn-nav">📦 Products</a>
            <a href="<%=request.getContextPath()%>/views/adminusers.jsp" class="btn-nav">👥 Users</a>
            <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-nav">🌐 View Store</a>
        </div>
    </div>
</nav>

<div class="page-header">
    <div class="container">
        <h1>🧾 Manage Orders</h1>
        <p>View and update all customer orders</p>
    </div>
</div>

<div class="container py-4">
    <div class="section-card fade-up">
        <div class="section-head">
            <div class="section-head-title">All Orders</div>
        </div>
        <div style="overflow-x:auto;">
            <table class="orders-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Customer</th>
                        <th>Items</th>
                        <th>Total</th>
                        <th>Payment</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Update</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasOrders = false;
                    while (rs.next()) {
                        hasOrders = true;
                        int orderId        = rs.getInt("id");
                        double totalAmount = rs.getDouble("total_amount");
                        String status      = rs.getString("status");
                        String city        = rs.getString("city");
                        String payMethod   = rs.getString("payment_method");
                        Timestamp createdAt = rs.getTimestamp("created_at");
                        String custName    = rs.getString("customer_name");
                        String custEmail   = rs.getString("customer_email");
                        if (custName  == null) custName  = "Guest";
                        if (custEmail == null) custEmail = "-";

                        // Count items
                        PreparedStatement countPs = conn.prepareStatement(
                            "SELECT COUNT(*) FROM order_items WHERE order_id=?");
                        countPs.setInt(1, orderId);
                        ResultSet countRs = countPs.executeQuery();
                        int itemCount = 0;
                        if (countRs.next()) itemCount = countRs.getInt(1);
                        countRs.close(); countPs.close();

                        String badgeClass = "badge-pending";
                        if ("Delivered".equals(status))  badgeClass = "badge-delivered";
                        if ("Cancelled".equals(status))  badgeClass = "badge-cancelled";
                        if ("Processing".equals(status)) badgeClass = "badge-processing";
                %>
                <tr>
                    <td><span class="order-id-badge">#GC-<%= orderId %></span></td>
                    <td>
                        <div class="customer-name"><%= custName %></div>
                        <div class="customer-email"><%= custEmail %></div>
                        <div class="customer-email">📍 <%= city %></div>
                    </td>
                    <td><%= itemCount %> item(s)</td>
                    <td><span class="total-price">₹<%= String.format("%.2f", totalAmount) %></span></td>
                    <td style="font-size:0.8rem; color:var(--text-muted)"><%= payMethod %></td>
                    <td style="font-size:0.78rem; color:var(--text-muted)"><%= createdAt %></td>
                    <td><span class="<%= badgeClass %>"><%= status %></span></td>
                    <td>
                        <form action="<%=request.getContextPath()%>/updateOrderStatus" method="post" style="display:flex; gap:4px; align-items:center;">
                            <input type="hidden" name="orderId" value="<%= orderId %>">
                            <select name="status" class="status-select">
                                <option value="Pending"    <%= "Pending".equals(status)    ? "selected" : "" %>>Pending</option>
                                <option value="Processing" <%= "Processing".equals(status) ? "selected" : "" %>>Processing</option>
                                <option value="Delivered"  <%= "Delivered".equals(status)  ? "selected" : "" %>>Delivered</option>
                                <option value="Cancelled"  <%= "Cancelled".equals(status)  ? "selected" : "" %>>Cancelled</option>
                            </select>
                            <button type="submit" class="btn-update-status">✓</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                    rs.close(); ps.close(); conn.close();
                    if (!hasOrders) {
                %>
                <tr>
                    <td colspan="8" style="text-align:center; padding:3rem; color:var(--text-muted);">
                        No orders yet!
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="footer">
    <strong>Green Cart</strong> &nbsp;·&nbsp; Admin Panel 🌿
</div>

</body>
</html>
