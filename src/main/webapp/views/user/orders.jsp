<%-- ════════════════════════════════════════════
    orders.jsp  — My Orders page
════════════════════════════════════════════ --%>
<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/views/user/login.jsp");
        return;
    }
    Connection conn = DbConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM orders WHERE user_id=? ORDER BY created_at DESC");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders — GreenCart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,600;0,9..144,700;0,9..144,900;1,9..144,700&family=Satoshi:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --forest:#0f2318; --leaf:#246b3a; --sage:#3a9460; --mint:#5dbe82;
            --cream:#f8f4ed; --warm:#fdfaf6; --clay:#e8dfd0; --ember:#d4522a;
            --sky:#3a7bd5; --ink:#0c1a12; --mist:#7a9485; --border:#e2ddd6;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Satoshi',sans-serif; background:var(--warm); color:var(--ink); min-height:100vh; }

        .nav-gc { background:var(--forest); height:64px; display:flex; align-items:center; }
        .nav-inner { display:flex; align-items:center; justify-content:space-between; width:100%; max-width:1200px; margin:0 auto; padding:0 2rem; }
        .brand-name { font-family:'Fraunces',serif; font-size:1.3rem; font-weight:700; color:#fff; text-decoration:none; }
        .brand-name em { font-style:normal; color:var(--mint); }
        .btn-back-nav { color:rgba(255,255,255,0.6); text-decoration:none; font-size:0.85rem; border:1px solid rgba(255,255,255,0.18); border-radius:8px; padding:0.4rem 0.9rem; transition:all 0.2s; }
        .btn-back-nav:hover { color:#fff; border-color:rgba(255,255,255,0.4); }

        /* PAGE HERO */
        .page-hero { background:var(--forest); padding:2.5rem 0 2rem; color:#fff; }
        .page-hero h1 { font-family:'Fraunces',serif; font-size:1.9rem; font-weight:700; letter-spacing:-0.5px; }
        .page-hero p { color:rgba(255,255,255,0.45); font-size:0.88rem; margin-top:0.3rem; }

        /* ORDER CARD */
        .order-card { background:#fff; border:1.5px solid var(--border); border-radius:18px; margin-bottom:1rem; overflow:hidden; transition:all 0.25s; animation:fadeUp 0.4s ease forwards; opacity:0; }
        @keyframes fadeUp { to{opacity:1;transform:translateY(0)} }
        .order-card { transform:translateY(16px); }
        .order-card:hover { box-shadow:0 8px 30px rgba(12,26,18,0.1); border-color:var(--mint); }

        .order-head { padding:1rem 1.4rem; display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:0.5rem; border-bottom:1px solid var(--border); }
        .order-id { font-family:'Fraunces',serif; font-weight:700; color:var(--ink); font-size:0.95rem; }
        .order-meta { font-size:0.75rem; color:var(--mist); margin-top:2px; }

        .badge-pending    { background:#fff8e6; color:#b07d00; border:1px solid #f0d080; border-radius:50px; padding:0.22rem 0.7rem; font-size:0.72rem; font-weight:700; }
        .badge-delivered  { background:#e6f9ef; color:var(--sage); border:1px solid #b8dfc9; border-radius:50px; padding:0.22rem 0.7rem; font-size:0.72rem; font-weight:700; }
        .badge-cancelled  { background:#fff0ec; color:var(--ember); border:1px solid #ffc4b5; border-radius:50px; padding:0.22rem 0.7rem; font-size:0.72rem; font-weight:700; }
        .badge-processing { background:#edf3ff; color:var(--sky); border:1px solid #c0cef5; border-radius:50px; padding:0.22rem 0.7rem; font-size:0.72rem; font-weight:700; }

        .order-body { padding:1rem 1.4rem; }
        .order-item { display:flex; justify-content:space-between; align-items:center; padding:0.4rem 0; font-size:0.86rem; border-bottom:1px solid #f5f5f2; }
        .order-item:last-child { border-bottom:none; }
        .item-n { font-weight:500; color:var(--ink); }
        .item-q { color:var(--mist); font-size:0.78rem; }
        .item-p { font-weight:700; color:var(--sage); font-size:0.88rem; }

        .order-foot { padding:0.8rem 1.4rem; background:var(--cream); display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:0.5rem; }
        .order-total { font-weight:700; font-size:0.95rem; color:var(--ink); }
        .order-pay { font-size:0.75rem; color:var(--mist); }

        /* EMPTY */
        .empty-st { text-align:center; padding:5rem 2rem; }
        .empty-st .ei { font-size:4rem; margin-bottom:1rem; opacity:0.4; }
        .empty-st h3 { font-family:'Fraunces',serif; font-size:1.5rem; color:var(--ink); margin-bottom:0.5rem; }
        .empty-st p { color:var(--mist); margin-bottom:1.5rem; font-size:0.9rem; }
        .btn-shop { background:var(--forest); color:#fff; border:none; border-radius:50px; padding:0.7rem 2rem; font-weight:700; text-decoration:none; display:inline-block; transition:all 0.2s; }
        .btn-shop:hover { background:var(--leaf); color:#fff; transform:translateY(-2px); }

        .footer-simple { background:var(--forest); color:rgba(255,255,255,0.35); text-align:center; padding:1.2rem; font-size:0.78rem; margin-top:3rem; }
        .footer-simple strong { color:var(--mint); }
    </style>
</head>
<body>

<nav class="nav-gc">
    <div class="nav-inner">
        <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="brand-name">Green<em>Cart</em></a>
        <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="btn-back-nav">← Back to Home</a>
    </div>
</nav>

<div class="page-hero">
    <div class="container" style="max-width:900px;">
        <h1>📦 My Orders</h1>
        <p>Track all your GreenCart orders</p>
    </div>
</div>

<div class="container py-4" style="max-width:900px;">
<%
    boolean hasOrders = false; int oidx = 0;
    while(rs.next()) {
        hasOrders = true;
        int oid         = rs.getInt("id");
        double oamt     = rs.getDouble("total_amount");
        String ostatus  = rs.getString("status");
        String ocity    = rs.getString("city");
        String ophone   = rs.getString("phone");
        String opay     = rs.getString("payment_method");
        Timestamp odate = rs.getTimestamp("created_at");
        int animD = oidx * 70; oidx++;

        PreparedStatement iPs = conn.prepareStatement("SELECT * FROM order_items WHERE order_id=?");
        iPs.setInt(1, oid); ResultSet iRs = iPs.executeQuery();

        String bc = "badge-pending";
        if("Delivered".equals(ostatus))  bc = "badge-delivered";
        if("Cancelled".equals(ostatus))  bc = "badge-cancelled";
        if("Processing".equals(ostatus)) bc = "badge-processing";
%>
    <div class="order-card" style="animation-delay:<%= animD %>ms">
        <div class="order-head">
            <div>
                <div class="order-id">Order #GC-<%= oid %></div>
                <div class="order-meta">📅 <%= odate != null ? odate.toString().substring(0,16) : "-" %> &nbsp;·&nbsp; 📍 <%= ocity %> &nbsp;·&nbsp; 📞 <%= ophone %></div>
            </div>
            <span class="<%= bc %>"><%= ostatus %></span>
        </div>
        <div class="order-body">
        <% while(iRs.next()) { %>
            <div class="order-item">
                <span class="item-n"><%= iRs.getString("product_name") %></span>
                <span class="item-q">× <%= iRs.getInt("quantity") %></span>
                <span class="item-p">₹<%= String.format("%.2f", iRs.getDouble("price") * iRs.getInt("quantity")) %></span>
            </div>
        <% } iRs.close(); iPs.close(); %>
        </div>
        <div class="order-foot">
            <div class="order-total">Total: ₹<%= String.format("%.2f", oamt) %></div>
            <div class="order-pay">💳 <%= opay %></div>
        </div>
    </div>
<%
    }
    rs.close(); ps.close(); conn.close();
    if(!hasOrders) {
%>
    <div class="empty-st">
        <div class="ei">📦</div>
        <h3>No orders yet!</h3>
        <p>You haven't placed any orders yet. Go explore our fresh products!</p>
        <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="btn-shop">🌿 Shop Now</a>
    </div>
<% } %>
</div>

<div class="footer-simple"><strong>GreenCart</strong> · Fresh produce, happy homes 🌿</div>
<meta name="contextPath" content="<%=request.getContextPath()%>">
<script src="<%=request.getContextPath()%>/js/tracking.js"></script>
</body>
</html>
