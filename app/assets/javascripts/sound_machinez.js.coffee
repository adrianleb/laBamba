class window.SoundMachinez
  
  sounds:
    'kick'  : '/sounds/kick.wav'
    'snare' : '/sounds/snare.wav'
    'hihat' : '/sounds/hihat.wav'

  preloaded: {}

  context: null

  constructor: ->
    @context = new webkitAudioContext()
    @node = @context.createJavaScriptNode(1024, 1, 1)

  preload: ->

    _.each @sounds, (path, key) =>

      request = new XMLHttpRequest()
      request.open('GET', path, true)
      request.responseType = 'arraybuffer'
      request.key = key
      request.addEventListener('load', (=>@add_to_context(request, key)), false)
      request.send()
  
  add_to_context: (request,key) =>
    @preloaded[request.key] = {}
    
    @preloaded[request.key].bytes = request.response

    @preloaded[request.key].initbuff = =>
      @preloaded[request.key].buffer_source = @context.createBufferSource()
      @preloaded[request.key].buffer_source.buffer = @context.createBuffer(@preloaded[request.key].bytes, false)
      @preloaded[request.key].buffer_source.connect(@context.destination)

    @preloaded[request.key].initbuff()
  
  play: (sound_key) ->
    @preloaded[sound_key].buffer_source.noteOn(0)
    setTimeout(@preloaded[sound_key].initbuff, @preloaded[sound_key].bytes.byteLength/@context.sampleRate)

  play_note: (instrument, frequency, length) ->
    NotePlayer.play(@context, frequency, length)
