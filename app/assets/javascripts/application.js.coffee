#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require d3.v3
#= require nv.d3
#= require moment
#= require bootstrap-datetimepicker
#= require_tree .

$ ->
  $('.alert').alert()

  $('.date-picker').datetimepicker
    format: 'YYYY-MM-DD'
    pickTime: false
