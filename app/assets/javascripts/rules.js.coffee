# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $html = $('html')
  
  if $('.rules-controller').length
    
    $html.on 'click', '.delete', (e) ->
      e.preventDefault()
      console.log $(this).closest('fieldset').remove()
      
    $html.on 'click', '.new', (e) ->
      e.preventDefault()
      $('#fieldsets').append($('#fieldset-factory').html())
