class window.AcmeGenerator
  
  probs:
    'kick'    : type: 'simple',   probs: [ 1,   0,   0,   0,   1,   0,   0,   0,   1,   0,   1,   0  ]
    'snare'   : type: 'simple',   probs: [ 0,   0,   1,   0,   0,   0,   1,   0,   0,   0,   1,   0  ]
    'hihat'   : type: 'simple',   probs: [ 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
    'sound_1' : type: 'harmonic', octave: 4, probs: [ 0.1 ]
    'sound_2' : type: 'harmonic', octave: 3, probs: [ 0.4, 0.8, 0.3, 0]

  acme: {}

  tempo      : null
  period     : null
  midi_table : null
  length     : null
  
  scale:
    'a_minor': [21,23,24,26,28,29,31]

  constructor: (tempo=120, length=10, use_scale='a_minor') ->
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
      
      if lane['type'] =='simple'
        @acme[instrument] = @generate_simple_lane(lane, instrument)

      if lane['type'] =='harmonic'
        @acme[instrument] = @generate_harmonic_lane(lane, instrument)

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
          note_length = Math.floor((Math.random()*4)+1)*@period
          t += note_length
          note = Math.floor((Math.random()*@scale[@use_scale].length)+1) + (lane['octave']*12)
          result.push {start: t, action: 'play_note', arguments: [instrument, @midi_table[note], note_length]}
        else
          t+=@period

    return result

  midi_to_freq: (n) ->
    Math.pow(2,((n-69)/12))*440