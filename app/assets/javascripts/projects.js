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

document.addEventListener('turbolinks:load', function () {
    var sortDirectionField = document.getElementById('sort_direction');
    var sortButton = document.getElementById('ascdesctoggle');
    var upIcon = document.getElementById('up-icon');
    var downIcon = document.getElementById('down-icon');

    if (sortDirectionField && sortButton && upIcon && downIcon) {
        var toggleState = sortDirectionField.value || 'desc';
      
        function updateIcons() {
            if (toggleState === 'desc') {
                upIcon.style.fill = 'rgba(100, 100, 100, 0.4)';
                downIcon.style.fill = 'rgb(56, 94, 255)';
            } else {
                upIcon.style.fill = 'rgb(56, 94, 255)';
                downIcon.style.fill = 'rgba(100, 100, 100, 0.4)';
            }
        }

        updateIcons();

        sortButton.addEventListener('click', function (event) {
            event.preventDefault();

            toggleState = (toggleState === 'desc') ? 'asc' : 'desc';
            sortDirectionField.value = toggleState;

            updateIcons();

            document.getElementById('form').submit();
        });
    }
});