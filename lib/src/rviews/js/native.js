(function () {

    'use strict';
    const bootstrap = document.createElement('script');

    bootstrap.setAttribute("src", "https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js",)

    bootstrap.setAttribute("integrity", "sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL")

    bootstrap.setAttribute("crossorigin", "anonymous")
    document.body.appendChild(bootstrap)
    console.log("test");
})();
