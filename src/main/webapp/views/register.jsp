<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – Green Cart</title>
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
        body {
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            background: var(--warm-white);
        }

        /* LEFT PANEL */
        .left-panel {
            width: 40%;
            background: linear-gradient(145deg, var(--green-dark) 0%, var(--green-mid) 60%, var(--green-light) 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 3rem;
            position: relative;
            overflow: hidden;
        }
        .left-panel::before { content:''; position:absolute; width:400px; height:400px; background:rgba(255,255,255,0.05); border-radius:50%; top:-100px; right:-100px; }
        .left-panel::after  { content:''; position:absolute; width:250px; height:250px; background:rgba(255,255,255,0.05); border-radius:50%; bottom:-60px; left:-60px; }
        .left-logo { font-size: 3rem; margin-bottom: 0.8rem; }
        .left-brand { font-family: 'Playfair Display', serif; font-size: 2.2rem; font-weight: 900; color: #fff; margin-bottom: 0.5rem; }
        .left-brand span { color: var(--green-light); }
        .left-tagline { color: rgba(255,255,255,0.7); font-size: 0.92rem; text-align: center; max-width: 240px; margin-bottom: 2rem; }
        .left-steps { list-style: none; padding: 0; width: 100%; max-width: 240px; }
        .left-steps li { color: rgba(255,255,255,0.85); font-size: 0.88rem; margin-bottom: 1rem; display: flex; align-items: flex-start; gap: 0.7rem; }
        .step-num { background: rgba(255,255,255,0.2); border-radius: 50%; width: 24px; height: 24px; display: flex; align-items: center; justify-content: center; font-size: 0.75rem; font-weight: 700; flex-shrink: 0; margin-top: 1px; }

        /* RIGHT PANEL */
        .right-panel { flex: 1; display: flex; align-items: center; justify-content: center; padding: 2rem; overflow-y: auto; }
        .form-box { width: 100%; max-width: 420px; padding: 1rem 0; }

        .form-title { font-family: 'Playfair Display', serif; font-size: 1.9rem; font-weight: 900; color: var(--green-dark); margin-bottom: 0.3rem; }
        .form-subtitle { color: var(--text-muted); font-size: 0.88rem; margin-bottom: 1.8rem; }

        .form-label { font-weight: 600; font-size: 0.83rem; color: var(--text-dark); margin-bottom: 0.3rem; }
        .form-control {
            border-radius: 10px;
            border: 1.5px solid #e0e0e0;
            padding: 0.65rem 1rem;
            font-size: 0.9rem;
            font-family: 'DM Sans', sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: #fff;
        }
        .form-control:focus { border-color: var(--green-mid); box-shadow: 0 0 0 3px rgba(45,106,79,0.1); outline: none; }
        .input-group-text { background: var(--cream); border: 1.5px solid #e0e0e0; border-right: none; border-radius: 10px 0 0 10px; color: var(--text-muted); }
        .input-group .form-control { border-left: none; border-radius: 0 10px 10px 0; }
        .input-group .form-control:focus { border-color: var(--green-mid); }

        /* ROLE CARDS */
        .role-options { display: flex; gap: 0.8rem; margin-top: 0.3rem; }
        .role-card {
            flex: 1;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            padding: 0.8rem;
            cursor: pointer;
            transition: all 0.2s;
            text-align: center;
            position: relative;
        }
        .role-card:hover { border-color: var(--green-light); background: #f9fdf9; }
        .role-card input[type="radio"] { position: absolute; opacity: 0; }
        .role-card.selected { border-color: var(--green-mid); background: #f0faf4; }
        .role-icon { font-size: 1.5rem; margin-bottom: 0.3rem; }
        .role-label { font-size: 0.82rem; font-weight: 600; color: var(--text-dark); }

        /* PASSWORD STRENGTH */
        .strength-bar { height: 4px; border-radius: 4px; background: #e0e0e0; margin-top: 6px; overflow: hidden; }
        .strength-fill { height: 100%; border-radius: 4px; width: 0%; transition: width 0.3s, background 0.3s; }
        .strength-text { font-size: 0.72rem; color: var(--text-muted); margin-top: 3px; }

        .btn-register {
            background: var(--green-mid);
            color: #fff;
            border: none;
            border-radius: 50px;
            width: 100%;
            padding: 0.8rem;
            font-weight: 700;
            font-size: 1rem;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 0.5rem;
        }
        .btn-register:hover { background: var(--green-dark); transform: translateY(-2px); box-shadow: 0 8px 24px rgba(45,106,79,0.3); }
        .btn-register:active { transform: scale(0.98); }

        .alert-custom { background: #fff3f0; border: 1.5px solid #ffc4b5; color: var(--accent); border-radius: 10px; padding: 0.7rem 1rem; font-size: 0.88rem; font-weight: 500; margin-bottom: 1.2rem; display: flex; align-items: center; gap: 0.5rem; }
        .footer-link { text-align: center; font-size: 0.88rem; color: var(--text-muted); margin-top: 1.2rem; }
        .footer-link a { color: var(--green-mid); font-weight: 600; text-decoration: none; }
        .footer-link a:hover { color: var(--green-dark); text-decoration: underline; }

        @media(max-width: 768px) {
            .left-panel { display: none; }
            .right-panel { padding: 1.5rem; }
        }
    </style>
</head>
<body>

<%-- LEFT PANEL --%>
<div class="left-panel">
    <div class="left-logo">🌿</div>
    <div class="left-brand">Green<span>Cart</span></div>
    <p class="left-tagline">Join thousands of happy customers enjoying fresh groceries.</p>
    <ul class="left-steps">
        <li>
            <span class="step-num">1</span>
            Create your free account in seconds
        </li>
        <li>
            <span class="step-num">2</span>
            Browse fresh organic products
        </li>
        <li>
            <span class="step-num">3</span>
            Get delivery straight to your door
        </li>
    </ul>
</div>

<%-- RIGHT PANEL --%>
<div class="right-panel">
    <div class="form-box">

        <h2 class="form-title">Create Account 🌱</h2>
        <p class="form-subtitle">Join Green Cart and start shopping fresh today</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert-custom">⚠️ <%= error %></div>
        <%
            }
        %>

        <form action="<%=request.getContextPath()%>/regForm" method="post">

            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <div class="input-group">
                    <span class="input-group-text">👤</span>
                    <input type="text" name="name" class="form-control"
                           placeholder="e.g. Raj Patel" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text">✉️</span>
                    <input type="email" name="email" class="form-control"
                           placeholder="you@example.com" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text">🔒</span>
                    <input type="password" name="password" id="password" class="form-control"
                           placeholder="Create a strong password" required
                           oninput="checkStrength(this.value)">
                </div>
                <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
                <div class="strength-text" id="strengthText"></div>
            </div>

            <div class="mb-3">
                <label class="form-label">Confirm Password</label>
                <div class="input-group">
                    <span class="input-group-text">🔒</span>
                    <input type="password" name="confpassword" id="confpassword" class="form-control"
                           placeholder="Repeat your password" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label">I am a:</label>
                <div class="role-options">
                    <div class="role-card selected" id="card-customer" onclick="selectRole(this, 'Customer')">
                        <input type="radio" name="role" value="Customer" id="role-customer" checked>
                        <div class="role-icon">🛒</div>
                        <div class="role-label">Customer</div>
                    </div>
                    <div class="role-card" id="card-admin" onclick="selectRole(this, 'Admin')">
                        <input type="radio" name="role" value="Admin" id="role-admin">
                        <div class="role-icon">⚙️</div>
                        <div class="role-label">Admin</div>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn-register">Create Account →</button>
        </form>

        <div class="footer-link">
            Already have an account?
            <a href="<%=request.getContextPath()%>/views/login.jsp">Login Here</a>
        </div>

    </div>
</div>

<script>
    function selectRole(card, role) {
        document.querySelectorAll('.role-card').forEach(c => c.classList.remove('selected'));
        card.classList.add('selected');
        card.querySelector('input[type="radio"]').checked = true;
    }

    function checkStrength(val) {
        var fill = document.getElementById('strengthFill');
        var text = document.getElementById('strengthText');
        var strength = 0;
        if (val.length >= 6)  strength++;
        if (val.length >= 10) strength++;
        if (/[A-Z]/.test(val)) strength++;
        if (/[0-9]/.test(val)) strength++;
        if (/[^A-Za-z0-9]/.test(val)) strength++;

        var labels = ['', 'Weak', 'Fair', 'Good', 'Strong', 'Very Strong'];
        var colors = ['', '#e76f51', '#f4a261', '#e9c46a', '#52b788', '#2d6a4f'];
        var widths = ['0%', '20%', '40%', '60%', '80%', '100%'];

        fill.style.width      = val.length === 0 ? '0%' : widths[strength];
        fill.style.background = colors[strength];
        text.textContent      = val.length === 0 ? '' : labels[strength];
        text.style.color      = colors[strength];
    }
</script>

</body>
</html>
