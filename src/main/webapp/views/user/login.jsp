<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — GreenCart</title>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,600;0,9..144,700;0,9..144,900;1,9..144,700&family=Satoshi:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --forest:#0f2318; --leaf:#246b3a; --sage:#3a9460; --mint:#5dbe82;
            --lime:#a8e6bf; --cream:#f8f4ed; --warm:#fdfaf6; --clay:#e8dfd0;
            --ember:#d4522a; --ink:#0c1a12; --mist:#7a9485; --border:#e2ddd6;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Satoshi',sans-serif; min-height:100vh; display:grid; grid-template-columns:1fr 1fr; overflow:hidden; }

        /* LEFT */
        .left { background:var(--forest); display:flex; flex-direction:column; justify-content:space-between; padding:3rem; position:relative; overflow:hidden; }
        .left::before { content:''; position:absolute; width:500px; height:500px; background:radial-gradient(circle,rgba(93,190,130,0.1),transparent 65%); top:-150px; right:-100px; pointer-events:none; }
        .left::after  { content:''; position:absolute; width:300px; height:300px; background:radial-gradient(circle,rgba(93,190,130,0.07),transparent 65%); bottom:-60px; left:-50px; pointer-events:none; }

        .left-brand { display:flex; align-items:center; gap:0.7rem; z-index:1; }
        .brand-leaf { width:38px; height:38px; background:linear-gradient(135deg,var(--mint),var(--sage)); border-radius:11px; display:flex; align-items:center; justify-content:center; font-size:1.1rem; }
        .brand-txt { font-family:'Fraunces',serif; font-size:1.3rem; font-weight:700; color:#fff; }
        .brand-txt em { font-style:normal; color:var(--mint); }

        .left-hero { z-index:1; }
        .left-hero h2 { font-family:'Fraunces',serif; font-size:2.8rem; font-weight:900; color:#fff; line-height:1.1; letter-spacing:-1px; margin-bottom:1rem; }
        .left-hero h2 em { font-style:italic; color:var(--mint); }
        .left-hero p { color:rgba(255,255,255,0.45); font-size:0.9rem; line-height:1.7; max-width:300px; }

        .left-features { z-index:1; display:flex; flex-direction:column; gap:0.7rem; }
        .feat-item { display:flex; align-items:center; gap:0.7rem; }
        .feat-dot { width:6px; height:6px; border-radius:50%; background:var(--mint); flex-shrink:0; }
        .feat-txt { color:rgba(255,255,255,0.6); font-size:0.84rem; }

        /* RIGHT */
        .right { background:var(--cream); display:flex; align-items:center; justify-content:center; padding:3rem 2.5rem; }
        .form-box { width:100%; max-width:380px; animation:slideIn 0.45s cubic-bezier(0.16,1,0.3,1) forwards; }
        @keyframes slideIn { from{opacity:0;transform:translateX(20px)} to{opacity:1;transform:translateX(0)} }

        .form-eyebrow { display:inline-flex; align-items:center; gap:0.4rem; background:#fff; color:var(--sage); font-size:0.7rem; font-weight:700; letter-spacing:1.5px; text-transform:uppercase; padding:0.3rem 0.8rem; border-radius:50px; border:1px solid var(--border); margin-bottom:1.5rem; }
        .form-title { font-family:'Fraunces',serif; font-size:2rem; font-weight:900; color:var(--ink); letter-spacing:-0.5px; margin-bottom:0.3rem; }
        .form-sub { color:var(--mist); font-size:0.88rem; margin-bottom:2rem; }

        .alert-err { background:#fff0ed; border:1px solid #ffc4b0; color:var(--ember); border-radius:10px; padding:0.7rem 1rem; font-size:0.83rem; font-weight:500; margin-bottom:1.3rem; display:flex; align-items:center; gap:0.5rem; }

        .field-group { margin-bottom:1.2rem; }
        .field-label { display:block; font-size:0.78rem; font-weight:600; color:var(--ink); margin-bottom:0.35rem; }
        .field-wrap { position:relative; }
        .field-icon { position:absolute; left:13px; top:50%; transform:translateY(-50%); pointer-events:none; color:var(--mist); }
        .field-input { width:100%; background:#fff; border:1.5px solid var(--border); border-radius:12px; padding:0.75rem 1rem 0.75rem 2.6rem; font-size:0.9rem; font-family:'Satoshi',sans-serif; color:var(--ink); outline:none; transition:all 0.2s; }
        .field-input:focus { border-color:var(--sage); box-shadow:0 0 0 3px rgba(58,148,96,0.1); }
        .field-input::placeholder { color:#bbb5a8; }

        .btn-submit { width:100%; background:var(--forest); color:#fff; border:none; border-radius:12px; padding:0.85rem; font-size:0.92rem; font-weight:700; font-family:'Satoshi',sans-serif; cursor:pointer; transition:all 0.25s; margin-top:0.5rem; display:flex; align-items:center; justify-content:center; gap:0.5rem; }
        .btn-submit:hover { background:var(--leaf); transform:translateY(-2px); box-shadow:0 10px 28px rgba(15,35,24,0.25); }
        .btn-submit .arr { transition:transform 0.2s; }
        .btn-submit:hover .arr { transform:translateX(4px); }

        .divider { display:flex; align-items:center; gap:0.8rem; margin:1.5rem 0 1.2rem; }
        .divider hr { flex:1; border:none; border-top:1.5px solid var(--border); }
        .divider span { font-size:0.72rem; color:var(--mist); }

        .alt-link { text-align:center; font-size:0.84rem; color:var(--mist); }
        .alt-link a { color:var(--sage); font-weight:700; text-decoration:none; transition:color 0.2s; }
        .alt-link a:hover { color:var(--leaf); }

        @media(max-width:768px) { body{grid-template-columns:1fr;} .left{display:none;} .right{padding:2rem 1.5rem;} }
    </style>
</head>
<body>

<div class="left">
    <div class="left-brand">
        <div class="brand-leaf">🌿</div>
        <div class="brand-txt">Green<em>Cart</em></div>
    </div>
    <div class="left-hero">
        <h2>Good food,<br><em>delivered.</em></h2>
        <p>Fresh organic groceries from local farms, straight to your doorstep every day.</p>
    </div>
    <div class="left-features">
        <div class="feat-item"><div class="feat-dot"></div><span class="feat-txt">100% Fresh & Organic produce</span></div>
        <div class="feat-item"><div class="feat-dot"></div><span class="feat-txt">Free delivery on every order</span></div>
        <div class="feat-item"><div class="feat-dot"></div><span class="feat-txt">Farm to doorstep guarantee</span></div>
        <div class="feat-item"><div class="feat-dot"></div><span class="feat-txt">Secure & encrypted checkout</span></div>
    </div>
</div>

<div class="right">
    <div class="form-box">
        <div class="form-eyebrow">Welcome back</div>
        <h1 class="form-title">Sign in</h1>
        <p class="form-sub">Enter your credentials to continue</p>

        <%
            String error = (String) request.getAttribute("error");
            if(error != null) {
        %>
        <div class="alert-err">
            <svg width="15" height="15" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/></svg>
            <%= error %>
        </div>
        <% } %>

        <form action="<%=request.getContextPath()%>/logForm" method="post">
            <div class="field-group">
                <label class="field-label">Email Address</label>
                <div class="field-wrap">
                    <svg class="field-icon" width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                    <input type="email" name="email" class="field-input" placeholder="you@example.com" required autocomplete="email">
                </div>
            </div>
            <div class="field-group">
                <label class="field-label">Password</label>
                <div class="field-wrap">
                    <svg class="field-icon" width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                    <input type="password" name="password" class="field-input" placeholder="••••••••" required autocomplete="current-password">
                </div>
            </div>
            <button type="submit" class="btn-submit">
                Sign in
                <svg class="arr" width="16" height="16" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6"/></svg>
            </button>
        </form>

        <div class="divider"><hr><span>New to GreenCart?</span><hr></div>
        <div class="alt-link">Don't have an account? <a href="<%=request.getContextPath()%>/views/user/register.jsp">Create one free</a></div>
    </div>
</div>
<meta name="contextPath" content="<%=request.getContextPath()%>">
<script src="<%=request.getContextPath()%>/js/tracking.js"></script>
</body>
</html>
