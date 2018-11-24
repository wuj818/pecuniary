$(document).on 'turbolinks:load', ->
  headers = $('.table-stacked th').map ->
    $(@).text()

  $('.table-stacked tbody td').each (i) ->
    header = headers[i % headers.length] || ''
    $(@).prepend "<span class='fake-header'>#{header}</span>"
