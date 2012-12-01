class window.AcmeGenerator
  
  probs:
    'kick'    : type: 'simple',   probs: [ 1,   0,   0.3,   0,   0.8,   0,   0.1,   0,   1,   0,   0.5,   0.2  ]
    'snare'   : type: 'simple',   probs: [ 0,   0,   1,   0,   0,   0,   0.7,   0,   0,   0.2,   0.9,   0  ]
    'hihat'   : type: 'simple',   probs: [ 0.75, 0.5, 0.75, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]
    '0' : type: 'harmonic', maxvol: 0.3, octave: 7, probs: [ 0.1 ]
    '0' : type: 'harmonic', maxvol: 0.4, octave: 6, probs: [ 1,   0,   0.3,   0,   0.8,   0,   0.1,   0,   1,   0,   0.5,   0.2  ]
    '3' : type: 'harmonic', maxvol: 0.9, octave: 3, probs: [ 1,   0.5]# [1 ,0   0.3,   0,   0.8,   0,   0.1,   0,   1,   0,   0.5,   0.2  ]

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
          note_length = Math.floor((Math.random()*8)+1)*@period
          t += note_length
          note = Math.floor((Math.random()*@scale[@use_scale].length)+1) + (lane['octave']*12)
          result.push {start: t, action: 'play_note', arguments: [instrument, @midi_table[note], note_length, lane['maxvol']]}
        else
          t+=@period

    return result

  midi_to_freq: (n) ->
    Math.pow(2,((n-69)/12))*440
