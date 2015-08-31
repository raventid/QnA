$ ->
  questionEditLink()
  answerEditLink()
  removeFileField()
  questionCancel()
  answerCancel()
  questionlike()
  answerLike()


window.answerLike = ->
  $('.answer-like').bind 'ajax:success', (e, data, status, xhr) ->
    $('#answer-like-' + xhr.responseJSON.like.voteable_id + ' .likes').html('Likes: ' + xhr.responseJSON.likes_count)
    $('#answer-like-' + xhr.responseJSON.like.voteable_id + ' .cancel').html('<a class="answer-cancel" data-type="json" data-remote="true" rel="nofollow" data-method="delete" href="/votes/1?answer_id=' + xhr.responseJSON.like.voteable_id + '">Отменить выбор</a>')
    answerCancel()
  .bind 'ajax:error', (e, xhr, status, error) ->
    clearAlertAndNotice()
    answerCancel()
    $('.alert').append('Error. Perhapes you voted before')

window.questionlike = ->
  $('.question-like').bind 'ajax:success', (e, data, status, xhr) ->
    $('.votes li.likes').html('Likes: ' + xhr.responseJSON.likes_count)
    $('.votes li.cancel').html('<a class="question-cancel" data-type="json" data-remote="true" rel="nofollow" data-method="delete" href="/votes/1?question_id=1">Отменить выбор</a>')
    questionCancel()
  .bind 'ajax:error', (e, xhr, status, error) ->
    questionCancel()
    $('.alert').append('Error. Perhapes you voted before')

window.answerCancel = ->
  $('.answer-cancel').bind 'ajax:success', (e, data, status, xhr) ->
    $('#answer-like-' + xhr.responseJSON.like.id + ' .likes').html('Likes: ' + xhr.responseJSON.likes_count)
    $('#answer-like-' + xhr.responseJSON.like.id + ' li.cancel').html(' ')
    allScripts()

window.questionCancel = ->
  $('.question-cancel').bind 'ajax:success', (e, data, status, xhr) ->
    $('.votes li.likes').html('Likes: ' + xhr.responseJSON.likes_count)
    $('.votes li.cancel').html('')
  .bind 'ajax:error', (e, xhr, status, error) ->
    clearAlertAndNotice()
    $('.alert').append('Cannot delete. Try later.')

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

window.removeFileField = ->
  $('a.remove_fields.dynamic').click (e)->
    e.preventDefault()
    $(this).parent('.form-group').remove()
    removeFileField()
