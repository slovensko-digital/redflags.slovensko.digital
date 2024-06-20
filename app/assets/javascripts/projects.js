$(document).on('ready turbolinks:load', function () {
    $('[data-toggle="tooltip"]').tooltip();
    $('.tag-tooltip').tooltip();
});

$(document).ready(function(){
    $('[data-toggle="collapse"]').on('click', function() {
        $(this).find('.collapsed,.expanded').toggleClass('d-none');
    });
});

document.addEventListener("turbolinks:load", function() {
    document.addEventListener("turbolinks:load", function() {
        if (!window.printCalled && window.location.pathname.endsWith("/pdf")) {
            window.printCalled = true;
            window.print();
        }
    });

    document.addEventListener("turbolinks:before-render", function() {
        window.printCalled = false;
    });
});
