<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String admin = (String) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/views/adminlogin.jsp");
        return;
    }
    Connection conn = DbConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM register ORDER BY id DESC");
    ResultSet rs = ps.executeQuery();

    // Count stats
    PreparedStatement totalPs = conn.prepareStatement("SELECT COUNT(*) FROM register");
    ResultSet totalRs = totalPs.executeQuery();
    int totalUsers = 0;
    if (totalRs.next()) totalUsers = totalRs.getInt(1);
    totalRs.close(); totalPs.close();

    PreparedStatement custPs = conn.prepareStatement("SELECT COUNT(*) FROM register WHERE role='Customer'");
    ResultSet custRs = custPs.executeQuery();
    int totalCustomers = 0;
    if (custRs.next()) totalCustomers = custRs.getInt(1);
    custRs.close(); custPs.close();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users – Green Cart Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root { --green-dark:#1a3c2b; --green-mid:#2d6a4f; --green-light:#52b788; --cream:#f5f0e8; --warm-white:#fdfaf5; --accent:#e76f51; --text-dark:#1a1a1a; --text-muted:#7a7a6a; }
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

        .stat-card { background:#fff; border-radius:16px; padding:1.3rem 1.5rem; box-shadow:0 2px 12px rgba(0,0,0,0.06); display:flex; align-items:center; gap:1rem; border:1px solid rgba(0,0,0,0.04); }
        .stat-icon { font-size:2rem; width:52px; height:52px; border-radius:14px; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .stat-icon.green { background:#e8f5ee; }
        .stat-icon.blue  { background:#eef3ff; }
        .stat-val { font-family:'Playfair Display',serif; font-size:1.7rem; font-weight:900; color:var(--green-dark); line-height:1; }
        .stat-label { font-size:0.78rem; color:var(--text-muted); font-weight:500; margin-top:2px; }

        .section-card { background:#fff; border-radius:18px; box-shadow:0 4px 20px rgba(0,0,0,0.07); border:1px solid rgba(0,0,0,0.04); overflow:hidden; margin-bottom:2rem; }
        .section-head { padding:1.2rem 1.8rem; display:flex; align-items:center; justify-content:space-between; border-bottom:2px solid var(--cream); }
        .section-head-title { font-family:'Playfair Display',serif; font-size:1.2rem; font-weight:700; color:var(--green-dark); }

        .users-table { width:100%; border-collapse:collapse; }
        .users-table thead tr { background:var(--cream); }
        .users-table th { padding:0.9rem 1rem; font-size:0.78rem; font-weight:700; text-transform:uppercase; letter-spacing:0.8px; color:var(--text-muted); text-align:left; border:none; }
        .users-table td { padding:1rem; font-size:0.88rem; color:var(--text-dark); border-bottom:1px solid #f0f0f0; vertical-align:middle; }
        .users-table tbody tr:hover { background:#fafffe; }
        .users-table tbody tr:last-child td { border-bottom:none; }

        .user-id { font-size:0.75rem; font-weight:700; background:var(--cream); color:var(--text-muted); padding:0.2rem 0.5rem; border-radius:6px; }
        .user-name { font-weight:600; color:var(--green-dark); }
        .user-email { font-size:0.8rem; color:var(--text-muted); }
        .badge-customer { background:#e8f5ee; color:var(--green-mid); border:1px solid #b8dfc9; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.75rem; font-weight:700; }
        .badge-admin { background:#fff8e6; color:#b07d00; border:1px solid #f0d080; border-radius:50px; padding:0.25rem 0.8rem; font-size:0.75rem; font-weight:700; }

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
            <a href="<%=request.getContextPath()%>/views/adminorders.jsp" class="btn-nav">🧾 Orders</a>
            <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-nav">🌐 View Store</a>
        </div>
    </div>
</nav>

<div class="page-header">
    <div class="container">
        <h1>👥 Manage Users</h1>
        <p>View all registered users</p>
    </div>
</div>

<div class="container py-4">

    <%-- STAT CARDS --%>
    <div class="row g-3 mb-4">
        <div class="col-md-6 fade-up">
            <div class="stat-card">
                <div class="stat-icon green">👥</div>
                <div>
                    <div class="stat-val"><%= totalUsers %></div>
                    <div class="stat-label">Total Users</div>
                </div>
            </div>
        </div>
        <div class="col-md-6 fade-up" style="animation-delay:80ms">
            <div class="stat-card">
                <div class="stat-icon blue">🛒</div>
                <div>
                    <div class="stat-val"><%= totalCustomers %></div>
                    <div class="stat-label">Total Customers</div>
                </div>
            </div>
        </div>
    </div>

    <%-- USERS TABLE --%>
    <div class="section-card fade-up" style="animation-delay:160ms">
        <div class="section-head">
            <div class="section-head-title">All Registered Users</div>
            <span style="font-size:0.8rem; color:var(--text-muted)"><%= totalUsers %> user<%= totalUsers != 1 ? "s" : "" %></span>
        </div>
        <div style="overflow-x:auto;">
            <table class="users-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Role</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    while (rs.next()) {
                        int uid      = rs.getInt("id");
                        String uname = rs.getString("name");
                        String email = rs.getString("email");
                        String role  = rs.getString("role");
                %>
                <tr>
                    <td><span class="user-id">#<%= uid %></span></td>
                    <td>
                        <div class="user-name"><%= uname %></div>
                    </td>
                    <td><span class="user-email"><%= email %></span></td>
                    <td>
                        <span class="<%= "Admin".equals(role) ? "badge-admin" : "badge-customer" %>">
                            <%= role %>
                        </span>
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

<div class="footer">
    <strong>Green Cart</strong> &nbsp;·&nbsp; Admin Panel 🌿
</div>

</body>
</html>
