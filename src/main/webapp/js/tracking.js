// tracking.js
function getDeviceType() {
    var ua = navigator.userAgent.toLowerCase();
    if (/mobile|android|iphone|ipad/.test(ua)) return "Mobile";
    return "Desktop";
}

// Call this on page load
function trackSession() {
    fetch("/track", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            action: "session_start",
            deviceType: getDeviceType(),
            pageUrl: window.location.pathname
        })
    }).then(res => console.log("Session tracked", res.status))
      .catch(err => console.error("Tracking error", err));
}

// Track product click
function trackProductClick(productName) {
    fetch("/track", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            action: "product_click",
            productName: productName,
            pageUrl: window.location.pathname
        })
    });
}

// Track order completion
function trackOrderCompletion(orderId) {
    fetch("/track", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            action: "order_completed",
            orderId: orderId,
            pageUrl: window.location.pathname
        })
    });
}

window.onload = trackSession;