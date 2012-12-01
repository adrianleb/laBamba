
window.cl = (s) ->
  console.debug(s)

window.nop = (e) ->
  e.preventDefault()

class One

  constructor: ->
    @initEvents()
    @runChecker = true

  initEvents: ->
    cl('one')

    # submit the text
    $('#text-submit').on 'click', =>
      cl('loklol')
      @sendWords()


    # go back on the player
    # 
    $('#player-back').on 'click', (e) =>
      cl 'yolo'
      nop e
      @backToPoetry()

      
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


  backToPoetry: ->
    $('#intro').removeClass 'begone_up'
    $('#player').addClass 'begone_down'

  checker: ->
    window.webkitRequestAnimationFrame one.checker
    # console.log 'omg'
    # adrian codes here
  
  

$ ->
  window.one = new One
  window.ag = new AcmeGenerator()
