$(document).on('ready turbolinks:load', function () {
    $('[data-toggle="tooltip"]').tooltip();
    $('.tag-tooltip').tooltip();
});

document.addEventListener("turbolinks:load", function() {
    if (!window.printCalled && window.location.pathname.endsWith("/pdf")) {
        window.printCalled = true;
        window.print();
    }
});

document.addEventListener("turbolinks:before-render", function() {
    window.printCalled = false;
});
