class window.AcmeGenerator
  
  probs:
    'kick'    : type: 'simple',   probs: [ 1,   0,   0.3, 0,   0.3, 0,   0.1,   0,   0.8,   0,   0.2,   0  ]
    'snare'   : type: 'simple',   probs: [ 0,   0,   0.1,   0,   0,   0,  0.1,   0,   0,    0.2, 0.6,   0  ]
    #'hihat'   : type: 'simple',   probs: [ 0.75, 0.5, 0.75, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
    '0' : type: 'harmonic', maxvol: 0.01, octave: 7, probs: [ 0.1 ]
    '0' : type: 'harmonic', maxvol: 0.01, octave: 6, probs: [ 1,   0,   0.3,   0,   0.8,   0,   0.1,   0,   1,   0,   0.5,   0.2  ]
    '3' : type: 'harmonic', maxvol: 0.6, octave: 3, probs: [ 1,   0.5]# [1 ,0   0.3,   0,   0.8,   0,   0.1,   0,   1,   0,   0.5,   0.2  ]
    '2' : type: 'harmonic', maxvol: 0.6, octave: 2, probs: [ 1,   0.5]
    'speech'  : type: 'speech'
    'words'   : type: 'words'
    'images'  : type: 'images'

  acme: {}

  tempo      : null
  period     : null
  midi_table : null
  length     : null
  
  scale:
    'a_minor': [21,23,24,26,28,29,31]

  constructor: (tempo=120, length=60, use_scale='a_minor') ->
    @length = length
    @tempo = tempo
    @use_scale = use_scale
    @period = (60 / tempo) / 4 # sixteenth notes
    @midi_table = (@midi_to_freq(i) for i in [0..127])

  test: ->
    console.log(@midi_table)

  generate: ->
    console.log("Generating music!")
    _.each @probs, (lane, instrument) =>
      
      if lane['type'] == 'simple'
        @acme[instrument] = @generate_simple_lane(lane, instrument)

      if lane['type'] == 'harmonic'
        @acme[instrument] = @generate_harmonic_lane(lane, instrument)

      if lane['type'] == 'speech'
        @acme[instrument] = @generate_speech_lane(lane, instrument)

      if lane['type'] == 'words'
        @acme[instrument] = @generate_words_lane(lane, instrument)

      if lane['type'] == 'images'
        @acme[instrument] = @generate_images_lane(lane, instrument)


  generate_simple_lane: (lane, instrument) ->
    t = 0.0
    result = []
    
    _(Math.ceil(@length/(@period*lane['probs'].length))).times =>
      _.each lane['probs'], (prob) =>

        if Math.random() <= prob
          result.push {start: t, action: 'play', arguments: [instrument]}
        
        t+=@period

    return result

  generate_harmonic_lane: (lane, instrument) ->
    t = 0
    result = []

    while t <= @length
      _.each lane['probs'], (prob) =>
        if Math.random() <= prob
          note_length = Math.floor((Math.random()*8)+1)*@period
          t += note_length
          note = @scale[@use_scale][Math.floor((Math.random()*@scale[@use_scale].length)+1)] + (lane['octave']*12)
          result.push {start: t, action: 'play_note', arguments: [instrument, @midi_table[note], note_length, lane['maxvol']]}
        else
          t+=@period

    return result


  generate_speech_lane: (lane, instrument) ->
    t = 0
    result = []

    while t <= @length
      _.each one.dictionary, (word) =>
        result.push {start: t, action: 'play', arguments: [word.name]}
        t += parseFloat(word.sound_duration) + 0.3

    return result

  generate_words_lane: (lane, instrument) ->
    t = 0
    result = []

    while t <= @length
      _.each one.dictionary, (word) =>
        result.push {start: t, action: 'show_word', arguments: [word.name]}
        t += parseFloat(word.sound_duration) + 0.3

    return result

  generate_images_lane: (lane, instrument) ->
    t = 0
    result = []

    while t <= @length
      _.each one.dictionary, (word) =>
        result.push {start: t, action: 'show_image', arguments: [word.image]}
        t += parseFloat(word.sound_duration) + 0.3

    return result


  midi_to_freq: (n) ->
    Math.pow(2,((n-69)/12))*440
