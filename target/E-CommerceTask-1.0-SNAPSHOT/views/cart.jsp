<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart – Green Cart</title>

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
            --text-dark:   #1a1a1a;
            --text-muted:  #7a7a6a;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: var(--warm-white);
            color: var(--text-dark);
            min-height: 100vh;
        }

        /* NAVBAR */
        .navbar-custom {
            background: var(--green-dark);
            padding: 0.9rem 0;
            box-shadow: 0 2px 20px rgba(0,0,0,0.25);
        }
        .brand-text {
            font-family: 'Playfair Display', serif;
            font-size: 1.6rem;
            font-weight: 900;
            color: #fff;
        }
        .brand-dot { color: var(--green-light); }
        .btn-continue {
            background: transparent;
            color: rgba(255,255,255,0.85);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 50px;
            padding: 0.4rem 1.1rem;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
        }
        .btn-continue:hover { background: rgba(255,255,255,0.1); color: #fff; }

        /* PAGE HEADER */
        .page-header {
            background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
            padding: 2.5rem 0 2rem;
            color: #fff;
        }
        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            font-weight: 900;
        }
        .page-header p { color: rgba(255,255,255,0.7); font-size: 0.95rem; }

        /* EMPTY CART */
        .empty-cart {
            text-align: center;
            padding: 5rem 2rem;
        }
        .empty-icon { font-size: 5rem; margin-bottom: 1rem; opacity: 0.4; }
        .empty-cart h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.6rem;
            color: var(--green-dark);
            margin-bottom: 0.5rem;
        }
        .empty-cart p { color: var(--text-muted); margin-bottom: 1.5rem; }
        .btn-shop {
            background: var(--green-mid);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 0.65rem 2rem;
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            transition: all 0.2s;
            display: inline-block;
        }
        .btn-shop:hover { background: var(--green-dark); color: #fff; transform: translateY(-2px); }

        /* CART ITEMS */
        .cart-wrapper { max-width: 820px; margin: 0 auto; padding: 2.5rem 1rem; }

        .cart-item {
            background: #fff;
            border-radius: 16px;
            padding: 1.2rem 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            transition: box-shadow 0.2s;
            animation: slideIn 0.4s ease forwards;
            opacity: 0;
        }
        .cart-item:hover { box-shadow: 0 6px 24px rgba(0,0,0,0.1); }

        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-16px); }
            to   { opacity: 1; transform: translateX(0); }
        }

        .item-index {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-muted);
            background: var(--cream);
            border-radius: 50%;
            width: 28px; height: 28px;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }

        .item-name {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 700;
            color: var(--green-dark);
            flex: 1;
        }
        .item-price {
            font-size: 0.85rem;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .item-subtotal {
            font-weight: 700;
            font-size: 1rem;
            color: var(--green-mid);
            min-width: 70px;
            text-align: right;
        }

        /* QTY CONTROLS */
        .qty-controls {
            display: flex;
            align-items: center;
            background: var(--cream);
            border-radius: 50px;
            overflow: hidden;
            border: 1px solid rgba(0,0,0,0.08);
        }
        .btn-qty {
            border: none;
            background: transparent;
            color: var(--green-dark);
            font-size: 1.1rem;
            font-weight: 700;
            padding: 0.35rem 0.9rem;
            cursor: pointer;
            transition: background 0.15s;
        }
        .btn-qty:hover { background: rgba(0,0,0,0.07); }
        .qty-num {
            font-weight: 700;
            font-size: 0.95rem;
            color: var(--green-dark);
            min-width: 26px;
            text-align: center;
        }

        /* ORDER SUMMARY */
        .summary-card {
            background: #fff;
            border-radius: 20px;
            padding: 1.8rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid rgba(0,0,0,0.05);
            margin-bottom: 1.5rem;
        }
        .summary-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--green-dark);
            margin-bottom: 1.2rem;
            padding-bottom: 0.8rem;
            border-bottom: 2px solid var(--cream);
        }
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.5rem 0;
            font-size: 0.92rem;
            color: var(--text-muted);
        }
        .summary-row.total {
            border-top: 2px solid var(--cream);
            margin-top: 0.5rem;
            padding-top: 1rem;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-dark);
        }
        .summary-row.total span:last-child { color: var(--green-mid); font-size: 1.3rem; }

        .btn-checkout {
            background: var(--green-mid);
            color: #fff;
            border: none;
            border-radius: 50px;
            width: 100%;
            padding: 0.85rem;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            display: block;
            text-align: center;
        }
        .btn-checkout:hover { background: var(--green-dark); color: #fff; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(45,106,79,0.35); }

        .secure-badge {
            text-align: center;
            margin-top: 0.8rem;
            font-size: 0.78rem;
            color: var(--text-muted);
        }

        /* FOOTER */
        .footer {
            background: var(--green-dark);
            color: rgba(255,255,255,0.5);
            text-align: center;
            padding: 1.2rem;
            font-size: 0.82rem;
            margin-top: 2rem;
        }
        .footer strong { color: var(--green-light); }

        /* RESPONSIVE */
        @media(max-width: 576px) {
            .cart-item { flex-wrap: wrap; }
            .item-subtotal { width: 100%; text-align: left; }
        }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="text-decoration-none">
            <span style="font-size:1.3rem">🌿</span>
            <span class="brand-text">Green<span class="brand-dot">Cart</span></span>
        </a>
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-continue">
            ← Continue Shopping
        </a>
    </div>
</nav>

<%-- PAGE HEADER --%>
<div class="page-header">
    <div class="container">
        <h1>🛒 Your Cart</h1>
        <p>Review your items before checkout</p>
    </div>
</div>

<%
    Map<String, Integer> cart =
        (Map<String, Integer>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
%>

<%-- EMPTY CART --%>
<div class="container">
    <div class="empty-cart">
        <div class="empty-icon">🛒</div>
        <h3>Your cart is empty</h3>
        <p>Looks like you haven't added anything yet.</p>
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-shop">
            🌿 Start Shopping
        </a>
    </div>
</div>

<%
    } else {
        double total    = 0;
        int totalQty    = 0;
        int itemCount   = 0;

        Connection conn = DbConnection.getConnection();

        // Pre-fetch all prices
        List<String>  names  = new ArrayList<>(cart.keySet());
        List<Integer> qtys   = new ArrayList<>();
        List<Double>  prices = new ArrayList<>();

        for (String name : names) {
            int qty = cart.get(name);
            PreparedStatement ps = conn.prepareStatement(
                "SELECT price FROM products WHERE name=?");
            ps.setString(1, name);
            ResultSet rs = ps.executeQuery();
            double price = 0;
            if (rs.next()) price = rs.getDouble("price");
            rs.close(); ps.close();
            qtys.add(qty);
            prices.add(price);
            total    += price * qty;
            totalQty += qty;
            itemCount++;
        }
        conn.close();
%>

<div class="cart-wrapper">
    <div class="row g-4">

        <%-- LEFT: CART ITEMS --%>
        <div class="col-lg-7">
            <div style="font-size:0.85rem; color:var(--text-muted); margin-bottom:1rem; font-weight:500;">
                <%= itemCount %> item<%= itemCount > 1 ? "s" : "" %> in your cart
            </div>

            <%
                for (int i = 0; i < names.size(); i++) {
                    String name  = names.get(i);
                    int    qty   = qtys.get(i);
                    double price = prices.get(i);
                    double sub   = price * qty;
                    int animDelay = i * 80;
            %>
            <div class="cart-item" style="animation-delay:<%= animDelay %>ms">

                <div class="item-index"><%= i + 1 %></div>

                <div style="flex:1; min-width:0;">
                    <div class="item-name"><%= name %></div>
                    <div class="item-price">₹<%= String.format("%.2f", price) %> × <%= qty %></div>
                </div>

                <form action="<%=request.getContextPath()%>/updateQuantity"
                      method="post" style="display:flex; align-items:center;">
                    <input type="hidden" name="productName" value="<%= name %>">
                    <div class="qty-controls">
                        <button class="btn-qty" type="submit" name="action" value="decrease">−</button>
                        <span class="qty-num"><%= qty %></span>
                        <button class="btn-qty" type="submit" name="action" value="increase">+</button>
                    </div>
                </form>

                <div class="item-subtotal">₹<%= String.format("%.2f", sub) %></div>
            </div>
            <%
                }
            %>
        </div>

        <%-- RIGHT: ORDER SUMMARY --%>
        <div class="col-lg-5">
            <div class="summary-card">
                <div class="summary-title">Order Summary</div>

                <div class="summary-row">
                    <span>Items (<%= itemCount %>)</span>
                    <span>₹<%= String.format("%.2f", total) %></span>
                </div>
                <div class="summary-row">
                    <span>Total Quantity</span>
                    <span><%= totalQty %> units</span>
                </div>
                <div class="summary-row">
                    <span>Delivery</span>
                    <span style="color:#52b788; font-weight:600;">FREE 🎉</span>
                </div>
                <div class="summary-row total">
                    <span>Total</span>
                    <span>₹<%= String.format("%.2f", total) %></span>
                </div>
            </div>

            <a href="<%=request.getContextPath()%>/views/checkout.jsp" class="btn-checkout">
                Proceed to Checkout →
            </a>
            <div class="secure-badge">🔒 Secure &amp; Encrypted Checkout</div>
        </div>

    </div>
</div>

<%
    }
%>

<div class="footer">
    <strong>Green Cart</strong> &nbsp;·&nbsp; Fresh produce, happy homes 🌿
</div>

</body>
</html>
