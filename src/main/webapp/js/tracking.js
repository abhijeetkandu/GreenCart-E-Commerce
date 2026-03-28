(function () {

    // 🔗 Your admin tracking API
    var TRACK_URL = 'https://greencart-admin-2fc6.onrender.com/track';

    var sessionStart = Date.now();
    var pageStart = Date.now();

    // 🆔 Persistent session ID (VERY IMPORTANT FIX)
    var sessionId = localStorage.getItem("gc_session_id");
    if (!sessionId) {
        sessionId = "sess_" + Math.random().toString(36).substring(2) + Date.now();
        localStorage.setItem("gc_session_id", sessionId);
    }

    // 📱 Device detection
    function getDeviceType() {
        var ua = navigator.userAgent;
        if (/Mobi|Android|iPhone|iPad/i.test(ua)) return 'Mobile';
        if (/Tablet/i.test(ua)) return 'Tablet';
        return 'Desktop';
    }

    // 🚀 Send data (FIXED: removed sendBeacon, added credentials)
    function send(params) {
        params.sessionId = sessionId; // attach sessionId

        var form = new FormData();
        for (var key in params) {
            form.append(key, params[key]);
        }

        fetch(TRACK_URL, {
            method: 'POST',
            body: form,
            credentials: 'include' // IMPORTANT
        }).catch(function (err) {
            console.error("Tracking failed:", err);
        });
    }

    // 🟢 SESSION START
    send({
        action: 'session_start',
        deviceType: getDeviceType(),
        pageUrl: window.location.pathname
    });

    // 📄 PAGE VISIT
    send({
        action: 'event',
        eventType: 'page_visit',
        eventData: document.title,
        pageUrl: window.location.pathname,
        timeOnPage: 0
    });

    // ⏱️ TIME TRACKING (BETTER than beforeunload)
    function sendTimeData() {
        var timeOnPage = Math.round((Date.now() - pageStart) / 1000);
        var totalTime = Math.round((Date.now() - sessionStart) / 1000);

        send({
            action: 'event',
            eventType: 'time_on_page',
            eventData: document.title,
            pageUrl: window.location.pathname,
            timeOnPage: timeOnPage
        });

        send({
            action: 'session_end',
            timeOnPage: totalTime,
            pageUrl: window.location.pathname
        });
    }

    // 🔥 Reliable tracking (works on mobile too)
    document.addEventListener("visibilitychange", function () {
        if (document.visibilityState === "hidden") {
            sendTimeData();
        }
    });

    window.addEventListener("beforeunload", sendTimeData);

    // 🛍️ PRODUCT CLICK
    document.addEventListener('click', function (e) {
        var card = e.target.closest('.product-card');
        if (card) {
            var name = card.querySelector('.product-name');
            if (name) {
                send({
                    action: 'event',
                    eventType: 'product_click',
                    eventData: name.textContent.trim(),
                    pageUrl: window.location.pathname,
                    timeOnPage: Math.round((Date.now() - pageStart) / 1000)
                });
            }
        }
    });

    // 🛒 CART EVENTS
    window.trackCartEvent = function (action, productName) {
        send({
            action: 'event',
            eventType: action === 'increase' ? 'add_to_cart' : 'remove_from_cart',
            eventData: productName,
            pageUrl: window.location.pathname,
            timeOnPage: Math.round((Date.now() - pageStart) / 1000)
        });
    };

    // 📦 ORDER PLACED
    window.trackOrderPlaced = function (orderId, total) {
        send({
            action: 'event',
            eventType: 'order_placed',
            eventData: 'Order: ' + orderId + ' | ₹' + total,
            pageUrl: window.location.pathname,
            timeOnPage: Math.round((Date.now() - pageStart) / 1000)
        });
    };

})();