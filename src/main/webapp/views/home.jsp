<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.ecommerce.model.DbConnection" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
    if (cart == null) {
        cart = new HashMap<>();
        session.setAttribute("cart", cart);
    }

    String stockMessage = (String) session.getAttribute("stockMessage");
    String stockProductName = (String) session.getAttribute("stockProductName");
    session.removeAttribute("stockMessage");
    session.removeAttribute("stockProductName");

    Connection conn = DbConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM products");
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Green Cart – Fresh Groceries</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
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
            overflow-x: hidden;
        }

        /* ── NAVBAR ── */
        .navbar-custom {
            background: var(--green-dark);
            padding: 0.9rem 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 20px rgba(0,0,0,0.25);
        }
        .brand-text {
            font-family: 'Playfair Display', serif;
            font-size: 1.7rem;
            font-weight: 900;
            color: #fff;
            letter-spacing: -0.5px;
        }
        .brand-dot { color: var(--green-light); }
        .leaf-icon { font-size: 1.4rem; margin-right: 6px; }

        .btn-cart {
            background: var(--accent);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 0.45rem 1.2rem;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .btn-cart:hover { background: #cf5a3b; color: #fff; transform: translateY(-1px); }

        .btn-admin-link {
            color: rgba(255,255,255,0.6);
            font-size: 0.82rem;
            text-decoration: none;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 50px;
            padding: 0.35rem 0.9rem;
            transition: all 0.2s;
        }
        .btn-admin-link:hover { color: #fff; border-color: rgba(255,255,255,0.5); }

        /* ── HERO BANNER ── */
        .hero {
            background: linear-gradient(135deg, var(--green-dark) 0%, var(--green-mid) 60%, var(--green-light) 100%);
            padding: 4rem 0 3rem;
            position: relative;
            overflow: hidden;
        }
        .hero::before {
            content: '';
            position: absolute;
            width: 500px; height: 500px;
            background: rgba(255,255,255,0.04);
            border-radius: 50%;
            top: -150px; right: -100px;
        }
        .hero::after {
            content: '';
            position: absolute;
            width: 300px; height: 300px;
            background: rgba(255,255,255,0.04);
            border-radius: 50%;
            bottom: -80px; left: -60px;
        }
        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: clamp(2.2rem, 5vw, 3.5rem);
            font-weight: 900;
            color: #fff;
            line-height: 1.1;
            margin-bottom: 1rem;
        }
        .hero-title span { color: var(--green-light); }
        .hero-subtitle {
            color: rgba(255,255,255,0.75);
            font-size: 1.05rem;
            font-weight: 300;
            max-width: 420px;
        }
        .hero-badge {
            display: inline-block;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            color: #fff;
            font-size: 0.78rem;
            font-weight: 600;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 0.3rem 0.9rem;
            border-radius: 50px;
            margin-bottom: 1.2rem;
        }
        .hero-emojis {
            font-size: 3.5rem;
            line-height: 1;
            filter: drop-shadow(0 4px 12px rgba(0,0,0,0.2));
        }

        /* ── SECTION HEADER ── */
        .section-header {
            padding: 3rem 0 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.9rem;
            font-weight: 700;
            color: var(--green-dark);
        }
        .section-line {
            flex: 1;
            height: 2px;
            background: linear-gradient(to right, var(--green-light), transparent);
            margin-left: 1.2rem;
        }

        /* ── PRODUCT CARD ── */
        .product-card {
            background: #fff;
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            transition: transform 0.25s, box-shadow 0.25s;
            height: 100%;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 35px rgba(0,0,0,0.13);
        }

        .carousel-wrapper {
            position: relative;
            overflow: hidden;
            background: var(--cream);
        }
        .carousel-wrapper img {
            height: 210px;
            width: 100%;
            object-fit: cover;
            transition: transform 0.4s;
        }
        .product-card:hover .carousel-wrapper img { transform: scale(1.04); }

        .card-body-custom {
            padding: 1.1rem 1.2rem 1.3rem;
        }
        .product-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.05rem;
            font-weight: 700;
            color: var(--green-dark);
            margin-bottom: 0.2rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .product-price {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--green-mid);
            margin-bottom: 0.8rem;
        }
        .product-price span {
            font-size: 0.8rem;
            font-weight: 400;
            color: var(--text-muted);
        }

        /* ── BUTTONS ── */
        .btn-add {
            background: var(--green-mid);
            color: #fff;
            border: none;
            border-radius: 50px;
            width: 100%;
            padding: 0.55rem;
            font-weight: 600;
            font-size: 0.88rem;
            transition: all 0.2s;
        }
        .btn-add:hover { background: var(--green-dark); color: #fff; }

        .qty-controls {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0;
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
            padding: 0.4rem 1rem;
            transition: background 0.15s;
            cursor: pointer;
        }
        .btn-qty:hover { background: rgba(0,0,0,0.06); }
        .qty-num {
            font-weight: 700;
            font-size: 1rem;
            color: var(--green-dark);
            min-width: 28px;
            text-align: center;
        }

        /* ── STOCK ALERT ── */
        .stock-alert {
            background: #fff3f0;
            border: 1px solid #ffc4b5;
            color: var(--accent);
            border-radius: 8px;
            padding: 0.35rem 0.6rem;
            font-size: 0.78rem;
            font-weight: 500;
            margin-bottom: 0.6rem;
            text-align: center;
        }

        /* ── OWL NAV ── */
        .owl-nav {
            position: absolute;
            top: 50%;
            width: 100%;
            display: flex;
            justify-content: space-between;
            transform: translateY(-50%);
            pointer-events: none;
            padding: 0 6px;
        }
        .owl-nav button {
            pointer-events: all;
            background: rgba(26,60,43,0.7) !important;
            color: white !important;
            border-radius: 50% !important;
            width: 30px !important;
            height: 30px !important;
            font-size: 0.8rem !important;
            display: flex !important;
            align-items: center;
            justify-content: center;
            border: none !important;
            transition: background 0.2s !important;
        }
        .owl-nav button:hover { background: rgba(26,60,43,0.95) !important; }
        .owl-dots { margin-top: 6px !important; }
        .owl-dot span { background: #ccc !important; width: 6px !important; height: 6px !important; }
        .owl-dot.active span { background: var(--green-mid) !important; }

        /* ── FOOTER ── */
        .footer {
            background: var(--green-dark);
            color: rgba(255,255,255,0.6);
            text-align: center;
            padding: 1.5rem;
            margin-top: 4rem;
            font-size: 0.85rem;
        }
        .footer strong { color: var(--green-light); }

        /* ── FADE IN ── */
        .fade-up {
            opacity: 0;
            transform: translateY(24px);
            animation: fadeUp 0.5s forwards;
        }
        @keyframes fadeUp {
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="#" class="text-decoration-none d-flex align-items-center">
            <span class="leaf-icon">🌿</span>
            <span class="brand-text">Green<span class="brand-dot">Cart</span></span>
        </a>
        <div class="d-flex align-items-center gap-3">
            <a href="<%=request.getContextPath()%>/views/adminlogin.jsp" class="btn-admin-link">Admin</a>
            <a href="cart.jsp" class="btn-cart">🛒 Cart (<%= cart.size() %>)</a>
        </div>
    </div>
</nav>

<%-- HERO --%>
<div class="hero">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-7">
                <div class="hero-badge">🌱 Farm to Doorstep</div>
                <h1 class="hero-title">Fresh &amp; <span>Organic</span><br>Groceries</h1>
                <p class="hero-subtitle">Handpicked seasonal produce delivered fresh. No middlemen, just nature's best straight to your home.</p>
            </div>
            <div class="col-md-5 text-center mt-4 mt-md-0">
                <div class="hero-emojis">🥦 🍅 🥕 🧅</div>
            </div>
        </div>
    </div>
</div>

<%-- PRODUCTS --%>
<div class="container">
    <div class="section-header">
        <h2 class="section-title">Our Products</h2>
        <div class="section-line"></div>
    </div>

    <div class="row g-4 pb-4">
    <%
        int cardIndex = 0;
        while (rs.next()) {
            int pid     = rs.getInt("id");
            String name = rs.getString("name");
            double price = rs.getDouble("price");
            int qty = cart.getOrDefault(name, 0);
            int delay = cardIndex * 80;
            cardIndex++;
    %>
        <div class="col-6 col-md-4 col-lg-3 fade-up" style="animation-delay: <%= delay %>ms">
            <div class="product-card">
                <div class="carousel-wrapper">
                    <div class="owl-carousel product-carousel">
                    <%
                        PreparedStatement imgPs = conn.prepareStatement(
                            "SELECT image_url FROM product_images WHERE product_id=?");
                        imgPs.setInt(1, pid);
                        ResultSet imgRs = imgPs.executeQuery();
                        boolean hasImage = false;
                        while (imgRs.next()) {
                            hasImage = true;
                            String imgPath = imgRs.getString("image_url");
                    %>
                        <div><img src="<%= imgPath.startsWith("http") ? imgPath : request.getContextPath() + "/" + imgPath %>" alt="<%= name %>"></div>
                    <%
                        }
                        if (!hasImage) {
                    %>
                        <div><img src="https://via.placeholder.com/300x210/e9f5ee/2d6a4f?text=🌿" alt="No image"></div>
                    <%
                        }
                        imgRs.close(); imgPs.close();
                    %>
                    </div>
                </div>

                <div class="card-body-custom">
                    <div class="product-name"><%= name %></div>
                    <div class="product-price">₹<%= price %> <span>/ unit</span></div>

                    <% if (stockMessage != null && stockProductName != null && stockProductName.equals(name)) { %>
                        <div class="stock-alert">⚠️ <%= stockMessage %></div>
                    <% } %>

                    <form action="<%=request.getContextPath()%>/updateQuantity" method="post">
                        <input type="hidden" name="productName" value="<%= name %>">
                        <% if (qty == 0) { %>
                            <button class="btn-add" type="submit" name="action" value="increase">+ Add to Cart</button>
                        <% } else { %>
                            <div class="qty-controls">
                                <button class="btn-qty" type="submit" name="action" value="decrease">−</button>
                                <span class="qty-num"><%= qty %></span>
                                <button class="btn-qty" type="submit" name="action" value="increase">+</button>
                            </div>
                        <% } %>
                    </form>
                </div>
            </div>
        </div>
    <%
        }
        rs.close(); ps.close(); conn.close();
    %>
    </div>
</div>

<div class="footer">
    <strong>Green Cart</strong> &nbsp;·&nbsp; Fresh produce, happy homes 🌿
</div>

<script>
    $(document).ready(function () {
        $('.product-carousel').owlCarousel({
            items: 1,
            loop: true,
            nav: true,
            dots: true,
            autoplay: true,
            autoplayTimeout: 2500,
            autoplayHoverPause: true
        });
    });
</script>

</body>
</html>
