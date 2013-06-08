# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $html = $('html')
  
  $html.on 'click', '.rules-controller .delete', (e) ->
    e.preventDefault()
    console.log $(this).closest('fieldset').remove()
    
  $html.on 'click', '.rules-controller .new', (e) ->
    e.preventDefault()
    $('#fieldsets').append($('#fieldset-factory').html())
# TODO animation for delete / new
# TODO placeholder hints for each setter