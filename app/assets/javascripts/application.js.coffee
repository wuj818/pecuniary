#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
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
    icons:
      time: 'fa fa-clock-o'
      date: 'fa fa-calendar'
      up: 'fa fa-arrow-up'
      down: 'fa fa-arrow-down'
