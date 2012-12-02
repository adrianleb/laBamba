
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
    
    $("#logo").hover ((e) =>
      $("#logo").text('☺')), ((e) =>
        $("#logo").text('☻'))
      
    # go back on the player
    # 
    $('#player-back').on 'click', (e) =>
      nop e
      @backToPoetry()

  sendWords: ->
    @text = $('#text-input').val().replace(","," ").replace("("," ").replace(")"," ").replace("'"," ")
    $('#intro').addClass 'begone_up'
    $('#loader').removeClass 'begone_down'

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

  imgLoadCallback: =>

    @imagesPreloaded = (++@noImagesPreloaded == @imagesToPreload)
          # preload the sounds

    if @imagesPreloaded
      sm.preload =>
        @soundsPreloaded = true
        @checker()

        if window.ag?
          window.ag.generate()
          @acmeLoader()

      # @checker()

  bailaLaBamba: ->

    @runChecker = true

    # add the wave words to the proloader
    @imagesToPreload = 0
    _.each @dictionary, (word) =>
      sm.sounds[word.name] = word.sound_url

      # preload the images
      cl('preloados: ' + word.name + ': ' + word.image)
      if word.image? and word.image != 'null'
        cl('whatr')
        @imagesToPreload++
        $('#img-preloader').append('<img src="' + word.image + '">')

    @soundsPreloaded = false
    @noImagesPreloaded = 0


    

    $('#img-preloader img').on 'load', (e) =>
      cl " MIAU" 
      @imgLoadCallback()
    $('#img-preloader img').on 'error', (e) =>
      cl 'booo'
      @imgLoadCallback()





  backToPoetry: ->
    $('#intro').removeClass 'begone_up'
    $('#player').addClass 'begone_down'
    @runChecker = false


  checker: (timestamp) ->
    if one.runChecker and @imagesPreloaded and @soundsPreloaded
      window.webkitRequestAnimationFrame ( (timestamp) =>
        one.checker(timestamp)
      )
      one.currentTime = (timestamp - one.startTime) / 1000
      @acmeChecker()


  acmeLoader: (hash=window.ag.acme) ->
    @startTime = Date.now()
    @currentTime = 0

    for c in Object.keys(hash)
      hash[c].current = 0

    $('#loader').addClass 'begone_up'
    $('#player').removeClass 'begone_down'


  acmeChecker: (hash=window.ag.acme) ->

    for c in Object.keys(hash) 
      if typeof hash[c] is 'object'
        index =  hash[c].current

        unless not hash[c][index]?
          if hash[c][index].start <= one.currentTime
            hash[c].current += 1
            @acmeAct hash[c]

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
  window.ag = new AcmeGenerator(90)
  window.sm = new SoundMachinez()
