# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Объявляем функцию ready, внутри которой можно поместить обработчики событий и другой код, который должен выполняться при загрузке страницы
ready = ->
  # Это наш обработчик, перенесенный сюда из document.ready ($ ->) 
  $ -> 
    $('.edit-answer-link').click (e) ->
      e.preventDefault();
      $(this).hide();
      answer_id = $(this).data('answerId')
      $('form#edit-answer-' + answer_id).show() 


#  Здесь могут быть другие обработчики событий и прочий код

$(document).ready(ready) # "вешаем" функцию ready на событие document.ready
$(document).on('page:load', ready)  # "вешаем" функцию ready на событие page:load
$(document).on('page:update', ready) # "вешаем" функцию ready на событие page:update

PrivatePub.subscribe '/questions/QUESTION_ID/answers/', (data, channel) ->
  answer = $.parseJSON(data['answer'])
  $('#list-of-all-questions').append('<h4><a href="/questions/QUESTION_ID/answers">' + question.title + '</a></h4>')
