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

document.addEventListener('DOMContentLoaded', function() {
    var sortDirectionField = document.getElementById('sort_direction');
    var sortButton = document.getElementById('ascdesctoggle');
    var upIcon = document.getElementById('up-icon');
    var downIcon = document.getElementById('down-icon');

    var toggleState = sortDirectionField.value || 'desc';

    if (toggleState === 'desc') {
        upIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
        downIcon.style.fill = 'rgb(56, 94, 255)';
    } else {
        upIcon.style.fill = 'rgb(56, 94, 255)';
        downIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
    }

    sortButton.addEventListener('click', function(event) {
        event.preventDefault();

        toggleState = (toggleState === 'asc') ? 'desc' : 'asc';
        sortDirectionField.value = toggleState;

        if (toggleState === 'desc') {
            upIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
            downIcon.style.fill = 'rgb(56, 94, 255)';
        } else {
            upIcon.style.fill = 'rgb(56, 94, 255)';
            downIcon.style.fill = 'rgb(100, 100, 100, 0.4)';
        }

        document.getElementById('form').submit();
    });
});
