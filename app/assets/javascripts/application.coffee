#= require rails-ujs
#= require jquery3
#= require turbolinks
#= require popper
#= require bootstrap
#= require d3.v3
#= require nv.d3
#= require moment
#= require tempusdominus-bootstrap-4
#= require_tree .

$(document).on 'turbolinks:load', ->
  $('.alert').alert()

  $('.date-picker').datetimepicker
    format: 'YYYY-MM-DD'

  $('.datetimepicker-input').focus ->
    $(@).next().click()
