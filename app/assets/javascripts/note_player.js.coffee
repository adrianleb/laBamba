class NotePlayer
  
  play: (context, instrument, frequency, length, maxvol=0.3) ->
    oscillator = context.createOscillator()
    oscillator.type = parseInt(instrument)
    oscillator.frequency.value = frequency
    
    gainNode = context.createGainNode()
    
    oscillator.connect(gainNode)
    
    gainNode.connect(context.destination)
    

    delayNode = context.createDelayNode();
    delayNode.delayTime.value = 1.5;
    gainNode.connect(delayNode)
    delayNode.connect(gainNode)

    gainNode.gain.value = 0.0
    gainNode.gain.linearRampToValueAtTime(0.3, context.currentTime + 0.01)
    gainNode.gain.linearRampToValueAtTime(0, context.currentTime + length/1000)

    oscillator.noteOn(0)
    setTimeout((->oscillator.noteOff(0)), length)

window.NotePlayer = new NotePlayer()