$(function() {
  $('.hint').hint();
  $('textarea.elastic').elastic();
  $('form.todo').submit(todo);
  $('a.todo').click(todo);
  $("div.flash a").click(function() { $(this).parents('.flash').remove(); return false });
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
});

function todo() {
  alert('Not yet implemented!');
  return false;
};
