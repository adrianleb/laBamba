
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
    @bailaLaBamba()

  bailaLaBamba: ->
    $('#intro').addClass 'begone_up'
    $('#player').removeClass 'begone_down'

    # adrian codes here
  
  

$ ->
  window.one = new One
  window.ag = new AcmeGenerator()
