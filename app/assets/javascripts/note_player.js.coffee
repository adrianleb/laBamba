class NotePlayer
  
  play: (context, frequency, length) ->
    oscillator = context.createOscillator()
    oscillator.type = 0
    oscillator.frequency.value = frequency
    
    gainNode = context.createGainNode()
    
    oscillator.connect(gainNode)

    gainNode.connect(context.destination)
    
    gainNode.gain.linearRampToValueAtTime(0.6, context.currentTime + (length/4/1000));
    gainNode.gain.exponentialRampToValueAtTime(0.1, context.currentTime + (length/1000));

    oscillator.noteOn(0)
    setTimeout((->oscillator.noteOff(0)), length)

window.NotePlayer = new NotePlayer()