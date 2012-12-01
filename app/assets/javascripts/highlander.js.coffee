
window.cl = (s) ->
  console.debug(s)

window.nop = (e) ->
  e.preventDefault()

class One

  constructor: ->
    @initEvents()
    @runChecker = true
    @canvas = $('#player-canvas')

  initEvents: ->
    cl('one')

    # submit the text
    $('#text-submit').on 'click', (e) =>
      nop e

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
    @runChecker = true
    @checker()
    if window.ag?
      window.ag.generate()
      @acmeLoader window.ag.acme


  backToPoetry: ->
    $('#intro').removeClass 'begone_up'
    $('#player').addClass 'begone_down'
    @runChecker = false


  checker: ->
    if one.runChecker
      window.webkitRequestAnimationFrame one.checker
      one.canvas.css 'backgroundColor', "hsl(#{Math.round( (Math.random() * 255 ) )}, 30%, 70%)"



  acmeLoader: (hash) ->
    time = 0
    hash.currentTime = 0
 
    for c in Object.keys(hash) 
      hash[c].current = 0

      if typeof hash[c][hash[c].current] is 'object'
        action = hash[c][hash[c].current].action
        args = hash[c][hash[c].current].arguments

      @[action](args)
  
  
  play: (arg) ->
    console.log 'play func', arg

  play_note: (arg) ->
    console.log 'play_note func', arg

$ ->
  window.one = new One
  window.ag = new AcmeGenerator()
