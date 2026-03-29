(function () {

    var TRACK_URL = var TRACK_URL = window.TRACK_URL || '/track';
    var pageStart = Date.now();

    function send(data) {
        fetch(TRACK_URL, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams(data)
        }).catch(err => console.log("Tracking error:", err));
    }

    // 🟢 Session Start
    send({
        action: 'session_start',
        pageUrl: window.location.pathname,
        deviceType: navigator.userAgent
    });

    // 📄 Page Visit
    send({
        action: 'event',
        eventType: 'page_visit',
        pageUrl: window.location.pathname,
        timeOnPage: 0
    });

    // ⏱️ Time Tracking
    window.addEventListener("beforeunload", function () {
        var timeSpent = Math.round((Date.now() - pageStart) / 1000);

        send({
            action: 'event',
            eventType: 'time_on_page',
            pageUrl: window.location.pathname,
            timeOnPage: timeSpent
        });

        send({
            action: 'session_end',
            timeOnPage: timeSpent
        });
    });

})();