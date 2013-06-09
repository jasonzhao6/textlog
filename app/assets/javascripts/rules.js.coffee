# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $html = $('html')

  $html.on 'click', '.rules-controller .new', addSetter
  $html.on 'change', '.rules-controller #setters select', changeSetterCommand
  $html.on 'click', '.rules-controller .delete', deleteSetter
  $html.on 'submit', '.rules-controller form', validateForm
  
# 
# new/edit forms
# 
addSetter = (e) ->
  e.preventDefault()
  $('#setters').append($('#fieldset-factory').html())  

changeSetterCommand = (e) ->
  $this = $(this)
  $argField = $this.closest('fieldset').find('input')
  switch $this.val()
    when 'set_primary_type'
      $argField.attr('placeholder', "{ 'primary_type' => 'biking' }")
    when 'set_secondary_type'
      $argField.attr('placeholder', "{ 'secondary_type' => 'marin headlands' }")
    when 'add_friend'
      $argField.attr('placeholder', "{ 'name' => 'Somebody', 'fb_id' => 'somebody' }")
    when 'add_duration'
      $argField.attr('placeholder', "{ 'num' => '44', 'unit' => 'min' }")
    when 'set_distance'
      $argField.attr('placeholder', "{ 'num' => '17.4', 'unit' => 'mi' }")
    when 'set_reps'
      $argField.attr('placeholder', "{ 'reps' => '10' }")
    when 'set_note'
      $argField.attr('placeholder', "{ 'note' => 'felt engaged' }")

deleteSetter = (e) ->
  e.preventDefault()
  $(this).closest('fieldset').remove()

validateForm = (e) ->
  if $('#rule_arg').val().trim().length == 0
    #  TODO show bootstrap_flash and active record like errors thru js
    alert("Regex can't be blank")
  else
    return true
  return false
