// ── Green Cart User Behaviour Tracker ──────────────────────────────
(function () {

    var pageStart = Date.now();

    // Get context path from meta tag in <head>
    var metaTag = document.querySelector('meta[name="contextPath"]');
    var CONTEXT_PATH = metaTag ? metaTag.getAttribute('content') : '';
    var TRACK_URL = CONTEXT_PATH + '/track';

    // Detect device type
    function getDeviceType() {
        var ua = navigator.userAgent.toLowerCase();
        if (/tablet|ipad/.test(ua)) return 'Tablet';
        if (/mobile|android|iphone/.test(ua)) return 'Mobile';
        return 'Desktop';
    }

    // Send as FormData — matches req.getParameter() in servlet
    function send(params) {
        var fd = new FormData();
        for (var k in params) fd.append(k, params[k]);
        try {
            fetch(TRACK_URL, { method: 'POST', body: fd });
        } catch (e) {}
    }

    // 1. Session Start
    send({
        action:     'session_start',
        deviceType: getDeviceType(),
        pageUrl:    window.location.pathname
    });

    // 2. Page Visit Event
    send({
        action:     'event',
        eventType:  'page_visit',
        eventData:  document.title,
        pageUrl:    window.location.pathname,
        timeOnPage: '0'
    });

    // 3. Time on page + session end on leave
    window.addEventListener('beforeunload', function () {
        var time = Math.round((Date.now() - pageStart) / 1000);
        send({
            action:     'event',
            eventType:  'time_on_page',
            eventData:  document.title,
            pageUrl:    window.location.pathname,
            timeOnPage: String(time)
        });
        send({
            action:     'session_end',
            timeOnPage: String(time),
            pageUrl:    window.location.pathname
        });
    });

    // 4. Product Click — works with .product-name inside .product-card
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

    // 5. Cart event — called from updateCart() in home.jsp
    window.trackCartEvent = function (action, productName) {
        send({
            action:     'event',
            eventType:  action === 'increase' ? 'add_to_cart' : 'remove_from_cart',
            eventData:  productName,
            pageUrl:    window.location.pathname,
            timeOnPage: String(Math.round((Date.now() - pageStart) / 1000))
        });
    };

    // 6. Order placed — call this from checkout.jsp after order success
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