
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

    # submit the text
    $('#text-submit').on 'click', (e) =>
      nop e

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
      @acmeLoader()


  backToPoetry: ->
    $('#intro').removeClass 'begone_up'
    $('#player').addClass 'begone_down'
    @runChecker = false


  checker: (timestamp) ->
    if one.runChecker
      window.webkitRequestAnimationFrame ( (timestamp) =>
        one.checker(timestamp)
      )
      one.currentTime = (timestamp - one.startTime) / 1000
      # cl one.currentTime
      # console.log one.currentTime
      one.canvas.css 'backgroundColor', "hsl(#{Math.round( (Math.random() * 255 ) )}, 30%, 70%)"
      @acmeChecker()


  acmeLoader: (hash=window.ag.acme) ->
    @startTime = Date.now()
    @currentTime = 0
    hash.currentTime = 0
    for c in Object.keys(hash) 
      hash[c].current = 0

      if typeof hash[c][hash[c].current] is 'object'
        action = hash[c][hash[c].current].action
        args = hash[c][hash[c].current].arguments

  

  acmeChecker: (hash=window.ag.acme) ->

    for c in Object.keys(hash) 
      if typeof hash[c] is 'object'
        index =  hash[c].current


        if hash[c][index].start <= one.currentTime
          hash[c].current += 1
          @acmeAct hash[c]


        # indexes = _.pluck hash[c], 'start'
        # console.log one.currentTime, indexes
        # for s in hash[c] 

        #   if s.start - one.currentTime
        #     index = hash[c].indexOf s
        #     unless hash[c].current is index
        #       hash[c].current = index
        #       @acmeAct hash[c]



  acmeAct: (channel) ->
    action = channel[channel.current].action
    args = channel[channel.current].arguments
    sm[action](args[0])

$ ->
  window.one = new One
  window.ag = new AcmeGenerator(60)
  window.sm = new SoundMachinez()
  sm.preload()
