<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/views/user/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart — GreenCart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,600;0,9..144,700;0,9..144,900;1,9..144,700&family=Satoshi:wght@300;400;500;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        :root {
            --forest:#0f2318; --pine:#1a3d28; --leaf:#246b3a; --sage:#3a9460; --mint:#5dbe82;
            --lime:#a8e6bf; --cream:#f8f4ed; --warm:#fdfaf6; --clay:#e8dfd0;
            --ember:#d4522a; --ink:#0c1a12; --mist:#7a9485; --border:#e2ddd6;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Satoshi',sans-serif; background:var(--warm); color:var(--ink); min-height:100vh; }

        /* NAV */
        .nav-gc { background:var(--forest); height:64px; display:flex; align-items:center; }
        .nav-inner { display:flex; align-items:center; justify-content:space-between; width:100%; max-width:1200px; margin:0 auto; padding:0 2rem; }
        .brand-name { font-family:'Fraunces',serif; font-size:1.3rem; font-weight:700; color:#fff; text-decoration:none; }
        .brand-name em { font-style:normal; color:var(--mint); }
        .btn-back-nav { color:rgba(255,255,255,0.6); text-decoration:none; font-size:0.85rem; border:1px solid rgba(255,255,255,0.18); border-radius:8px; padding:0.4rem 0.9rem; transition:all 0.2s; display:flex; align-items:center; gap:0.4rem; }
        .btn-back-nav:hover { color:#fff; border-color:rgba(255,255,255,0.4); }

        /* PAGE */
        .page-wrap { max-width:900px; margin:0 auto; padding:2.5rem 1.5rem; }
        .page-heading { font-family:'Fraunces',serif; font-size:2rem; font-weight:700; color:var(--ink); margin-bottom:0.3rem; letter-spacing:-0.5px; }
        .page-sub { color:var(--mist); font-size:0.88rem; margin-bottom:2rem; }

        /* EMPTY */
        .empty-state { text-align:center; padding:5rem 2rem; }
        .empty-emoji { font-size:4rem; margin-bottom:1rem; opacity:0.5; }
        .empty-state h3 { font-family:'Fraunces',serif; font-size:1.6rem; color:var(--ink); margin-bottom:0.5rem; }
        .empty-state p { color:var(--mist); margin-bottom:1.8rem; }
        .btn-shop { background:var(--forest); color:#fff; border:none; border-radius:50px; padding:0.7rem 2rem; font-weight:700; text-decoration:none; transition:all 0.2s; display:inline-flex; align-items:center; gap:0.5rem; font-family:'Satoshi',sans-serif; }
        .btn-shop:hover { background:var(--leaf); color:#fff; transform:translateY(-2px); }

        /* CART ITEMS */
        .cart-item {
            background:#fff;
            border:1.5px solid var(--border);
            border-radius:16px;
            padding:1.1rem 1.3rem;
            margin-bottom:0.8rem;
            display:flex;
            align-items:center;
            gap:1rem;
            transition:all 0.25s;
            animation:slideIn 0.35s ease forwards;
            opacity:0;
        }
        @keyframes slideIn { from{opacity:0;transform:translateX(-14px)} to{opacity:1;transform:translateX(0)} }
        .cart-item:hover { border-color:var(--mint); box-shadow:0 4px 20px rgba(15,35,24,0.08); }

        .item-num { font-size:0.72rem; font-weight:700; color:var(--mist); background:var(--cream); border-radius:50%; width:26px; height:26px; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .item-info { flex:1; min-width:0; }
        .item-name { font-family:'Fraunces',serif; font-size:1rem; font-weight:600; color:var(--ink); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .item-meta { font-size:0.8rem; color:var(--mist); margin-top:2px; }
        .item-subtotal { font-weight:700; font-size:1rem; color:var(--sage); min-width:75px; text-align:right; }

        .qty-control { display:flex; align-items:center; background:var(--cream); border-radius:10px; overflow:hidden; border:1.5px solid var(--border); }
        .qbtn { border:none; background:transparent; color:var(--ink); font-size:1.1rem; font-weight:700; width:36px; height:36px; cursor:pointer; transition:background 0.15s; }
        .qbtn:hover { background:var(--clay); }
        .qnum { font-weight:700; font-size:0.9rem; color:var(--ink); min-width:28px; text-align:center; }

        /* SUMMARY */
        .summary-card { background:#fff; border:1.5px solid var(--border); border-radius:20px; padding:1.6rem; position:sticky; top:80px; }
        .summary-title { font-family:'Fraunces',serif; font-size:1.15rem; font-weight:700; color:var(--ink); margin-bottom:1.2rem; padding-bottom:0.8rem; border-bottom:1.5px solid var(--border); }
        .sum-row { display:flex; justify-content:space-between; align-items:center; padding:0.45rem 0; font-size:0.88rem; color:var(--mist); }
        .sum-row.total { border-top:1.5px solid var(--border); margin-top:0.6rem; padding-top:0.9rem; font-size:1.05rem; font-weight:700; color:var(--ink); }
        .sum-row.total span:last-child { color:var(--sage); font-size:1.2rem; }
        .free-tag { color:var(--mint); font-weight:700; font-size:0.85rem; }

        .btn-checkout {
            display:block; width:100%;
            background:var(--forest); color:#fff;
            text-align:center; text-decoration:none;
            border-radius:14px; padding:0.9rem;
            font-weight:700; font-size:0.95rem;
            transition:all 0.25s; margin-top:1.2rem;
            font-family:'Satoshi',sans-serif;
            border:none; cursor:pointer;
        }
        .btn-checkout:hover { background:var(--leaf); color:#fff; transform:translateY(-2px); box-shadow:0 8px 24px rgba(15,35,24,0.2); }
        .secure-note { text-align:center; font-size:0.75rem; color:var(--mist); margin-top:0.7rem; }

        /* PROMO */
        .promo-wrap { display:flex; gap:0.5rem; margin-top:1rem; }
        .promo-input { flex:1; border:1.5px solid var(--border); border-radius:10px; padding:0.6rem 0.9rem; font-size:0.85rem; font-family:'Satoshi',sans-serif; outline:none; transition:border-color 0.2s; }
        .promo-input:focus { border-color:var(--sage); }
        .btn-promo { background:var(--cream); color:var(--ink); border:1.5px solid var(--border); border-radius:10px; padding:0.6rem 1rem; font-size:0.82rem; font-weight:600; cursor:pointer; font-family:'Satoshi',sans-serif; transition:all 0.2s; }
        .btn-promo:hover { background:var(--clay); }

        .footer-simple { background:var(--forest); color:rgba(255,255,255,0.35); text-align:center; padding:1.2rem; font-size:0.78rem; margin-top:3rem; }
        .footer-simple strong { color:var(--mint); }

        @media(max-width:576px) { .cart-item { flex-wrap:wrap; } .item-subtotal { width:100%; text-align:left; } }
    </style>
</head>
<body>

<nav class="nav-gc">
    <div class="nav-inner">
        <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="brand-name">Green<em>Cart</em></a>
        <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="btn-back-nav">
            <svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M11 17l-5-5m0 0l5-5m-5 5h12"/></svg>
            Continue Shopping
        </a>
    </div>
</nav>

<%
    Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
%>
<div class="container">
    <div class="empty-state">
        <div class="empty-emoji">🛒</div>
        <h3>Your cart is empty</h3>
        <p>Looks like you haven't added anything yet. Go explore our fresh products!</p>
        <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="btn-shop">🌿 Start Shopping</a>
    </div>
</div>
<%
    } else {
        double total = 0; int totalQty = 0; int itemCount = 0;
        Connection conn = DbConnection.getConnection();
        List<String> names = new ArrayList<>(cart.keySet());
        List<Integer> qtys = new ArrayList<>();
        List<Double> prices = new ArrayList<>();
        for (String name : names) {
            int q = cart.get(name);
            PreparedStatement ps = conn.prepareStatement("SELECT price FROM products WHERE name=?");
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            double price = 0;
            if(rs.next()) price = rs.getDouble("price");
            rs.close(); ps.close();
            qtys.add(q); prices.add(price);
            total += price * q; totalQty += q; itemCount++;
        }
        conn.close();
%>
<div class="page-wrap">
    <h1 class="page-heading">Your Cart</h1>
    <p class="page-sub"><%= itemCount %> item<%= itemCount>1?"s":"" %> — ready to checkout</p>

    <div class="row g-4">
        <!-- CART ITEMS -->
        <div class="col-lg-7">
            <%
                for(int i=0; i<names.size(); i++) {
                    String name = names.get(i); int qty = qtys.get(i);
                    double price = prices.get(i); double sub = price * qty;
                    int d = i * 70;
            %>
            <div class="cart-item" style="animation-delay:<%= d %>ms">
                <div class="item-num"><%= i+1 %></div>
                <div class="item-info">
                    <div class="item-name"><%= name %></div>
                    <div class="item-meta">₹<%= String.format("%.2f", price) %> × <%= qty %></div>
                </div>
                <form action="<%=request.getContextPath()%>/updateQuantity" method="post">
                    <input type="hidden" name="productName" value="<%= name %>">
                    <div class="qty-control">
                        <button class="qbtn" type="submit" name="action" value="decrease">−</button>
                        <span class="qnum"><%= qty %></span>
                        <button class="qbtn" type="submit" name="action" value="increase">+</button>
                    </div>
                </form>
                <div class="item-subtotal">₹<%= String.format("%.2f", sub) %></div>
            </div>
            <% } %>
        </div>

        <!-- SUMMARY -->
        <div class="col-lg-5">
            <div class="summary-card">
                <div class="summary-title">Order Summary</div>
                <div class="sum-row"><span>Subtotal (<%= itemCount %> items)</span><span>₹<%= String.format("%.2f", total) %></span></div>
                <div class="sum-row"><span>Qty Total</span><span><%= totalQty %> units</span></div>
                <div class="sum-row"><span>Delivery</span><span class="free-tag">🎉 FREE</span></div>
                <div class="sum-row total"><span>Total</span><span>₹<%= String.format("%.2f", total) %></span></div>

                <div class="promo-wrap">
                    <input type="text" class="promo-input" placeholder="Promo code">
                    <button class="btn-promo">Apply</button>
                </div>

                <a href="<%=request.getContextPath()%>/views/user/checkout.jsp" class="btn-checkout">
                    Proceed to Checkout →
                </a>
                <div class="secure-note">🔒 Secure & encrypted checkout</div>
            </div>
        </div>
    </div>
</div>
<% } %>

<div class="footer-simple"><strong>GreenCart</strong> · Fresh produce, happy homes 🌿</div>
<meta name="contextPath" content="<%=request.getContextPath()%>">
<script src="<%=request.getContextPath()%>/js/tracking.js"></script>
</body>
</html>
