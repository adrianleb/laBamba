
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

    $("#logo").on 'click', (e) =>
      $("body").toggleClass('fullscreen')
      cl "MOOO"
    # go back on the player
    # 
    $('#player-back').on 'click', (e) =>
      nop e
      @backToPoetry()

      
  sendWords: ->
    @text = $('#text-input').val()
    console.log @text
    # do http request
    $.ajax
      type: 'POST'
      url: '/highlander/dictionary'
      data:
        text: @text
      success: (data) =>
        @dictionary = data
        @bailaLaBamba()
      ,
      dataType: 'json'

  bailaLaBamba: ->
    $('#intro').addClass 'begone_up'
    $('#player').removeClass 'begone_down'
    @runChecker = true

    # add the wave words to the proloader and preload
    _.each @dictionary, (word) =>
      sm.sounds[word.name] = word.sound_url
    sm.preload =>
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

        unless not hash[c][index]?
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

    if ['play', 'show_word', 'show_image'].indexOf(action) > -1
      sm[action](args[0])
    else if action is 'play_note'
      sm[action](args[0], args[1], args[2])
    one.canvas.css 'backgroundColor', "hsl(#{Math.round( (Math.random() * 255 ) )}, 30%, 70%)"

$ ->
  window.one = new One
  window.ag = new AcmeGenerator(80)
  window.sm = new SoundMachinez()
