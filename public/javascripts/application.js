$(function() {
  $('.hint').hint();
  $('form.todo').submit(todo);
  $('a.todo').click(todo);
});

function todo() {
  alert('Not yet implemented!');
  return false;
};
