$(document).ready(function () {
    $('#newsletter-form').submit(function (evt) {
        var form = $(evt.target);
        var data = form.serialize();
        var button = form.find('button')[0];
        button.innerHTML = 'Prihlasujem...';

        $.ajax({
                type: 'POST',
                url: form.data('action'),
                data: data,
                dataType: 'json',
                success: function (data) {
                    if (data.result !== undefined && data.result.result === 'success') {
                        form.remove();
                        $('#newsletter-success').removeClass('d-none');
                    }
                },
                complete: function () {
                    button.innerHTML = 'Prihlásiť'
                }
            }
        );
        evt.preventDefault();
    });
});