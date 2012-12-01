class NotePlayer
  
  play: (context, frequency, length) ->
    oscillator = context.createOscillator()
    oscillator.type = 2
    oscillator.frequency.value = frequency
    
    gainNode = context.createGainNode()
    
    oscillator.connect(gainNode)

    gainNode.connect(context.destination)
    gainNode.gain.value = .1
    oscillator.noteOn(0)
    setTimeout((->oscillator.noteOff(0)), length)
 