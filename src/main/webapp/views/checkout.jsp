<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Map<String, Integer> cart =
        (Map<String, Integer>) session.getAttribute("cart");

    double total  = 0;
    int totalQty  = 0;

    if (cart != null && !cart.isEmpty()) {
        Connection conn = DbConnection.getConnection();
        for (Map.Entry<String, Integer> item : cart.entrySet()) {
            PreparedStatement ps = conn.prepareStatement(
                "SELECT price FROM products WHERE name=?");
            ps.setString(1, item.getKey());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total    += rs.getDouble("price") * item.getValue();
                totalQty += item.getValue();
            }
            rs.close(); ps.close();
        }
        conn.close();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout – Green Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
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
        body { font-family: 'DM Sans', sans-serif; background: var(--warm-white); min-height: 100vh; }

        /* NAVBAR */
        .navbar-custom { background: var(--green-dark); padding: 0.9rem 0; box-shadow: 0 2px 20px rgba(0,0,0,0.25); }
        .brand-text { font-family: 'Playfair Display', serif; font-size: 1.6rem; font-weight: 900; color: #fff; }
        .brand-dot { color: var(--green-light); }

        /* PAGE HEADER */
        .page-header { background: linear-gradient(135deg, var(--green-dark), var(--green-mid)); padding: 2.5rem 0 2rem; color: #fff; }
        .page-header h1 { font-family: 'Playfair Display', serif; font-size: 2rem; font-weight: 900; }
        .page-header p { color: rgba(255,255,255,0.7); font-size: 0.95rem; }

        /* STEPPER */
        .stepper { display: flex; align-items: center; justify-content: center; gap: 0; margin: 2rem 0 2.5rem; }
        .step { display: flex; flex-direction: column; align-items: center; position: relative; }
        .step-circle {
            width: 38px; height: 38px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 0.85rem;
            background: var(--cream); color: var(--text-muted);
            border: 2px solid #ddd;
            transition: all 0.3s;
        }
        .step.active .step-circle { background: var(--green-mid); color: #fff; border-color: var(--green-mid); }
        .step.done .step-circle { background: var(--green-light); color: #fff; border-color: var(--green-light); }
        .step-label { font-size: 0.72rem; font-weight: 600; color: var(--text-muted); margin-top: 5px; text-transform: uppercase; letter-spacing: 0.5px; }
        .step.active .step-label { color: var(--green-mid); }
        .step-line { width: 80px; height: 2px; background: #ddd; margin-bottom: 20px; }
        .step-line.done { background: var(--green-light); }

        /* CARDS */
        .section-card {
            background: #fff;
            border-radius: 18px;
            padding: 1.8rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.07);
            border: 1px solid rgba(0,0,0,0.04);
            margin-bottom: 1.5rem;
        }
        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--green-dark);
            margin-bottom: 1.2rem;
            padding-bottom: 0.8rem;
            border-bottom: 2px solid var(--cream);
        }

        /* FORM */
        .form-label { font-weight: 600; font-size: 0.85rem; color: var(--text-dark); margin-bottom: 0.3rem; }
        .form-control {
            border-radius: 10px;
            border: 1.5px solid #e0e0e0;
            padding: 0.65rem 1rem;
            font-size: 0.9rem;
            font-family: 'DM Sans', sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus { border-color: var(--green-mid); box-shadow: 0 0 0 3px rgba(45,106,79,0.1); outline: none; }

        /* PAYMENT OPTIONS */
        .payment-option {
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            padding: 1rem 1.2rem;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.9rem;
            margin-bottom: 0.8rem;
            background: #fff;
        }
        .payment-option:hover { border-color: var(--green-light); background: #f9fdf9; }
        .payment-option.selected { border-color: var(--green-mid); background: #f0faf4; }
        .payment-option input[type="radio"] { accent-color: var(--green-mid); width: 17px; height: 17px; }
        .payment-icon { font-size: 1.5rem; }
        .payment-label { font-weight: 600; font-size: 0.92rem; color: var(--text-dark); }
        .payment-sub { font-size: 0.78rem; color: var(--text-muted); }

        /* ORDER SUMMARY */
        .summary-row { display: flex; justify-content: space-between; padding: 0.45rem 0; font-size: 0.9rem; color: var(--text-muted); }
        .summary-row.total { border-top: 2px solid var(--cream); margin-top: 0.5rem; padding-top: 1rem; font-size: 1.1rem; font-weight: 700; color: var(--text-dark); }
        .summary-row.total span:last-child { color: var(--green-mid); font-size: 1.2rem; }

        /* PLACE ORDER BUTTON */
        .btn-place-order {
            background: var(--green-mid);
            color: #fff;
            border: none;
            border-radius: 50px;
            width: 100%;
            padding: 0.9rem;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'DM Sans', sans-serif;
        }
        .btn-place-order:hover { background: var(--green-dark); transform: translateY(-2px); box-shadow: 0 8px 24px rgba(45,106,79,0.35); }
        .btn-place-order:active { transform: scale(0.98); }
        .secure-note { text-align: center; font-size: 0.78rem; color: var(--text-muted); margin-top: 0.7rem; }

        /* SUCCESS SCREEN */
        .success-screen {
            display: none;
            text-align: center;
            padding: 3rem 2rem;
        }
        .success-circle {
            width: 100px; height: 100px;
            background: linear-gradient(135deg, var(--green-light), var(--green-mid));
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 2.8rem;
            margin: 0 auto 1.5rem;
            box-shadow: 0 8px 30px rgba(82,183,136,0.4);
            animation: popIn 0.5s cubic-bezier(0.175,0.885,0.32,1.275) forwards;
        }
        @keyframes popIn {
            from { transform: scale(0); opacity: 0; }
            to   { transform: scale(1); opacity: 1; }
        }
        .success-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.9rem;
            font-weight: 900;
            color: var(--green-dark);
            margin-bottom: 0.5rem;
        }
        .success-sub { color: var(--text-muted); font-size: 0.95rem; margin-bottom: 0.4rem; }
        .order-id { font-size: 0.82rem; color: var(--text-muted); margin-bottom: 2rem; }
        .order-id span { font-weight: 700; color: var(--green-mid); }

        .btn-home {
            background: var(--green-mid);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 0.75rem 2.5rem;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
            font-family: 'DM Sans', sans-serif;
        }
        .btn-home:hover { background: var(--green-dark); color: #fff; transform: translateY(-2px); }

        /* CONFETTI */
        .confetti-piece {
            position: fixed;
            width: 10px; height: 10px;
            border-radius: 2px;
            animation: confettiFall linear forwards;
            pointer-events: none;
        }
        @keyframes confettiFall {
            0%   { transform: translateY(-20px) rotate(0deg); opacity: 1; }
            100% { transform: translateY(100vh) rotate(720deg); opacity: 0; }
        }

        /* FOOTER */
        .footer { background: var(--green-dark); color: rgba(255,255,255,0.5); text-align: center; padding: 1.2rem; font-size: 0.82rem; margin-top: 3rem; }
        .footer strong { color: var(--green-light); }

        /* FADE UP */
        .fade-up { opacity: 0; transform: translateY(20px); animation: fadeUp 0.5s forwards; }
        @keyframes fadeUp { to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar-custom">
    <div class="container d-flex align-items-center justify-content-between">
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="text-decoration-none d-flex align-items-center gap-2">
            <span style="font-size:1.3rem">🌿</span>
            <span class="brand-text">Green<span class="brand-dot">Cart</span></span>
        </a>
        <span style="color:rgba(255,255,255,0.5); font-size:0.85rem;">🔒 Secure Checkout</span>
    </div>
</nav>

<%-- PAGE HEADER --%>
<div class="page-header">
    <div class="container">
        <h1>Checkout</h1>
        <p>You're almost there! Complete your order below.</p>
    </div>
</div>

<%-- STEPPER --%>
<div class="container">
    <div class="stepper">
        <div class="step done">
            <div class="step-circle">✓</div>
            <div class="step-label">Cart</div>
        </div>
        <div class="step-line done"></div>
        <div class="step active">
            <div class="step-circle">2</div>
            <div class="step-label">Checkout</div>
        </div>
        <div class="step-line"></div>
        <div class="step">
            <div class="step-circle">3</div>
            <div class="step-label">Confirm</div>
        </div>
    </div>
</div>

<%-- MAIN CONTENT --%>
<div class="container pb-5" id="checkoutSection">
    <div class="row g-4">

        <%-- LEFT: FORM --%>
        <div class="col-lg-7 fade-up">

            <%-- Delivery Details --%>
            <div class="section-card">
                <div class="section-title">📦 Delivery Details</div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">First Name</label>
                        <input type="text" class="form-control" placeholder="e.g. Raj" id="firstName">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Last Name</label>
                        <input type="text" class="form-control" placeholder="e.g. Patel" id="lastName">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" placeholder="+91 XXXXX XXXXX" id="phone">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Delivery Address</label>
                        <textarea class="form-control" rows="2" placeholder="House No., Street, Area" id="address"></textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">City</label>
                        <input type="text" class="form-control" placeholder="e.g. Ahmedabad" id="city">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">PIN Code</label>
                        <input type="text" class="form-control" placeholder="e.g. 380001" id="pin">
                    </div>
                </div>
            </div>

            <%-- Payment Method --%>
            <div class="section-card">
                <div class="section-title">💳 Payment Method</div>

                <div class="payment-option selected" onclick="selectPayment(this, 'cod')">
                    <input type="radio" name="payment" value="cod" checked>
                    <span class="payment-icon">💵</span>
                    <div>
                        <div class="payment-label">Cash on Delivery</div>
                        <div class="payment-sub">Pay when your order arrives</div>
                    </div>
                </div>

                <div class="payment-option" onclick="selectPayment(this, 'upi')">
                    <input type="radio" name="payment" value="upi">
                    <span class="payment-icon">📱</span>
                    <div>
                        <div class="payment-label">UPI Payment</div>
                        <div class="payment-sub">GPay, PhonePe, Paytm & more</div>
                    </div>
                </div>

                <div class="payment-option" onclick="selectPayment(this, 'card')">
                    <input type="radio" name="payment" value="card">
                    <span class="payment-icon">💳</span>
                    <div>
                        <div class="payment-label">Credit / Debit Card</div>
                        <div class="payment-sub">Visa, Mastercard, RuPay</div>
                    </div>
                </div>
            </div>

        </div>

        <%-- RIGHT: ORDER SUMMARY --%>
        <div class="col-lg-5 fade-up" style="animation-delay:100ms">
            <div class="section-card">
                <div class="section-title">🧾 Order Summary</div>

                <%
                    if (cart != null) {
                        for (Map.Entry<String, Integer> item : cart.entrySet()) {
                %>
                <div class="summary-row">
                    <span><%= item.getKey() %> × <%= item.getValue() %></span>
                </div>
                <%
                        }
                    }
                %>

                <div class="summary-row" style="margin-top:0.5rem">
                    <span>Total Items</span>
                    <span><%= totalQty %> units</span>
                </div>
                <div class="summary-row">
                    <span>Delivery</span>
                    <span style="color:var(--green-light); font-weight:600;">FREE 🎉</span>
                </div>
                <div class="summary-row total">
                    <span>Total</span>
                    <span>₹<%= String.format("%.2f", total) %></span>
                </div>
            </div>

            <button class="btn-place-order" onclick="placeOrder()">
                ✅ Place Order
            </button>
            <div class="secure-note">🔒 Your information is 100% secure</div>
        </div>

    </div>
</div>

<%-- SUCCESS SCREEN --%>
<div class="container" id="successSection">
    <div class="section-card success-screen" id="successCard">
        <div class="success-circle">✓</div>
        <h2 class="success-title">Order Placed!</h2>
        <p class="success-sub">Thank you for shopping with <strong>Green Cart</strong> 🌿</p>
        <p class="success-sub">Your fresh groceries are on their way!</p>
        <p class="order-id">Order ID: <span id="orderId"></span></p>
        <a href="<%=request.getContextPath()%>/views/home.jsp" class="btn-home" onclick="clearCart()">
            🌿 Back to Home
        </a>
    </div>
</div>

<div class="footer">
    <strong>Green Cart</strong> &nbsp;·&nbsp; Fresh produce, happy homes 🌿
</div>

<script>
    // Payment option selection
    function selectPayment(el, val) {
        document.querySelectorAll('.payment-option').forEach(o => o.classList.remove('selected'));
        el.classList.add('selected');
        el.querySelector('input[type="radio"]').checked = true;
    }

    // Place order
    function placeOrder() {
        var firstName = document.getElementById('firstName').value.trim();
        var phone     = document.getElementById('phone').value.trim();
        var address   = document.getElementById('address').value.trim();
        var city      = document.getElementById('city').value.trim();
        var pin       = document.getElementById('pin').value.trim();

        if (!firstName || !phone || !address || !city || !pin) {
            alert('Please fill in all delivery details before placing the order.');
            return;
        }

        // Show success screen
        document.getElementById('checkoutSection').style.display = 'none';
        document.getElementById('successSection').style.display  = 'block';
        document.getElementById('successCard').style.display     = 'block';

        // Generate order ID
        var orderId = 'GC-' + Date.now().toString().slice(-8).toUpperCase();
        document.getElementById('orderId').textContent = orderId;

        // Confetti 🎉
        launchConfetti();
    }

    function clearCart() {
        // Optionally call a servlet to clear the session cart
        // For now just redirects back home
    }

    // Confetti animation
    function launchConfetti() {
        var colors = ['#52b788','#2d6a4f','#e76f51','#f4d35e','#1a3c2b'];
        for (var i = 0; i < 60; i++) {
            (function(i) {
                setTimeout(function() {
                    var el = document.createElement('div');
                    el.className = 'confetti-piece';
                    el.style.left = Math.random() * 100 + 'vw';
                    el.style.background = colors[Math.floor(Math.random() * colors.length)];
                    el.style.animationDuration = (Math.random() * 2 + 1.5) + 's';
                    el.style.animationDelay = '0s';
                    el.style.width  = (Math.random() * 8 + 6) + 'px';
                    el.style.height = (Math.random() * 8 + 6) + 'px';
                    document.body.appendChild(el);
                    setTimeout(function(){ el.remove(); }, 4000);
                }, i * 40);
            })(i);
        }
    }
</script>

</body>
</html>
