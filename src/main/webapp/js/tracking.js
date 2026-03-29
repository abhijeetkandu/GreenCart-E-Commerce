// ── Green Cart User Behaviour Tracker ──────────────────────────────
// Uses form data (NOT JSON) to match TrackingServlet

(function () {

    var pageStart    = Date.now();
    var sessionStart = Date.now();

    // ── Get context path from meta tag ─────────────────────────────
    var CONTEXT_PATH = document.querySelector('meta[name="contextPath"]')
        ? document.querySelector('meta[name="contextPath"]').getAttribute('content')
        : '';
    var TRACK_URL = CONTEXT_PATH + '/track';

    // ── Detect device type ──────────────────────────────────────────
    function getDeviceType() {
        var ua = navigator.userAgent.toLowerCase();
        if (/tablet|ipad/.test(ua)) return 'Tablet';
        if (/mobile|android|iphone/.test(ua)) return 'Mobile';
        return 'Desktop';
    }

    // ── Send as form data (matches servlet getParameter) ───────────
    function send(params) {
        var formData = new FormData();
        for (var key in params) {
            formData.append(key, params[key]);
        }
        try {
            if (navigator.sendBeacon) {
                navigator.sendBeacon(TRACK_URL, formData);
            } else {
                fetch(TRACK_URL, { method: 'POST', body: formData });
            }
        } catch (e) {}
    }

    // ── 1. Session Start ────────────────────────────────────────────
    send({
        action:     'session_start',
        deviceType: getDeviceType(),
        pageUrl:    window.location.pathname
    });

    // ── 2. Page Visit Event ─────────────────────────────────────────
    send({
        action:    'event',
        eventType: 'page_visit',
        eventData: document.title,
        pageUrl:   window.location.pathname,
        timeOnPage: '0'
    });

    // ── 3. Time on Page + Session End (on leave) ────────────────────
    window.addEventListener('beforeunload', function () {
        var timeOnPage = Math.round((Date.now() - pageStart) / 1000);
        var totalTime  = Math.round((Date.now() - sessionStart) / 1000);

        send({
            action:    'event',
            eventType: 'time_on_page',
            eventData: document.title,
            pageUrl:   window.location.pathname,
            timeOnPage: String(timeOnPage)
        });

        send({
            action:    'session_end',
            timeOnPage: String(totalTime),
            pageUrl:   window.location.pathname
        });
    });

    // ── 4. Product Click Tracking ───────────────────────────────────
    document.addEventListener('click', function (e) {
        var card = e.target.closest('.product-card');
        if (card) {
            var nameEl = card.querySelector('.product-name');
            if (nameEl) {
                send({
                    action:    'event',
                    eventType: 'product_click',
                    eventData: nameEl.textContent.trim(),
                    pageUrl:   window.location.pathname,
                    timeOnPage: String(Math.round((Date.now() - pageStart) / 1000))
                });
            }
        }
    });

    // ── 5. Cart Event (called from updateCart in home.jsp) ──────────
    window.trackCartEvent = function (action, productName) {
        send({
            action:    'event',
            eventType: action === 'increase' ? 'add_to_cart' : 'remove_from_cart',
            eventData: productName,
            pageUrl:   window.location.pathname,
            timeOnPage: String(Math.round((Date.now() - pageStart) / 1000))
        });
    };

    // ── 6. Order Placed (called from checkout.jsp) ──────────────────
    window.trackOrderPlaced = function (orderId, total) {
        send({
            action:    'event',
            eventType: 'order_placed',
            eventData: 'Order:' + orderId + '|Total:' + total,
            pageUrl:   window.location.pathname,
            timeOnPage: String(Math.round((Date.now() - pageStart) / 1000))
        });
    };

})();