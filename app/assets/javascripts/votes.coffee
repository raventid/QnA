# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.good-question-link, .bad-question-link').bind 'ajax:success', (e, data, status, xhr) ->

    div_vote = '.' + 'vote-' + data.vote.votable_type.toLowerCase() + '-' + data.vote.votable_id

    $(div_vote + " div.rating").html(data.rating)
    $(div_vote + " .good-question-link").hide()
    $(div_vote + " .bad-question-link").hide()

  .bind 'ajax:error', (e, xhr, status, error) ->
    $("div.voting").html(xhr.responseText)



  $('.vote-cancel').bind 'ajax:success', (e, data, status, xhr) ->

    div_vote = '.' + 'vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id

    $(div_vote + " div.rating").html(data.rating)
    $(div_vote + " .vote-cancel").hide()
    $(div_vote + " .good-question-link").show()
    $(div_vote + " .bad-question-link").show()

  .bind 'ajax:error', (e, xhr, status, error) ->
    $("div.voting").html(xhr.responseText)
