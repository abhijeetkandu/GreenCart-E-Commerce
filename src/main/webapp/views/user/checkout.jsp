<%@page import="java.util.*,java.sql.*,com.ecommerce.model.DbConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
    String userName = (String) session.getAttribute("userName");
    double total = 0; int totalQty = 0;
    if (cart != null && !cart.isEmpty()) {
        Connection connC = DbConnection.getConnection();
        for (Map.Entry<String, Integer> item : cart.entrySet()) {
            PreparedStatement ps = connC.prepareStatement("SELECT price FROM products WHERE name=?");
            ps.setString(1, item.getKey());
            ResultSet rs = ps.executeQuery();
            if(rs.next()) { total += rs.getDouble("price") * item.getValue(); totalQty += item.getValue(); }
            rs.close(); ps.close();
        }
        connC.close();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout — GreenCart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,600;0,9..144,700;0,9..144,900;1,9..144,700&family=Satoshi:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --forest:#0f2318; --pine:#1a3d28; --leaf:#246b3a; --sage:#3a9460; --mint:#5dbe82;
            --cream:#f8f4ed; --warm:#fdfaf6; --clay:#e8dfd0; --ember:#d4522a;
            --ink:#0c1a12; --mist:#7a9485; --border:#e2ddd6;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Satoshi',sans-serif; background:var(--warm); color:var(--ink); min-height:100vh; }

        .nav-gc { background:var(--forest); height:64px; display:flex; align-items:center; }
        .nav-inner { display:flex; align-items:center; justify-content:space-between; width:100%; max-width:1200px; margin:0 auto; padding:0 2rem; }
        .brand-name { font-family:'Fraunces',serif; font-size:1.3rem; font-weight:700; color:#fff; text-decoration:none; }
        .brand-name em { font-style:normal; color:var(--mint); }
        .secure-label { color:rgba(255,255,255,0.45); font-size:0.82rem; display:flex; align-items:center; gap:0.4rem; }

        /* STEPPER */
        .stepper { display:flex; align-items:center; justify-content:center; padding:2rem 0 1.5rem; }
        .step { display:flex; flex-direction:column; align-items:center; }
        .step-circle { width:36px; height:36px; border-radius:50%; display:flex; align-items:center; justify-content:center; font-weight:700; font-size:0.82rem; background:var(--cream); color:var(--mist); border:2px solid var(--border); transition:all 0.3s; }
        .step.done .step-circle { background:var(--sage); color:#fff; border-color:var(--sage); }
        .step.active .step-circle { background:var(--forest); color:#fff; border-color:var(--forest); }
        .step-label { font-size:0.68rem; font-weight:600; color:var(--mist); margin-top:5px; text-transform:uppercase; letter-spacing:0.5px; }
        .step.active .step-label { color:var(--forest); }
        .step.done .step-label { color:var(--sage); }
        .step-line { width:80px; height:2px; background:var(--border); margin-bottom:22px; }
        .step-line.done { background:var(--sage); }

        /* CARDS */
        .sc { background:#fff; border:1.5px solid var(--border); border-radius:18px; padding:1.6rem; margin-bottom:1.2rem; }
        .sc-title { font-family:'Fraunces',serif; font-size:1.05rem; font-weight:700; color:var(--ink); margin-bottom:1.2rem; padding-bottom:0.8rem; border-bottom:1.5px solid var(--border); }

        /* FORM */
        .form-label { font-size:0.8rem; font-weight:600; color:var(--ink); margin-bottom:0.3rem; }
        .form-control { border:1.5px solid var(--border); border-radius:10px; padding:0.65rem 0.9rem; font-size:0.88rem; font-family:'Satoshi',sans-serif; transition:all 0.2s; outline:none; }
        .form-control:focus { border-color:var(--sage); box-shadow:0 0 0 3px rgba(58,148,96,0.1); }

        /* PAYMENT OPTIONS */
        .pay-option { border:1.5px solid var(--border); border-radius:14px; padding:0.9rem 1.1rem; cursor:pointer; transition:all 0.2s; display:flex; align-items:center; gap:0.9rem; margin-bottom:0.7rem; background:#fff; }
        .pay-option:hover { border-color:var(--mint); background:#f9fdf9; }
        .pay-option.selected { border-color:var(--sage); background:#f0faf4; }
        .pay-option input[type="radio"] { accent-color:var(--sage); width:16px; height:16px; flex-shrink:0; }
        .pay-icon { font-size:1.4rem; }
        .pay-label { font-weight:600; font-size:0.88rem; color:var(--ink); }
        .pay-sub { font-size:0.74rem; color:var(--mist); margin-top:1px; }

        /* SUMMARY */
        .sum-row { display:flex; justify-content:space-between; padding:0.4rem 0; font-size:0.86rem; color:var(--mist); }
        .sum-row.total { border-top:1.5px solid var(--border); margin-top:0.5rem; padding-top:0.9rem; font-size:1rem; font-weight:700; color:var(--ink); }
        .sum-row.total span:last-child { color:var(--sage); font-size:1.1rem; }

        .btn-place { width:100%; background:var(--forest); color:#fff; border:none; border-radius:14px; padding:0.9rem; font-weight:700; font-size:0.95rem; cursor:pointer; transition:all 0.25s; font-family:'Satoshi',sans-serif; }
        .btn-place:hover { background:var(--leaf); transform:translateY(-2px); box-shadow:0 8px 24px rgba(15,35,24,0.2); }
        .secure-note { text-align:center; font-size:0.74rem; color:var(--mist); margin-top:0.6rem; }

        /* SUCCESS */
        .success-overlay { display:none; }
        .success-card { background:#fff; border-radius:24px; border:1.5px solid var(--border); padding:3rem 2rem; text-align:center; }
        .success-circle { width:90px; height:90px; background:linear-gradient(135deg,var(--mint),var(--sage)); border-radius:50%; display:flex; align-items:center; justify-content:center; font-size:2.5rem; margin:0 auto 1.5rem; box-shadow:0 8px 30px rgba(93,190,130,0.35); animation:popIn 0.5s cubic-bezier(0.175,0.885,0.32,1.275) forwards; }
        @keyframes popIn { from{transform:scale(0);opacity:0} to{transform:scale(1);opacity:1} }
        .success-title { font-family:'Fraunces',serif; font-size:1.8rem; font-weight:900; color:var(--ink); margin-bottom:0.4rem; }
        .success-sub { color:var(--mist); font-size:0.9rem; margin-bottom:0.3rem; line-height:1.6; }
        .order-tag { display:inline-block; background:var(--cream); color:var(--sage); font-weight:700; font-size:0.85rem; padding:0.3rem 1rem; border-radius:50px; margin:0.8rem 0 1.8rem; border:1px solid var(--border); }
        .btn-home { background:var(--forest); color:#fff; border:none; border-radius:50px; padding:0.7rem 2rem; font-weight:700; font-size:0.9rem; text-decoration:none; display:inline-flex; align-items:center; gap:0.4rem; transition:all 0.2s; font-family:'Satoshi',sans-serif; margin:0.3rem; }
        .btn-home:hover { background:var(--leaf); color:#fff; }
        .btn-myorders { background:var(--cream); color:var(--ink); border:none; border-radius:50px; padding:0.7rem 2rem; font-weight:700; font-size:0.9rem; text-decoration:none; display:inline-flex; align-items:center; gap:0.4rem; transition:all 0.2s; font-family:'Satoshi',sans-serif; margin:0.3rem; }
        .btn-myorders:hover { background:var(--clay); color:var(--ink); }

        /* CONFETTI */
        .confetti-piece { position:fixed; border-radius:2px; animation:fall linear forwards; pointer-events:none; }
        @keyframes fall { 0%{transform:translateY(-20px) rotate(0deg);opacity:1} 100%{transform:translateY(100vh) rotate(720deg);opacity:0} }

        .footer-simple { background:var(--forest); color:rgba(255,255,255,0.35); text-align:center; padding:1.2rem; font-size:0.78rem; margin-top:3rem; }
        .footer-simple strong { color:var(--mint); }
        .fade-up { opacity:0; transform:translateY(16px); animation:fadeUp 0.4s forwards; }
        @keyframes fadeUp { to{opacity:1;transform:translateY(0)} }
    </style>
</head>
<body>

<nav class="nav-gc">
    <div class="nav-inner">
        <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="brand-name">Green<em>Cart</em></a>
        <div class="secure-label">
            <svg width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            Secure Checkout
        </div>
    </div>
</nav>

<!-- STEPPER -->
<div class="container" style="max-width:900px;">
    <div class="stepper" id="stepBar">
        <div class="step done"><div class="step-circle">✓</div><div class="step-label">Cart</div></div>
        <div class="step-line done"></div>
        <div class="step active" id="stp2"><div class="step-circle">2</div><div class="step-label">Details</div></div>
        <div class="step-line" id="line2"></div>
        <div class="step" id="stp3"><div class="step-circle">3</div><div class="step-label">Confirm</div></div>
    </div>
</div>

<!-- CHECKOUT SECTION -->
<div class="container pb-5" style="max-width:900px;" id="checkoutSection">
    <div class="row g-4">

        <!-- LEFT -->
        <div class="col-lg-7 fade-up">
            <div class="sc">
                <div class="sc-title">📦 Delivery Details</div>
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">First Name</label>
                        <input type="text" class="form-control" id="fName" value="<%= userName != null ? userName.split(" ")[0] : "" %>" placeholder="e.g. Raj">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Last Name</label>
                        <input type="text" class="form-control" id="lName" placeholder="e.g. Patel">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" id="phone" placeholder="+91 XXXXX XXXXX">
                    </div>
                    <div class="col-12">
                        <label class="form-label">Delivery Address</label>
                        <textarea class="form-control" rows="2" id="address" placeholder="House No., Street, Area"></textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">City</label>
                        <input type="text" class="form-control" id="city" placeholder="e.g. Ahmedabad">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">PIN Code</label>
                        <input type="text" class="form-control" id="pin" placeholder="e.g. 380001">
                    </div>
                </div>
            </div>

            <div class="sc">
                <div class="sc-title">💳 Payment Method</div>
                <div class="pay-option selected" onclick="selectPay(this,'Cash on Delivery')">
                    <input type="radio" name="pay" checked>
                    <span class="pay-icon">💵</span>
                    <div><div class="pay-label">Cash on Delivery</div><div class="pay-sub">Pay when your order arrives</div></div>
                </div>
                <div class="pay-option" onclick="selectPay(this,'UPI Payment')">
                    <input type="radio" name="pay">
                    <span class="pay-icon">📱</span>
                    <div><div class="pay-label">UPI Payment</div><div class="pay-sub">GPay, PhonePe, Paytm & more</div></div>
                </div>
                <div class="pay-option" onclick="selectPay(this,'Credit/Debit Card')">
                    <input type="radio" name="pay">
                    <span class="pay-icon">💳</span>
                    <div><div class="pay-label">Credit / Debit Card</div><div class="pay-sub">Visa, Mastercard, RuPay</div></div>
                </div>
            </div>
        </div>

        <!-- RIGHT -->
        <div class="col-lg-5 fade-up" style="animation-delay:100ms">
            <div class="sc">
                <div class="sc-title">🧾 Order Summary</div>
                <% if(cart != null) { for(Map.Entry<String,Integer> item : cart.entrySet()) { %>
                <div class="sum-row"><span><%= item.getKey() %> × <%= item.getValue() %></span></div>
                <% } } %>
                <div class="sum-row" style="margin-top:0.5rem"><span>Total Items</span><span><%= totalQty %> units</span></div>
                <div class="sum-row"><span>Delivery</span><span style="color:var(--mint);font-weight:700;">🎉 FREE</span></div>
                <div class="sum-row total"><span>Total</span><span>₹<%= String.format("%.2f", total) %></span></div>
            </div>
            <button class="btn-place" onclick="placeOrder()">✅ Place Order</button>
            <div class="secure-note">🔒 Your information is 100% secure</div>
        </div>
    </div>
</div>

<!-- SUCCESS -->
<div class="container pb-5" style="max-width:600px; display:none" id="successSection">
    <div class="success-card">
        <div class="success-circle">✓</div>
        <h2 class="success-title">Order Placed!</h2>
        <p class="success-sub">Thank you for shopping with <strong>GreenCart</strong> 🌿<br>Your fresh groceries are on their way!</p>
        <div class="order-tag" id="displayOrderId"></div>
        <div>
            <a href="<%=request.getContextPath()%>/views/user/home.jsp" class="btn-home">🌿 Back to Home</a>
            <a href="<%=request.getContextPath()%>/views/user/orders.jsp" class="btn-myorders">📦 My Orders</a>
        </div>
    </div>
</div>

<div class="footer-simple"><strong>GreenCart</strong> · Fresh produce, happy homes 🌿</div>

<form id="orderForm" action="<%=request.getContextPath()%>/placeOrder" method="post" style="display:none">
    <input type="hidden" name="firstName" id="h_fn">
    <input type="hidden" name="lastName" id="h_ln">
    <input type="hidden" name="phone" id="h_ph">
    <input type="hidden" name="address" id="h_ad">
    <input type="hidden" name="city" id="h_ci">
    <input type="hidden" name="pin" id="h_pi">
    <input type="hidden" name="paymentMethod" id="h_pm" value="Cash on Delivery">
</form>

<script>
    var selectedPay = 'Cash on Delivery';
    function selectPay(el, val) {
        document.querySelectorAll('.pay-option').forEach(o => o.classList.remove('selected'));
        el.classList.add('selected');
        el.querySelector('input[type="radio"]').checked = true;
        selectedPay = val;
    }
    function placeOrder() {
        var fn = document.getElementById('fName').value.trim();
        var ph = document.getElementById('phone').value.trim();
        var ad = document.getElementById('address').value.trim();
        var ci = document.getElementById('city').value.trim();
        var pi = document.getElementById('pin').value.trim();
        if (!fn || !ph || !ad || !ci || !pi) { alert('Please fill in all delivery details.'); return; }
        // Advance stepper
        document.getElementById('stp2').className = 'step done';
        document.getElementById('stp2').querySelector('.step-circle').textContent = '✓';
        document.getElementById('stp3').className = 'step active';
        document.getElementById('line2').className = 'step-line done';
        // Fill form
        document.getElementById('h_fn').value = fn;
        document.getElementById('h_ln').value = document.getElementById('lName').value.trim();
        document.getElementById('h_ph').value = ph;
        document.getElementById('h_ad').value = ad;
        document.getElementById('h_ci').value = ci;
        document.getElementById('h_pi').value = pi;
        document.getElementById('h_pm').value = selectedPay;
        // Show success
        document.getElementById('checkoutSection').style.display = 'none';
        document.getElementById('successSection').style.display = 'block';
        document.getElementById('displayOrderId').textContent = 'Order #GC-' + Date.now().toString().slice(-8);
        confetti();
        document.getElementById('orderForm').submit();
    }
    function confetti() {
        var colors = ['#5dbe82','#246b3a','#d4522a','#f0c070','#0f2318'];
        for (var i = 0; i < 55; i++) {
            (function(i) {
                setTimeout(function() {
                    var e = document.createElement('div');
                    e.className = 'confetti-piece';
                    e.style.left = Math.random()*100+'vw';
                    e.style.background = colors[Math.floor(Math.random()*colors.length)];
                    e.style.animationDuration = (Math.random()*2+1.5)+'s';
                    e.style.width = (Math.random()*8+5)+'px';
                    e.style.height = (Math.random()*8+5)+'px';
                    document.body.appendChild(e);
                    setTimeout(function(){ e.remove(); }, 4000);
                }, i*40);
            })(i);
        }
    }
</script>
<script>
    var TRACK_URL = '<%=request.getContextPath()%>/track';
</script>
<script src="<%=request.getContextPath()%>/js/tracking.js"></script>
</body>
</html>
