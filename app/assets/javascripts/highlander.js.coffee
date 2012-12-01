# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.cl = (s) ->
  console.debug(s)

window.nop = (e) ->
  e.preventDefault()

class One

  constructor: ->
    @initEvents()

  initEvents: ->
    cl('one')
    $('#text-submit').on 'click', =>
      cl('loklol')
      @sendWords()

  sendWords: ->
    # do http request
    $.ajax
      type: 'POST'
      url: '/highlander/dictionary'
      data:
        text: $('#text-input').text()
      success: (data) =>
        @dictionary = data
        cl(@dictionary)
      ,
      dataType: 'json'
      # when get the response @bailaLaBamba()


  bailaLaBamba: ->
    # adrian codes here
  
  


window.one = new One

