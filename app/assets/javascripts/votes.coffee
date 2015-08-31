# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$("div.voting").bind 'ajax:success', (e, data, status, xhr) ->
  $("div.voting").html(xhr.responseText)

$ ->
  $('.good-question-link, .bad-question-link').bind 'ajax:success', (e, data, status, xhr) ->

    $("div.voting").html(xhr.responseText)
#    div_vote = '#' + 'vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id
#
#    $(div_vote + " .rating").html(data.count_votes)
#    $(div_vote + " .vote-up").hide()
#    $(div_vote + " .vote-down").hide()
  .bind 'ajax:error', (e, xhr, status, error) ->
    $("div.voting").html(xhr.responseText)

  $('.vote-cancel').bind 'ajax:success', (e, data, status, xhr) ->

    div_vote = '#' + 'vote-' + data.votable_type.toLowerCase() + '-' + data.votable_id

    $(div_vote + " .rating").html(data.count_votes)
    $(div_vote + " .vote-up").show()
    $(div_vote + " .vote-down").show()
