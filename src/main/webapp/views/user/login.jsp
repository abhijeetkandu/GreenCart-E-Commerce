<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – Green Cart</title>
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
            width: 45%;
            background: linear-gradient(145deg, var(--green-dark) 0%, var(--green-mid) 60%, var(--green-light) 100%);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 3rem;
            position: relative;
            overflow: hidden;
        }
        .left-panel::before {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
            top: -100px; right: -100px;
        }
        .left-panel::after {
            content: '';
            position: absolute;
            width: 250px; height: 250px;
            background: rgba(255,255,255,0.05);
            border-radius: 50%;
            bottom: -60px; left: -60px;
        }
        .left-logo { font-size: 3.5rem; margin-bottom: 1rem; }
        .left-brand {
            font-family: 'Playfair Display', serif;
            font-size: 2.5rem;
            font-weight: 900;
            color: #fff;
            margin-bottom: 0.5rem;
        }
        .left-brand span { color: var(--green-light); }
        .left-tagline { color: rgba(255,255,255,0.7); font-size: 1rem; text-align: center; max-width: 260px; margin-bottom: 2.5rem; }
        .left-features { list-style: none; padding: 0; }
        .left-features li {
            color: rgba(255,255,255,0.85);
            font-size: 0.9rem;
            margin-bottom: 0.7rem;
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }
        .left-features li span { font-size: 1.1rem; }

        /* RIGHT PANEL */
        .right-panel {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        .form-box { width: 100%; max-width: 400px; }

        .form-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 900;
            color: var(--green-dark);
            margin-bottom: 0.3rem;
        }
        .form-subtitle { color: var(--text-muted); font-size: 0.9rem; margin-bottom: 2rem; }

        .form-label { font-weight: 600; font-size: 0.85rem; color: var(--text-dark); margin-bottom: 0.3rem; }
        .form-control {
            border-radius: 10px;
            border: 1.5px solid #e0e0e0;
            padding: 0.7rem 1rem;
            font-size: 0.9rem;
            font-family: 'DM Sans', sans-serif;
            transition: border-color 0.2s, box-shadow 0.2s;
            background: #fff;
        }
        .form-control:focus { border-color: var(--green-mid); box-shadow: 0 0 0 3px rgba(45,106,79,0.1); outline: none; }

        .input-group-text {
            background: var(--cream);
            border: 1.5px solid #e0e0e0;
            border-right: none;
            border-radius: 10px 0 0 10px;
            color: var(--text-muted);
        }
        .input-group .form-control { border-left: none; border-radius: 0 10px 10px 0; }
        .input-group .form-control:focus { border-color: var(--green-mid); }

        .btn-login {
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
        .btn-login:hover { background: var(--green-dark); transform: translateY(-2px); box-shadow: 0 8px 24px rgba(45,106,79,0.3); }
        .btn-login:active { transform: scale(0.98); }

        .divider { display: flex; align-items: center; gap: 1rem; margin: 1.5rem 0; }
        .divider hr { flex: 1; border-color: #e0e0e0; }
        .divider span { font-size: 0.78rem; color: var(--text-muted); white-space: nowrap; }

        .footer-link { text-align: center; font-size: 0.88rem; color: var(--text-muted); margin-top: 1.5rem; }
        .footer-link a { color: var(--green-mid); font-weight: 600; text-decoration: none; }
        .footer-link a:hover { color: var(--green-dark); text-decoration: underline; }

        .alert-custom {
            background: #fff3f0;
            border: 1.5px solid #ffc4b5;
            color: var(--accent);
            border-radius: 10px;
            padding: 0.7rem 1rem;
            font-size: 0.88rem;
            font-weight: 500;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* MOBILE */
        @media(max-width: 768px) {
            .left-panel { display: none; }
            .right-panel { padding: 2rem 1.5rem; }
        }
    </style>
</head>
<body>

<%-- LEFT PANEL --%>
<div class="left-panel">
    <div class="left-logo">🌿</div>
    <div class="left-brand">Green<span>Cart</span></div>
    <p class="left-tagline">Fresh groceries delivered straight from the farm to your door.</p>
    <ul class="left-features">
        <li><span>🥦</span> 100% Fresh & Organic</li>
        <li><span>🚚</span> Free Delivery on All Orders</li>
        <li><span>💰</span> Best Prices Guaranteed</li>
        <li><span>🔒</span> Safe & Secure Payments</li>
    </ul>
</div>

<%-- RIGHT PANEL --%>
<div class="right-panel">
    <div class="form-box">

        <h2 class="form-title">Welcome 👋</h2>
        <p class="form-subtitle">Login to your Green Cart account</p>

        <%
            String error = (String) request.getAttribute("error");
            if (error != null) {
        %>
        <div class="alert-custom">⚠️ <%= error %></div>
        <%
            }
        %>

        <form action="<%=request.getContextPath()%>/logForm" method="post">

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
                    <input type="password" name="password" class="form-control"
                           placeholder="Enter your password" required>
                </div>
            </div>

            <button type="submit" class="btn-login">Login →</button>
        </form>

        <div class="divider">
            <hr><span>New to Green Cart?</span><hr>
        </div>

        <div class="footer-link">
            Don't have an account?
            <a href="<%=request.getContextPath()%>/views/register.jsp">Register Here</a>
        </div>

    </div>
</div>

</body>
</html>
