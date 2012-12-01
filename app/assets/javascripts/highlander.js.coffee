# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
class One

  constructor: ->
    @initEvents()

  initEvents: ->
    $('form').on('submit', =>
      @sendWords()
    )

  sendWords: ->
    # do http request
      # when get the response @bailaLaBamba()


  bailaLaBamba: ->
    # adrian codes here
  
  


window.one = new One
window.ag = new AcmeGenerator()