// ── GreenCart Tracker ─────────────────────────────────────────────
// Location: webapp/js/tracking.js (USER project only)
// NO meta tags needed — works out of the box on any JSP page

(function () {
    var TRACK_URL  = '/track'; // TrackingServlet is on user site
    var pageStart  = Date.now();
    var sessionKey = 'gc_session_sent';

    // ── Device detection ───────────────────────────────────────────
    function getDevice() {
        var ua = navigator.userAgent;
        if (/iPad|Tablet/i.test(ua))         return 'Tablet';
        if (/Mobi|Android|iPhone/i.test(ua)) return 'Mobile';
        return 'Desktop';
    }

    // ── Send POST to TrackingServlet ───────────────────────────────
    function send(params) {
        try {
            var fd = new FormData();
            for (var k in params) {
                if (params[k] !== null && params[k] !== undefined) {
                    fd.append(k, String(params[k]));
                }
            }
            fetch(TRACK_URL, { method: 'POST', body: fd })
                .catch(function(e) {
                    console.warn('[GCTrack] send failed:', e);
                });
        } catch(e) {
            console.warn('[GCTrack] error:', e);
        }
    }

    // ── 1. Session Start ───────────────────────────────────────────
    // sessionStorage fires once per tab — not on every page reload
    if (!sessionStorage.getItem(sessionKey)) {
        sessionStorage.setItem(sessionKey, '1');
        send({
            action:     'session_start',
            deviceType: getDevice(),
            pageUrl:    window.location.pathname
        });
    }

    // ── 2. Page Visit ──────────────────────────────────────────────
    send({
        action:     'event',
        eventType:  'page_visit',
        eventData:  document.title || window.location.pathname,
        pageUrl:    window.location.pathname,
        timeOnPage: '0'
    });

    // ── 3. Time on page + session end on leave ─────────────────────
    window.addEventListener('beforeunload', function () {
        var secs = Math.round((Date.now() - pageStart) / 1000);
        send({
            action:     'event',
            eventType:  'time_on_page',
            eventData:  document.title || window.location.pathname,
            pageUrl:    window.location.pathname,
            timeOnPage: String(secs)
        });
        send({
            action:     'session_end',
            timeOnPage: String(secs),
            pageUrl:    window.location.pathname
        });
    });

    // ── 4. Product card click ──────────────────────────────────────
    document.addEventListener('click', function (e) {
        var card = e.target.closest('.product-card');
        if (card) {
            var nameEl = card.querySelector('.product-name');
            if (nameEl) {
                send({
                    action:     'event',
                    eventType:  'product_click',
                    eventData:  nameEl.textContent.trim(),
                    pageUrl:    window.location.pathname,
                    timeOnPage: String(Math.round((Date.now() - pageStart) / 1000))
                });
            }
        }
    });

    // ── 5. Add to Cart / Remove ────────────────────────────────────
    // Called from updateCart() in home.jsp after AJAX success
    window.trackCartEvent = function (action, productName) {
        send({
            action:     'event',
            eventType:  action === 'increase' ? 'add_to_cart' : 'remove_from_cart',
            eventData:  productName,
            pageUrl:    window.location.pathname,
            timeOnPage: String(Math.round((Date.now() - pageStart) / 1000))
        });
    };

    // ── 6. Order placed ────────────────────────────────────────────
    // Call window.trackOrderPlaced(orderId) from order success page
    window.trackOrderPlaced = function (orderId) {
        send({
            action:     'event',
            eventType:  'order_placed',
            eventData:  String(orderId),
            pageUrl:    window.location.pathname,
            timeOnPage: String(Math.round((Date.now() - pageStart) / 1000))
        });
    };

})();