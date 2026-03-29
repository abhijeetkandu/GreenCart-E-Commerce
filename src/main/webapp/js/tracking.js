function getDeviceType() {
    var ua = navigator.userAgent.toLowerCase();

    if (/tablet|ipad/.test(ua)) return "Tablet";
    if (/mobile|android|iphone/.test(ua)) return "Mobile";
    return "Desktop";
}

// SESSION + PAGE VIEW
function trackSession() {
    fetch("/track", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({
            action: "session_start",
            deviceType: getDeviceType(),
            pageUrl: window.location.pathname
        })
    });
}

// PRODUCT CLICK
function trackProductClick(productName) {
    fetch("/track", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({
            action: "product_click",
            productName: productName,
            pageUrl: window.location.pathname
        })
    });
}

// ADD TO CART
function trackAddToCart(productName) {
    fetch("/track", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({
            action: "add_to_cart",
            productName: productName,
            pageUrl: window.location.pathname
        })
    });
}

// ORDER COMPLETE
function trackOrderCompletion(orderId) {
    fetch("/track", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({
            action: "order_completed",
            orderId: orderId,
            pageUrl: window.location.pathname
        })
    });
}

// TIME TRACK
let startTime = Date.now();

window.addEventListener("beforeunload", function () {
    let timeSpent = Math.floor((Date.now() - startTime) / 1000);

    navigator.sendBeacon("/track", JSON.stringify({
        action: "time_spent",
        time: timeSpent,
        pageUrl: window.location.pathname
    }));
});

window.onload = trackSession;