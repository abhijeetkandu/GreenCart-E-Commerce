<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/views/login.jsp");
        return;
    }

    Connection conn = DbConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement(
        "SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders – Green Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --green-dark: #1a3c2b; --green-mid: #2d6a4f; --green-light: #52b788;
            --cream: #f5f0e8; --warm-white: #fdfaf5; --accent: #e76f51;
            --text-dark: #1a1a1a; --text-muted: #7a7a6a;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'DM Sans',sans-serif; background:#f0f2f0; min-height:100vh; }

        .navbar-custom { background:var(--green-dark); padding:0.9rem 0; box-shadow:0 2px 20px rgba(0,0,0,0.25); }
        .brand-text { font-family:'Playfair Display',serif; font-size:1.6rem; font-weight:900; color:#fff; }
        .brand-dot { color:var(--green-light); }
        .btn-back { color:rgba(255,255,255,0.8); text-decoration:none; border:1px solid rgba(255,255,255,0.3); border-radius:50px; padding:0.4rem 1.1rem; font-size:0.85rem; transition:all 0.2s; }
        .btn-back:hover { color:#fff; background:rgba(255,255,255,0.1); }

        .page-header { background:linear-gradient(135deg,var(--green-dark),var(--green-mid)); padding:2.5rem 0 2rem; color:#fff; }
        .page-header h1 { font-family:'Playfair Display',serif; font-size:2rem; font-weight:900; }
        .page-header p { color:rgba(255,255,255,0.65); font-size:0.88rem; }

        .order-card { background:#fff; border-radius:16px; box-shadow:0 4px 20px rgba(0,0,0,0.07); border:1px solid rgba(0,0,0,0.04); margin-bottom:1.2rem; overflow:hidden; transition:box-shadow 0.2s; }
        .order-card:hover { box-shadow:0 8px 30px rgba(0,0,0,0.1); }

        .order-head { padding:1.1rem 1.5rem; display:flex; align-items:center; justify-content:space-between; border-bottom:2px solid var(--cream); flex-wrap:wrap; gap:0.5rem; }
        .order-id { font-family:'Playfair Display',serif; font-weight:700; color:var(--green-dark); font-size:1rem; }
        .order-date { font-size:0.78rem; color:var(--text-muted); }

        .badge-pending  { background:#fff8e6; color:#b07d00; border:1px solid #f0d080; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.78rem; font-weight:700; }
        .badge-delivered { background:#e8f5ee; color:var(--green-mid); border:1px solid #b8dfc9; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.78rem; font-weight:700; }
        .badge-cancelled { background:#fff0ee; color:var(--accent); border:1px solid #ffc4b5; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.78rem; font-weight:700; }
        .badge-processing { background:#eef3ff; color:#3a5bd9; border:1px solid #c0cef5; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.78rem; font-weight:700; }

        .order-body { padding:1.1rem 1.5rem; }
        .order-item { display:flex; justify-content:space-between; align-items:center; padding:0.4rem 0; font-size:0.88rem; color:var(--text-dark); border-bottom:1px solid #f5f5f5; }
        .order-item:last-child { border-bottom:none; }
        .order-item-name { font-weight:500; }
        .order-item-qty { color:var(--text-muted); font-size:0.8rem; }
        .order-item-price { font-weight:700; color:var(--green-mid); }

        .order-foot { padding:0.8rem 1.5rem; background:var(--cream); display:flex; justify-content:space-between; align-items:center; }
        .order-total { font-weight:700; font-size:1rem; color:var(--green-dark); }
        .order-payment { font-size:0.78rem; color:var(--text-muted); }

        .empty-orders { text-align:center; padding:4rem 2rem; }
        .empty-icon { font-size:4rem; margin-bottom:1rem; opacity:0.4; }
        .empty-orders h3 { font-family:'Playfair Display',serif; font-size:1.5rem; color:var(--green-dark); margin-bottom:0.5rem; }
        .empty-orders p { color:var(--text-muted); margin-bottom:1.5rem; }
        .btn-shop { background:var(--green-mid); color:#fff; border:none; border-radius:50px; padding:0.7rem 2rem; font-weight:700; text-decoration:none; transition:all 0.2s; display:inline-block; }
        .btn-shop:hover { background:var(--green-dark); color:#fff; transform:translateY(-2px); }

        .fade-up { opacity:0; transform:translateY(16px); animation:fadeUp 0.4s forwards; }
        @keyframes fadeUp { to { opacity:1; transform:translateY(0); } }
        .footer { background:var(--green-dark); color:rgba(255,255,255,0.5); text-align:center; padding:1.2rem; font-size:0.82rem; margin-top:3rem; }
        .footer strong { color:var(--green-light); }
    </style>
</head>
<body>

<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="text-decoration-none d-flex align-items-center gap-2">
            <span style="font-size:1.3rem">🌿</span>
            <span class="brand-text">Green<span class="brand-dot">Cart</span></span>
        </a>
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-back">← Back to Home</a>
    </div>
</nav>

<div class="page-header">
    <div class="container">
        <h1>📦 My Orders</h1>
        <p>Track all your Green Cart orders</p>
    </div>
</div>

<div class="container py-4">
<%
    boolean hasOrders = false;
    int orderIndex = 0;
    while (rs.next()) {
        hasOrders = true;
        int orderId        = rs.getInt("id");
        double totalAmount = rs.getDouble("total_amount");
        String status      = rs.getString("status");
        String city        = rs.getString("city");
        String phone       = rs.getString("phone");
        String payMethod   = rs.getString("payment_method");
        Timestamp createdAt = rs.getTimestamp("created_at");
        int animDelay = orderIndex * 80;
        orderIndex++;

        // Fetch order items
        PreparedStatement itemPs = conn.prepareStatement(
            "SELECT * FROM order_items WHERE order_id=?");
        itemPs.setInt(1, orderId);
        ResultSet itemRs = itemPs.executeQuery();
%>
    <div class="order-card fade-up" style="animation-delay:<%= animDelay %>ms">
        <div class="order-head">
            <div>
                <div class="order-id">Order #GC-<%= orderId %></div>
                <div class="order-date">📅 <%= createdAt %> &nbsp;|&nbsp; 📍 <%= city %> &nbsp;|&nbsp; 📞 <%= phone %></div>
            </div>
            <div>
                <%
                    String badgeClass = "badge-pending";
                    if ("Delivered".equals(status))   badgeClass = "badge-delivered";
                    if ("Cancelled".equals(status))   badgeClass = "badge-cancelled";
                    if ("Processing".equals(status))  badgeClass = "badge-processing";
                %>
                <span class="<%= badgeClass %>"><%= status %></span>
            </div>
        </div>

        <div class="order-body">
            <% while(itemRs.next()) { %>
            <div class="order-item">
                <span class="order-item-name"><%= itemRs.getString("product_name") %></span>
                <span class="order-item-qty">× <%= itemRs.getInt("quantity") %></span>
                <span class="order-item-price">₹<%= String.format("%.2f", itemRs.getDouble("price") * itemRs.getInt("quantity")) %></span>
            </div>
            <% } %>
            <% itemRs.close(); itemPs.close(); %>
        </div>

        <div class="order-foot">
            <div class="order-total">Total: ₹<%= String.format("%.2f", totalAmount) %></div>
            <div class="order-payment">💳 <%= payMethod %></div>
        </div>
    </div>
<%
    }
    rs.close(); ps.close(); conn.close();

    if (!hasOrders) {
%>
    <div class="empty-orders">
        <div class="empty-icon">📦</div>
        <h3>No orders yet!</h3>
        <p>You haven't placed any orders yet. Start shopping!</p>
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-shop">🌿 Shop Now</a>
    </div>
<% } %>
</div>

<div class="footer">
    <strong>Green Cart</strong> &nbsp;·&nbsp; Fresh produce, happy homes 🌿
</div>

</body>
</html>
