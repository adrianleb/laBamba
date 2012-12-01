class window.AcmeGenerator
  
  probs:
    'kick'  : [ 1,   0,   0,   0,   1,   0,   0,   0,   1,   0,   1,   0  ]
    'snare' : [ 0,   0,   1,   0,   0,   0,   1,   0,   0,   0,   1,   0  ]
    'hihat' : [ 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5]

  tempo      : null
  period     : null
  midi_table : null
  
  scale:
    'a_minor': [21,23,24,26,28,29,31]

  constructor: (tempo=120) ->
    @tempo = tempo
    @period = (60 / tempo)
    @midi = (@midi_to_freq(i) for i in [0..127])

  test: ->
    console.log(@tempo)
    console.log(@period)
    console.log(@midi)

  generate: (length = 10) ->
    console.log(@probs)
    _.each(@probs, ->
      console.log(lane))

  midi_to_freq: (n) ->
    (2^((n-69)/12))*440