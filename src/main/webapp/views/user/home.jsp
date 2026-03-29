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

    String userName = (String) session.getAttribute("userName");
    Integer userId  = (Integer) session.getAttribute("userId");

    Connection conn = DbConnection.getConnection();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE quantity > 0 ORDER BY id DESC");
    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GreenCart — Fresh Organic Groceries</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,600;0,9..144,700;0,9..144,900;1,9..144,300;1,9..144,700&family=Satoshi:wght@300;400;500;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        :root {
            --forest:   #0f2318;
            --pine:     #1a3d28;
            --leaf:     #246b3a;
            --sage:     #3a9460;
            --mint:     #5dbe82;
            --lime:     #a8e6bf;
            --cream:    #f8f4ed;
            --warm:     #fdfaf6;
            --clay:     #e8dfd0;
            --ember:    #d4522a;
            --wheat:    #f0c070;
            --ink:      #0c1a12;
            --mist:     #7a9485;
            --border:   #e2ddd6;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body {
            font-family: 'Satoshi', sans-serif;
            background: var(--warm);
            color: var(--ink);
            overflow-x: hidden;
        }

        /* ─── NAVBAR ─── */
        .navbar-gc {
            background: var(--forest);
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 1px solid rgba(255,255,255,0.06);
        }
        .navbar-inner {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            height: 64px;
        }
        .nav-brand {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }
        .brand-leaf {
            width: 34px; height: 34px;
            background: linear-gradient(135deg, var(--mint), var(--sage));
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
        }
        .brand-name {
            font-family: 'Fraunces', serif;
            font-size: 1.35rem;
            font-weight: 700;
            color: #fff;
            letter-spacing: -0.3px;
        }
        .brand-name em {
            font-style: normal;
            color: var(--mint);
        }

        .nav-center {
            display: flex;
            align-items: center;
            gap: 0.2rem;
        }
        .nav-link-gc {
            color: rgba(255,255,255,0.6);
            text-decoration: none;
            font-size: 0.88rem;
            font-weight: 500;
            padding: 0.45rem 1rem;
            border-radius: 8px;
            transition: all 0.2s;
        }
        .nav-link-gc:hover { color: #fff; background: rgba(255,255,255,0.07); }
        .nav-link-gc.active { color: var(--mint); }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }
        .btn-cart-nav {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--ember);
            color: #fff;
            text-decoration: none;
            border-radius: 50px;
            padding: 0.45rem 1.1rem;
            font-size: 0.85rem;
            font-weight: 700;
            transition: all 0.2s;
            border: none;
        }
        .btn-cart-nav:hover { background: #bc4420; color: #fff; transform: translateY(-1px); }
        .cart-count {
            background: rgba(255,255,255,0.25);
            border-radius: 50px;
            padding: 0 0.4rem;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .user-pill {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: rgba(255,255,255,0.7);
            font-size: 0.82rem;
        }
        .user-avatar-sm {
            width: 28px; height: 28px;
            border-radius: 8px;
            background: linear-gradient(135deg, var(--lime), var(--mint));
            display: flex; align-items: center; justify-content: center;
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--forest);
        }
        .btn-login-nav {
            color: rgba(255,255,255,0.7);
            text-decoration: none;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 8px;
            padding: 0.4rem 0.9rem;
            font-size: 0.82rem;
            transition: all 0.2s;
        }
        .btn-login-nav:hover { color: #fff; border-color: rgba(255,255,255,0.4); }

        /* ─── HERO ─── */
        .hero {
            background: var(--forest);
            position: relative;
            overflow: hidden;
            padding: 5rem 0 4rem;
        }
        .hero-bg-grid {
            position: absolute;
            inset: 0;
            background-image:
                linear-gradient(rgba(255,255,255,0.025) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255,255,255,0.025) 1px, transparent 1px);
            background-size: 60px 60px;
        }
        .hero-glow {
            position: absolute;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(93,190,130,0.12), transparent 65%);
            top: -150px; right: -100px;
            pointer-events: none;
        }
        .hero-glow-2 {
            position: absolute;
            width: 350px; height: 350px;
            background: radial-gradient(circle, rgba(93,190,130,0.07), transparent 65%);
            bottom: -50px; left: 5%;
            pointer-events: none;
        }
        .hero-content { position: relative; z-index: 2; }
        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: rgba(93,190,130,0.12);
            border: 1px solid rgba(93,190,130,0.25);
            color: var(--mint);
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            padding: 0.3rem 0.9rem;
            border-radius: 50px;
            margin-bottom: 1.5rem;
        }
        .hero-title {
            font-family: 'Fraunces', serif;
            font-size: clamp(2.8rem, 6vw, 4.5rem);
            font-weight: 900;
            color: #fff;
            line-height: 1.05;
            letter-spacing: -1.5px;
            margin-bottom: 1.2rem;
        }
        .hero-title em {
            font-style: italic;
            color: var(--mint);
        }
        .hero-subtitle {
            color: rgba(255,255,255,0.55);
            font-size: 1.05rem;
            font-weight: 300;
            max-width: 400px;
            line-height: 1.7;
            margin-bottom: 2rem;
        }
        .hero-actions {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .btn-hero-primary {
            background: var(--mint);
            color: var(--forest);
            font-weight: 700;
            font-size: 0.95rem;
            padding: 0.8rem 2rem;
            border-radius: 50px;
            text-decoration: none;
            transition: all 0.25s;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            border: none;
        }
        .btn-hero-primary:hover {
            background: #fff;
            color: var(--forest);
            transform: translateY(-2px);
            box-shadow: 0 12px 30px rgba(93,190,130,0.3);
        }
        .btn-hero-secondary {
            background: transparent;
            color: rgba(255,255,255,0.7);
            font-weight: 500;
            font-size: 0.95rem;
            padding: 0.8rem 1.8rem;
            border-radius: 50px;
            text-decoration: none;
            border: 1px solid rgba(255,255,255,0.2);
            transition: all 0.25s;
        }
        .btn-hero-secondary:hover { color: #fff; border-color: rgba(255,255,255,0.5); }

        .hero-right { position: relative; z-index: 2; }
        .hero-cards-stack {
            display: grid;
            gap: 0.8rem;
        }
        .hero-mini-card {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 16px;
            padding: 1rem 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.9rem;
            backdrop-filter: blur(10px);
            animation: floatCard 3s ease-in-out infinite;
        }
        .hero-mini-card:nth-child(2) { animation-delay: 1s; }
        .hero-mini-card:nth-child(3) { animation-delay: 2s; }
        @keyframes floatCard {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-4px); }
        }
        .mini-card-icon { font-size: 1.8rem; }
        .mini-card-title { font-size: 0.88rem; font-weight: 600; color: #fff; }
        .mini-card-sub { font-size: 0.72rem; color: rgba(255,255,255,0.45); margin-top: 1px; }

        /* TRUST BAR */
        .trust-bar {
            background: var(--cream);
            border-bottom: 1px solid var(--border);
            padding: 0.8rem 0;
        }
        .trust-items {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2.5rem;
            flex-wrap: wrap;
        }
        .trust-item {
            display: flex;
            align-items: center;
            gap: 0.45rem;
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--mist);
        }
        .trust-item span { font-size: 1rem; }

        /* SECTION */
        .section-wrap { padding: 3.5rem 0; }
        .section-label {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            color: var(--sage);
            margin-bottom: 0.5rem;
        }
        .section-title {
            font-family: 'Fraunces', serif;
            font-size: 2rem;
            font-weight: 700;
            color: var(--ink);
            letter-spacing: -0.5px;
            margin-bottom: 0.3rem;
        }
        .section-sub {
            color: var(--mist);
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }

        /* CATEGORY PILLS */
        .category-pills {
            display: flex;
            gap: 0.6rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }
        .cat-pill {
            background: #fff;
            border: 1.5px solid var(--border);
            color: var(--mist);
            border-radius: 50px;
            padding: 0.4rem 1.1rem;
            font-size: 0.82rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        .cat-pill:hover, .cat-pill.active {
            background: var(--forest);
            color: #fff;
            border-color: var(--forest);
        }

        /* PRODUCT CARD */
        .product-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid var(--border);
            transition: all 0.28s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            height: 100%;
            position: relative;
        }
        .product-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(12,26,18,0.12);
            border-color: transparent;
        }
        .product-img-wrap {
            position: relative;
            overflow: hidden;
            background: var(--cream);
            aspect-ratio: 4/3;
        }
        .product-img-wrap img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .product-card:hover .product-img-wrap img { transform: scale(1.06); }

        .badge-fresh {
            position: absolute;
            top: 10px; left: 10px;
            background: var(--forest);
            color: var(--mint);
            font-size: 0.65rem;
            font-weight: 700;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            z-index: 2;
        }
        .badge-low-stock {
            position: absolute;
            top: 10px; right: 10px;
            background: rgba(212,82,42,0.9);
            color: #fff;
            font-size: 0.65rem;
            font-weight: 700;
            padding: 0.2rem 0.6rem;
            border-radius: 50px;
            z-index: 2;
        }

        .product-body { padding: 1.1rem 1.1rem 1.2rem; }
        .product-name {
            font-family: 'Fraunces', serif;
            font-size: 1rem;
            font-weight: 600;
            color: var(--ink);
            margin-bottom: 0.3rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .product-price-row {
            display: flex;
            align-items: baseline;
            gap: 0.3rem;
            margin-bottom: 0.9rem;
        }
        .product-price {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--sage);
        }
        .product-unit {
            font-size: 0.75rem;
            color: var(--mist);
            font-weight: 400;
        }

        /* CART CONTROLS */
        .btn-add-cart {
            width: 100%;
            background: var(--forest);
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 0.6rem;
            font-size: 0.85rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'Satoshi', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.4rem;
        }
        .btn-add-cart:hover { background: var(--leaf); }
        .btn-add-cart:active { transform: scale(0.97); }

        .qty-wrap {
            display: flex;
            align-items: center;
            background: var(--cream);
            border-radius: 12px;
            overflow: hidden;
            border: 1.5px solid var(--border);
        }
        .btn-qty {
            border: none;
            background: transparent;
            color: var(--ink);
            font-size: 1.1rem;
            font-weight: 700;
            width: 38px; height: 38px;
            cursor: pointer;
            transition: background 0.15s;
            flex-shrink: 0;
        }
        .btn-qty:hover { background: var(--clay); }
        .qty-num {
            flex: 1;
            text-align: center;
            font-weight: 700;
            font-size: 0.95rem;
            color: var(--ink);
        }

        .stock-alert-inline {
            background: #fff3ef;
            border: 1px solid #ffc4b0;
            color: var(--ember);
            border-radius: 8px;
            padding: 0.3rem 0.6rem;
            font-size: 0.75rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            display: none;
            text-align: center;
        }

        /* OWL OVERRIDE */
        .owl-nav { position: absolute; top: 50%; width: 100%; display: flex; justify-content: space-between; transform: translateY(-50%); padding: 0 6px; pointer-events: none; }
        .owl-nav button { pointer-events: all; background: rgba(15,35,24,0.7) !important; color: white !important; border-radius: 50% !important; width: 28px !important; height: 28px !important; font-size: 0.75rem !important; display: flex !important; align-items: center; justify-content: center; border: none !important; }
        .owl-nav button:hover { background: rgba(15,35,24,0.95) !important; }
        .owl-dot span { background: #ccc !important; width: 5px !important; height: 5px !important; }
        .owl-dot.active span { background: var(--sage) !important; }
        .owl-dots { margin-top: 5px !important; }

        /* WHY SECTION */
        .why-section { background: var(--forest); padding: 4rem 0; }
        .why-card {
            background: rgba(255,255,255,0.06);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 20px;
            padding: 1.8rem 1.5rem;
            text-align: center;
            transition: all 0.25s;
        }
        .why-card:hover { background: rgba(255,255,255,0.1); transform: translateY(-4px); }
        .why-icon { font-size: 2.2rem; margin-bottom: 1rem; }
        .why-title { font-family: 'Fraunces', serif; font-size: 1.05rem; font-weight: 700; color: #fff; margin-bottom: 0.4rem; }
        .why-text { font-size: 0.82rem; color: rgba(255,255,255,0.45); line-height: 1.6; }

        /* NEWSLETTER */
        .newsletter-section {
            background: linear-gradient(135deg, var(--sage), var(--leaf));
            padding: 3rem 0;
            text-align: center;
        }
        .newsletter-section h3 {
            font-family: 'Fraunces', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: #fff;
            margin-bottom: 0.5rem;
        }
        .newsletter-section p { color: rgba(255,255,255,0.7); font-size: 0.9rem; margin-bottom: 1.5rem; }
        .newsletter-form { display: flex; max-width: 400px; margin: 0 auto; gap: 0.5rem; }
        .newsletter-input {
            flex: 1;
            border: none;
            border-radius: 50px;
            padding: 0.7rem 1.2rem;
            font-size: 0.88rem;
            font-family: 'Satoshi', sans-serif;
            outline: none;
        }
        .newsletter-btn {
            background: var(--forest);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 0.7rem 1.4rem;
            font-size: 0.85rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'Satoshi', sans-serif;
        }
        .newsletter-btn:hover { background: var(--ink); }

        /* FOOTER */
        .footer-gc {
            background: var(--ink);
            color: rgba(255,255,255,0.4);
            padding: 2rem 0;
        }
        .footer-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            margin-bottom: 1.2rem;
        }
        .footer-brand {
            font-family: 'Fraunces', serif;
            font-size: 1.2rem;
            font-weight: 700;
            color: #fff;
        }
        .footer-brand em { font-style: normal; color: var(--mint); }
        .footer-links { display: flex; gap: 1.5rem; flex-wrap: wrap; }
        .footer-link {
            color: rgba(255,255,255,0.4);
            text-decoration: none;
            font-size: 0.82rem;
            transition: color 0.2s;
        }
        .footer-link:hover { color: rgba(255,255,255,0.8); }
        .footer-copy { font-size: 0.78rem; text-align: center; }

        /* CHATBOT */
        #gc-bubble {
            position: fixed; bottom: 24px; right: 24px;
            width: 52px; height: 52px; border-radius: 50%;
            background: var(--sage); border: none; cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 4px 20px rgba(58,148,96,0.5);
            transition: all 0.2s; z-index: 9999;
        }
        #gc-bubble:hover { background: var(--leaf); transform: scale(1.08); }
        #gc-win {
            position: fixed; bottom: 88px; right: 24px;
            width: 350px; max-height: 500px;
            background: var(--warm); border-radius: 20px;
            border: 1px solid var(--border);
            display: flex; flex-direction: column; overflow: hidden;
            box-shadow: 0 16px 50px rgba(0,0,0,0.15); z-index: 9998;
            transition: opacity 0.2s, transform 0.2s;
        }
        #gc-win.gc-hidden { opacity: 0; pointer-events: none; transform: translateY(12px) scale(0.97); }
        .gc-header { background: var(--forest); padding: 13px 16px; display: flex; align-items: center; gap: 10px; }
        .gc-icon { width: 34px; height: 34px; background: var(--mint); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 15px; }
        .gc-header h4 { font-family: 'Fraunces', serif; color: #fff; font-size: 14px; font-weight: 700; margin: 0; }
        .gc-header p { color: rgba(255,255,255,0.5); font-size: 10px; margin: 0; }
        .gc-dot { width: 7px; height: 7px; background: var(--mint); border-radius: 50%; margin-left: auto; }
        .gc-close { background: none; border: none; cursor: pointer; color: rgba(255,255,255,0.5); font-size: 18px; }
        .gc-msgs { flex: 1; overflow-y: auto; padding: 13px; display: flex; flex-direction: column; gap: 9px; }
        .gc-lbl { font-size: 10px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 3px; color: var(--sage); }
        .gc-lbl.u { color: rgba(255,255,255,0.6); text-align: right; }
        .gc-msg { max-width: 82%; padding: 9px 12px; border-radius: 14px; font-size: 13px; line-height: 1.5; word-break: break-word; }
        .gc-msg.b { background: #fff; color: var(--ink); border: 1px solid var(--border); border-bottom-left-radius: 4px; align-self: flex-start; }
        .gc-msg.u { background: var(--sage); color: #fff; border-bottom-right-radius: 4px; align-self: flex-end; }
        .gc-typing { display: flex; gap: 4px; align-items: center; padding: 9px 12px; background: #fff; border: 1px solid var(--border); border-radius: 14px; border-bottom-left-radius: 4px; align-self: flex-start; }
        .gc-typing span { width: 6px; height: 6px; background: var(--sage); border-radius: 50%; animation: gcbounce 1.2s infinite; }
        .gc-typing span:nth-child(2) { animation-delay: 0.2s; }
        .gc-typing span:nth-child(3) { animation-delay: 0.4s; }
        @keyframes gcbounce { 0%,60%,100%{transform:translateY(0)} 30%{transform:translateY(-5px)} }
        .gc-chips { padding: 0 13px 9px; display: flex; flex-wrap: wrap; gap: 5px; }
        .gc-chip { background: var(--cream); color: var(--ink); border: 1px solid var(--border); border-radius: 50px; padding: 5px 11px; font-size: 11.5px; font-weight: 500; cursor: pointer; transition: all 0.15s; font-family: 'Satoshi', sans-serif; }
        .gc-chip:hover { background: var(--sage); color: #fff; border-color: var(--sage); }
        .gc-input-area { padding: 9px 11px 11px; background: #fff; border-top: 1px solid var(--border); display: flex; gap: 7px; align-items: center; }
        #gc-input { flex: 1; border: 1.5px solid var(--border); border-radius: 50px; padding: 8px 14px; font-size: 13px; font-family: 'Satoshi', sans-serif; outline: none; background: var(--warm); }
        #gc-input:focus { border-color: var(--sage); }
        #gc-send { width: 36px; height: 36px; border-radius: 50%; background: var(--ember); border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.2s; }
        #gc-send:hover { background: #bc4420; }

        /* ANIMATIONS */
        @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes cartPop { 0%,100%{transform:scale(1)} 50%{transform:scale(1.2)} }
        .fade-up { opacity: 0; transform: translateY(20px); animation: fadeUp 0.5s forwards; }
        .cart-pop { animation: cartPop 0.35s ease; }
    </style>
</head>
<body>

<!-- ═══ NAVBAR ═══ -->
<nav class="navbar-gc">
    <div class="navbar-inner" style="max-width:1200px; margin:0 auto; width:100%;">
        <a href="#" class="nav-brand">
            <div class="brand-leaf">🌿</div>
            <span class="brand-name">Green<em>Cart</em></span>
        </a>

        <div class="nav-center d-none d-md-flex">
            <a href="#" class="nav-link-gc active">Shop</a>
            <a href="#why-us" class="nav-link-gc">Why Us</a>
            <% if(userId != null) { %>
            <a href="<%=request.getContextPath()%>/views/user/orders.jsp" class="nav-link-gc">My Orders</a>
            <% } %>
        </div>

        <div class="nav-right">
            <% if(userName != null) { %>
            <div class="user-pill">
                <div class="user-avatar-sm"><%= userName.charAt(0) %></div>
                <span class="d-none d-sm-inline">Hi, <%= userName.split(" ")[0] %></span>
            </div>
            <a href="<%=request.getContextPath()%>/logout" class="btn-login-nav">Sign Out</a>
            <% } else { %>
            <a href="<%=request.getContextPath()%>/views/user/login.jsp" class="btn-login-nav">Login</a>
            <% } %>
            <a href="<%=request.getContextPath()%>/views/user/cart.jsp" class="btn-cart-nav" id="cartBtn">
                🛒 Cart <span class="cart-count" id="cartCount"><%= cart.size() %></span>
            </a>
        </div>
    </div>
</nav>

<!-- ═══ HERO ═══ -->
<section class="hero">
    <div class="hero-bg-grid"></div>
    <div class="hero-glow"></div>
    <div class="hero-glow-2"></div>
    <div class="container" style="max-width:1200px;">
        <div class="row align-items-center g-4">
            <div class="col-lg-6 hero-content">
                <div class="hero-tag">🌱 Farm to Doorstep</div>
                <h1 class="hero-title">
                    Freshness<br>you can <em>taste.</em>
                </h1>
                <p class="hero-subtitle">
                    Handpicked organic produce, zero middlemen. Direct from local farms to your kitchen — every single day.
                </p>
                <div class="hero-actions">
                    <a href="#products" class="btn-hero-primary">
                        Shop Now
                        <svg width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6"/></svg>
                    </a>
                    <% if(userId == null) { %>
                    <a href="<%=request.getContextPath()%>/views/user/register.jsp" class="btn-hero-secondary">Create Account</a>
                    <% } %>
                </div>
            </div>
            <div class="col-lg-5 offset-lg-1 hero-right d-none d-lg-block">
                <div class="hero-cards-stack">
                    <div class="hero-mini-card">
                        <div class="mini-card-icon">🥦</div>
                        <div>
                            <div class="mini-card-title">100% Organic</div>
                            <div class="mini-card-sub">Certified fresh produce</div>
                        </div>
                    </div>
                    <div class="hero-mini-card">
                        <div class="mini-card-icon">🚚</div>
                        <div>
                            <div class="mini-card-title">Free Delivery</div>
                            <div class="mini-card-sub">On every order, always</div>
                        </div>
                    </div>
                    <div class="hero-mini-card">
                        <div class="mini-card-icon">⚡</div>
                        <div>
                            <div class="mini-card-title">Same Day Dispatch</div>
                            <div class="mini-card-sub">Order before 2 PM</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- TRUST BAR -->
<div class="trust-bar">
    <div class="trust-items">
        <div class="trust-item"><span>🌿</span> Naturally Grown</div>
        <div class="trust-item"><span>🚚</span> Free Shipping</div>
        <div class="trust-item"><span>💯</span> Quality Guaranteed</div>
        <div class="trust-item"><span>🔒</span> Secure Payments</div>
        <div class="trust-item"><span>🌱</span> No Pesticides</div>
    </div>
</div>

<!-- ═══ PRODUCTS ═══ -->
<section class="section-wrap" id="products">
    <div class="container" style="max-width:1200px;">
        <div class="row align-items-end mb-2">
            <div class="col">
                <div class="section-label">Fresh Today</div>
                <h2 class="section-title">Our Products</h2>
                <p class="section-sub">All items harvested within 24 hours</p>
            </div>
        </div>

        <div class="row g-3 pb-4" id="productsGrid">
        <%
            int cardIdx = 0;
            while (rs.next()) {
                int pid      = rs.getInt("id");
                String name  = rs.getString("name");
                double price = rs.getDouble("price");
                int stock    = rs.getInt("quantity");
                int qty      = cart.getOrDefault(name, 0);
                int delay    = cardIdx * 60;
                boolean lowStock = stock > 0 && stock <= 5;
                cardIdx++;
                String safeName = name.replace("\"", "&quot;").replace("'", "&#39;");
        %>
            <div class="col-6 col-md-4 col-xl-3 fade-up" style="animation-delay:<%= delay %>ms">
                <div class="product-card">
                    <div class="product-img-wrap">
                        <span class="badge-fresh">🌿 Fresh</span>
                        <% if(lowStock) { %><span class="badge-low-stock">⚡ Only <%= stock %> left</span><% } %>
                        <div class="owl-carousel product-carousel">
                        <%
                            PreparedStatement imgPs = conn.prepareStatement("SELECT image_url FROM product_images WHERE product_id=?");
                            imgPs.setInt(1, pid);
                            ResultSet imgRs = imgPs.executeQuery();
                            boolean hasImg = false;
                            while(imgRs.next()) {
                                hasImg = true;
                                String imgPath = imgRs.getString("image_url");
                                String imgSrc = imgPath.startsWith("http") ? imgPath : request.getContextPath() + "/" + imgPath;
                        %>
                            <div><img src="<%= imgSrc %>" alt="<%= safeName %>" loading="lazy"></div>
                        <%
                            }
                            if(!hasImg) {
                        %>
                            <div><img src="https://via.placeholder.com/400x300/e8f4ec/246b3a?text=🌿" alt="No image"></div>
                        <%
                            }
                            imgRs.close(); imgPs.close();
                        %>
                        </div>
                    </div>
                    <div class="product-body">
                        <div class="product-name" title="<%= safeName %>"><%= name %></div>
                        <div class="product-price-row">
                            <span class="product-price">₹<%= String.format("%.0f", price) %></span>
                            <span class="product-unit">/ unit</span>
                        </div>
                        <div class="stock-alert-inline" id="alert-<%= pid %>"></div>
                        <div id="cart-control-<%= pid %>">
                        <% if(qty == 0) { %>
                            <button class="btn-add-cart" data-name="<%= safeName %>" data-pid="<%= pid %>" onclick="updateCart(this,'increase')">
                                <svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/></svg>
                                Add to Cart
                            </button>
                        <% } else { %>
                            <div class="qty-wrap">
                                <button class="btn-qty" data-name="<%= safeName %>" data-pid="<%= pid %>" onclick="updateCart(this,'decrease')">−</button>
                                <span class="qty-num"><%= qty %></span>
                                <button class="btn-qty" data-name="<%= safeName %>" data-pid="<%= pid %>" onclick="updateCart(this,'increase')">+</button>
                            </div>
                        <% } %>
                        </div>
                    </div>
                </div>
            </div>
        <%
            }
            rs.close(); ps.close(); conn.close();
        %>
        </div>
    </div>
</section>

<!-- WHY US -->
<section class="why-section" id="why-us">
    <div class="container" style="max-width:1200px;">
        <div class="text-center mb-4">
            <div class="section-label" style="color:var(--mint);">Why Choose Us</div>
            <h2 class="section-title" style="color:#fff; font-family:'Fraunces',serif;">The GreenCart difference</h2>
        </div>
        <div class="row g-3">
            <div class="col-6 col-md-3">
                <div class="why-card">
                    <div class="why-icon">🌾</div>
                    <div class="why-title">Farm Direct</div>
                    <div class="why-text">Straight from local farmers, no middlemen</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="why-card">
                    <div class="why-icon">❄️</div>
                    <div class="why-title">Cold Chain</div>
                    <div class="why-text">Temperature-controlled delivery always</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="why-card">
                    <div class="why-icon">♻️</div>
                    <div class="why-title">Eco Packaging</div>
                    <div class="why-text">100% biodegradable packaging materials</div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="why-card">
                    <div class="why-icon">⭐</div>
                    <div class="why-title">Quality Promise</div>
                    <div class="why-text">Not happy? We'll replace or refund</div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- NEWSLETTER -->
<section class="newsletter-section">
    <div class="container">
        <h3>Get fresh deals in your inbox</h3>
        <p>Subscribe for seasonal offers, new arrivals & farm stories</p>
        <div class="newsletter-form">
            <input type="email" class="newsletter-input" placeholder="your@email.com">
            <button class="newsletter-btn">Subscribe</button>
        </div>
    </div>
</section>

<!-- FOOTER -->
<footer class="footer-gc">
    <div class="container" style="max-width:1200px;">
        <div class="footer-top">
            <div class="footer-brand">Green<em>Cart</em></div>
            <div class="footer-links">
                <a href="#" class="footer-link">About</a>
                <a href="#" class="footer-link">Privacy</a>
                <a href="#" class="footer-link">Terms</a>
                <a href="#" class="footer-link">Contact</a>
                <% if(userId != null) { %>
                <a href="<%=request.getContextPath()%>/views/user/orders.jsp" class="footer-link">My Orders</a>
                <% } %>
            </div>
        </div>
        <div class="footer-copy">© 2025 GreenCart. Fresh produce, happy homes 🌿</div>
    </div>
</footer>

<!-- CHATBOT -->
<div id="gc-win" class="gc-hidden">
    <div class="gc-header">
        <div class="gc-icon">🌿</div>
        <div><h4>GreenCart Assistant</h4><p>Ask me anything</p></div>
        <div class="gc-dot"></div>
        <button class="gc-close" onclick="gcToggle()">✕</button>
    </div>
    <div class="gc-msgs" id="gc-msgs">
        <div>
            <div class="gc-lbl">GreenCart</div>
            <div class="gc-msg b">👋 Hi! I'm your GreenCart assistant. Ask about products, delivery, or anything about our store!</div>
        </div>
    </div>
    <div class="gc-chips" id="gc-chips">
        <button class="gc-chip" onclick="gcSuggest('What products do you have?')">Products</button>
        <button class="gc-chip" onclick="gcSuggest('How does delivery work?')">Delivery</button>
        <button class="gc-chip" onclick="gcSuggest('Any offers today?')">Offers</button>
        <button class="gc-chip" onclick="gcSuggest('How do I place an order?')">Order help</button>
    </div>
    <div class="gc-input-area">
        <input type="text" id="gc-input" placeholder="Ask anything..." onkeydown="if(event.key==='Enter') gcSend()">
        <button id="gc-send" onclick="gcSend()">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
        </button>
    </div>
</div>
<button id="gc-bubble" onclick="gcToggle()">
    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
</button>

<script>
    var contextPath = '<%=request.getContextPath()%>';

    function updateCart(btn, action) {
        var productName = btn.getAttribute('data-name');
        var pid = btn.getAttribute('data-pid');
        $.ajax({
            url: contextPath + '/updateQuantity',
            type: 'POST', dataType: 'text',
            data: { productName: productName, action: action, ajax: 'true' },
            success: function(response) {
                var parts = response.split('|');
                var status = parts[0], qty = parseInt(parts[1]);
                var cartSize = parseInt(parts[2]), message = parts[3] || '';
                var alertDiv = document.getElementById('alert-' + pid);
                var controlDiv = document.getElementById('cart-control-' + pid);
                if (status === 'error') {
                    alertDiv.textContent = '⚠️ ' + message;
                    alertDiv.style.display = 'block';
                    setTimeout(function(){ alertDiv.style.display = 'none'; }, 3000);
                } else {
                    alertDiv.style.display = 'none';
                    document.getElementById('cartCount').textContent = cartSize;
                    var cb = document.getElementById('cartBtn');
                    cb.classList.remove('cart-pop'); void cb.offsetWidth; cb.classList.add('cart-pop');
                    if (qty === 0) {
                        controlDiv.innerHTML = '<button class="btn-add-cart" data-name="' + productName + '" data-pid="' + pid + '" onclick="updateCart(this,\'increase\')"><svg width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/></svg> Add to Cart</button>';
                    } else {
                        controlDiv.innerHTML = '<div class="qty-wrap"><button class="btn-qty" data-name="' + productName + '" data-pid="' + pid + '" onclick="updateCart(this,\'decrease\')">−</button><span class="qty-num">' + qty + '</span><button class="btn-qty" data-name="' + productName + '" data-pid="' + pid + '" onclick="updateCart(this,\'increase\')">+</button></div>';
                    }
                    try{
                        if(typeof window.trackCartEvent === 'function'){
                           window.trackCartEvent(action, productName);
                        }
                    }catch(e){
                        console.warn('Tracking error:', e);
                    }
                }
            },
            error: function() { alert('Something went wrong. Please try again.'); }
        });
    }

    $(document).ready(function() {
        $('.product-carousel').owlCarousel({ items:1, loop:true, nav:true, dots:true, autoplay:true, autoplayTimeout:2800, autoplayHoverPause:true });
    });

    // Chatbot
    var gcOpen = false;
    function gcToggle() { gcOpen = !gcOpen; document.getElementById('gc-win').classList.toggle('gc-hidden', !gcOpen); }
    function gcAppend(text, type) {
        var msgs = document.getElementById('gc-msgs');
        var w = document.createElement('div');
        var lbl = document.createElement('div'); lbl.className = 'gc-lbl ' + (type==='u'?'u':''); lbl.textContent = type==='b'?'GreenCart':'You';
        var msg = document.createElement('div'); msg.className = 'gc-msg ' + type; msg.textContent = text;
        w.appendChild(lbl); w.appendChild(msg); msgs.appendChild(w); msgs.scrollTop = msgs.scrollHeight;
    }
    function gcTyping() { var m=document.getElementById('gc-msgs'); var e=document.createElement('div'); e.className='gc-typing'; e.id='gc-typing'; e.innerHTML='<span></span><span></span><span></span>'; m.appendChild(e); m.scrollTop=m.scrollHeight; }
    function gcRemoveTyping() { var e=document.getElementById('gc-typing'); if(e) e.remove(); }
    function gcSend() {
        var input=document.getElementById('gc-input'), query=input.value.trim();
        if(!query) return; input.value='';
        document.getElementById('gc-chips').style.display='none';
        gcAppend(query,'u'); gcTyping();
        fetch('https://ai-chatbot-jpq8.onrender.com/ai/groq?query='+encodeURIComponent(query),{method:'POST'})
            .then(r=>r.text()).then(t=>{gcRemoveTyping();gcAppend(t,'b');})
            .catch(()=>{gcRemoveTyping();gcAppend('Sorry, could not connect. Please try again!','b');});
    }
    function gcSuggest(text) { document.getElementById('gc-input').value=text; gcSend(); }
</script>
<meta name="contextPath" content="<%=request.getContextPath()%>">
<script src="<%=request.getContextPath()%>/js/tracking.js"></script>
</body>
</html>
