$(document).on 'turbolinks:load', ->
  Highcharts.setOptions
    lang:
      thousandsSep: ','

  $('.chart').each ->
    id = $(@).attr 'id'
    options = $(@).data().options

    Highcharts.chart id, options
