$ ->
  questionEditLink()
  answerEditLink()

window.clearAlertAndNotice = ->
  $('.notice').html('')
  $('.alert').html('')

window.questionEditLink = ->
  $('.question-edit-link').click (e)->
    e.preventDefault()
    $('#question-edit-form').show()

window.answerEditLink = ->
  $('.answer-edit-link').click (e) ->
    e.preventDefault()
    data = $(this).data('answerId')
    $('form#edit_answer_' + data).show()
    $('.answer-delete-link').hide()