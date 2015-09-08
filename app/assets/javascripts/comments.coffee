# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.create-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    commentable_id = $(this).data('commentableId')
    $('form#create-comment-' + commentable_id).show()