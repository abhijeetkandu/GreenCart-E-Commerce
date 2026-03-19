<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login – Green Cart</title>
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
            align-items: center;
            justify-content: center;
            background: var(--green-dark);
            position: relative;
            overflow: hidden;
        }

        /* BACKGROUND BLOBS */
        body::before {
            content: '';
            position: absolute;
            width: 600px; height: 600px;
            background: radial-gradient(circle, rgba(82,183,136,0.15), transparent 70%);
            top: -150px; right: -150px;
            border-radius: 50%;
        }
        body::after {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(82,183,136,0.1), transparent 70%);
            bottom: -100px; left: -100px;
            border-radius: 50%;
        }

        /* CARD */
        .login-card {
            background: #fff;
            border-radius: 24px;
            width: 100%;
            max-width: 420px;
            padding: 2.8rem 2.5rem;
            box-shadow: 0 30px 80px rgba(0,0,0,0.4);
            position: relative;
            z-index: 1;
            animation: cardUp 0.5s cubic-bezier(0.175,0.885,0.32,1.275) forwards;
        }
        @keyframes cardUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* TOP BADGE */
        .admin-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            background: var(--green-dark);
            color: #fff;
            border-radius: 50px;
            padding: 0.4rem 1.2rem;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
            width: fit-content;
            margin: 0 auto 1.5rem;
        }
        .admin-badge span { font-size: 1rem; }

        .card-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.9rem;
            font-weight: 900;
            color: var(--green-dark);
            text-align: center;
            margin-bottom: 0.3rem;
        }
        .card-subtitle {
            text-align: center;
            color: var(--text-muted);
            font-size: 0.88rem;
            margin-bottom: 2rem;
        }

        /* FORM */
        .form-label {
            font-weight: 600;
            font-size: 0.83rem;
            color: var(--text-dark);
            margin-bottom: 0.3rem;
            display: block;
        }
        .input-wrap {
            position: relative;
            margin-bottom: 1.2rem;
        }
        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1rem;
            pointer-events: none;
        }
        .form-input {
            width: 100%;
            border: 1.5px solid #e0e0e0;
            border-radius: 12px;
            padding: 0.75rem 1rem 0.75rem 2.8rem;
            font-size: 0.9rem;
            font-family: 'DM Sans', sans-serif;
            color: var(--text-dark);
            background: var(--warm-white);
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        .form-input:focus {
            border-color: var(--green-mid);
            box-shadow: 0 0 0 3px rgba(45,106,79,0.12);
            background: #fff;
        }

        /* ERROR */
        .alert-error {
            background: #fff3f0;
            border: 1.5px solid #ffc4b5;
            color: var(--accent);
            border-radius: 10px;
            padding: 0.7rem 1rem;
            font-size: 0.85rem;
            font-weight: 500;
            margin-bottom: 1.2rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* BUTTON */
        .btn-login {
            width: 100%;
            background: var(--green-dark);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 0.85rem;
            font-size: 1rem;
            font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 0.5rem;
            letter-spacing: 0.3px;
        }
        .btn-login:hover {
            background: var(--green-mid);
            transform: translateY(-2px);
            box-shadow: 0 10px 28px rgba(26,60,43,0.4);
        }
        .btn-login:active { transform: scale(0.98); }

        /* DIVIDER */
        .divider {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            margin: 1.5rem 0 1rem;
        }
        .divider hr { flex: 1; border: none; border-top: 1.5px solid #efefef; }
        .divider span { font-size: 0.75rem; color: var(--text-muted); white-space: nowrap; }

        /* FOOTER LINK */
        .back-link {
            text-align: center;
            font-size: 0.85rem;
            color: var(--text-muted);
        }
        .back-link a {
            color: var(--green-mid);
            font-weight: 600;
            text-decoration: none;
        }
        .back-link a:hover { color: var(--green-dark); text-decoration: underline; }

        /* LOCK ICON TOP */
        .lock-circle {
            width: 56px; height: 56px;
            background: linear-gradient(135deg, var(--green-dark), var(--green-mid));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin: 0 auto 1.2rem;
            box-shadow: 0 6px 20px rgba(26,60,43,0.3);
        }
    </style>
</head>
<body>

<div class="login-card">

    <div class="lock-circle">🔐</div>

    <div class="admin-badge"><span>⚙️</span> Admin Panel</div>

    <h2 class="card-title">Welcome Back</h2>
    <p class="card-subtitle">Sign in to manage your Green Cart store</p>

    <% if (error != null) { %>
    <div class="alert-error">⚠️ <%= error %></div>
    <% } %>

    <form action="<%=request.getContextPath()%>/adminLogin" method="post">

        <div>
            <label class="form-label">Username</label>
            <div class="input-wrap">
                <span class="input-icon">👤</span>
                <input type="text" name="adminName" class="form-input"
                       placeholder="Enter admin username" required>
            </div>
        </div>

        <div>
            <label class="form-label">Password</label>
            <div class="input-wrap">
                <span class="input-icon">🔒</span>
                <input type="password" name="adminPass" class="form-input"
                       placeholder="Enter admin password" required>
            </div>
        </div>

        <button type="submit" class="btn-login">Login to Dashboard →</button>
    </form>

    <div class="divider">
        <hr><span>Not an admin?</span><hr>
    </div>

    <div class="back-link">
        <a href="<%=request.getContextPath()%>/views/home.jsp">← Back to Green Cart</a>
    </div>

</div>

</body>
</html>
