$(document).on('ready turbolinks:load', function () {
  $('#newsletter-form').submit(function (evt) {
    var form = $(evt.target);
    var data = form.serialize();
    var button = form.find('button')[0];
    button.innerHTML = 'Prihlasujem...';

    $.ajax({
      type: 'POST',
      url: form.data('action'),
      data: data,
      success: function () {
        form.remove();
        $('#newsletter-success').removeClass('d-none');
      },
      complete: function () {
        button.innerHTML = 'Prihlásiť'
      }
    });
    evt.preventDefault();
  });
});
