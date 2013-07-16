# The organization of this file is modeled after backbone.js' ViewModel

$ ->
  $html.on('change', '.rules-controller #sort-by', changeSortBy)

  $html.on('keyup', '.rules-controller #rule_arg', detectSetter)
  $html.on('click', '.rules-controller .new', appendFieldset)
  $html.on('click', '.rules-controller .delete', removeFieldset)
  $html.on('change', '.rules-controller #setters select', updatePlaceholder)
  $html.on('submit', '.rules-controller form#rule', validateForm)

#
# Sidebar
#
changeSortBy = (e) ->
  $this = $(this)
  $form = $this.closest('form')
  $this.attr('name', null) if $this.val() != 'most-frequently-used'
  $form.submit()

#
# New/edit forms
#
activityRegex = /\?<activity>/
durationRegex = /\?<duration>.*\?<unit>/
distanceRegex = /\?<distance>.*\?<unit>/
repsRegex = /\?<reps>/
noteRegex = /\?<note>/
detectSetter = ->
  $firstSetter = $('#setters select').first()
  if $firstSetter.val() == ''
    matcher = $(this).val()
    if activityRegex.test(matcher)
      $firstSetter.val('set_activity')
    else if durationRegex.test(matcher)
      $firstSetter.val('add_duration')
    else if distanceRegex.test(matcher)
      $firstSetter.val('set_distance')
    else if repsRegex.test(matcher)
      $firstSetter.val('set_reps')
    else if noteRegex.test(matcher)
      $firstSetter.val('set_note')

appendFieldset = (e) ->
  e.preventDefault()
  $('#setters').append($('#fieldset-factory').html())

removeFieldset = (e) ->
  e.preventDefault()
  $(this).closest('fieldset').remove()

updatePlaceholder = ->
  $select = $(this)
  $input = $select.closest('fieldset').find('input')
  $input.attr('placeholder', SETTER_PLACEHOLDERS[$select.val()])

validateForm = ->
  if $('#rule_arg').val().trim().length == 0
    #  TODO show bootstrap_flash and active record like errors thru js
    alert('Rule must have a matcher')
  else if !hasSetter()
    alert('Rule must have at least 1 setter')
  else
    return true

  return false

#
# Helpers
#
hasSetter = ->
  !!_.map($('#setters select'), (setter) -> $(setter).val()).join().length
