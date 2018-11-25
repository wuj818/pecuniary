$(document).on 'turbolinks:load', ->
  Highcharts.setOptions
    lang:
      thousandsSep: ','
    credits:
      enabled: false
    chart:
      zoomType: 'x'
    title:
      text: null
    xAxis:
      title:
        text: null
      type: 'datetime'
    yAxis:
      title:
        text: null
      labels:
        format: '${value:,.0f}'
    tooltip:
      shared: true
      crosshairs: true
      xDateFormat: '%B %e, %Y'
      valuePrefix: '$'
    plotOptions:
      line:
        marker:
          enabled: false
      area:
        marker:
          enabled: false
        stacking: 'normal'

  $('.chart').each ->
    id = $(@).attr 'id'
    options = $(@).data().options

    Highcharts.chart id, options
