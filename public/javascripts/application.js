$(function() {
  $('.hint').hint();
  $('textarea.elastic').elastic();
  $('.clickable').fitted();
  $('a.toggle').click(function() {
    $($(this).attr('href')).toggle();
    if($(this).hasClass('more')) {
      $(this).text(($(this).text() == 'more') ? 'less' : 'more');
    } else {
      $(this).text(($(this).text() == 'show') ? 'hide' : 'show');
    }
    return false;
  });
  $('form.todo').submit(todo);
  $('a.todo').click(todo);
  $('<div id="loading">Please wait...</div>')
        .ajaxStart(function() {$(this).show();})
        .ajaxStop(function() {$(this).hide();})
        .appendTo('body').hide();

  $('.remove input:checkbox').change(function() {
    if($(this).is(':checked')) {
      $(this).parents('ol').addClass('removed');
    } else {
      $(this).parents('ol').removeClass('removed');
    }
  });
  $('body').delegate(".remove a", "click", function() {
    $(this).parents('ol').fadeOut('slow', function() { $(this).remove()});
    return false;
  });
});

function todo() {
  alert('Not yet implemented!');
  return false;
};
