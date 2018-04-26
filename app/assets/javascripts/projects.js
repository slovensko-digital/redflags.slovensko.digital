$(document).on('ready turbolinks:load', function () {
    $('#projects-index #phases-switcher .nav-link').on('click', function (e) {
        e.preventDefault();
        var targetPhaseId = $(this).data("targetPhaseId");
        $('.hideable[data-phase-id="' + targetPhaseId + '"]').removeClass('d-none');
        $('.hideable').not('[data-phase-id="' + targetPhaseId + '"]').addClass('d-none');
    });
});
