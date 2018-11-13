#= require rails-ujs
#= require jquery3
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
    icons:
      time: 'fa fa-clock-o'
      date: 'fa fa-calendar'
      up: 'fa fa-arrow-up'
      down: 'fa fa-arrow-down'
      next: 'fa fa-chevron-right'
      previous: 'fa fa-chevron-left'

      clear: 'fa fa-trash'
      close: 'fa fa-times'
      date: 'fa fa-calendar'
      down: 'fa fa-arrow-down'
      next: 'fa fa-chevron-right'
      previous: 'fa fa-chevron-left'
      time: 'fa fa-clock-o'
      today: 'fa fa-crosshairs'
      up: 'fa fa-arrow-up'
