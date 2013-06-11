# The organization of this file is modeled after backbone.js' ViewModel

$ ->
  $html.on('change', '.rules-controller #sort-by', changeSortBy)
  
  $html.on('click', '.rules-controller .new', appendFieldset)
  $html.on('click', '.rules-controller .delete', removeFieldset)
  $html.on('change', '.rules-controller #setters select', updatePlaceholder)
  $html.on('submit', '.rules-controller form#rule', validateRuleForm)
  
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

validateRuleForm = ->
  if $('#rule_arg').val().trim().length == 0
    #  TODO show bootstrap_flash and active record like errors thru js
    alert("Regex can't be blank")
    return false
  else
    return true
