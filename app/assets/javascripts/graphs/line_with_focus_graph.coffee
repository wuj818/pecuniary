$(document).on 'turbolinks:load', ->
  $('.line-with-focus-graph').each ->
    $graph = $(@)

    nv.addGraph ->
      chart = nv.models.lineWithFocusChart()
        .margin(left: 65, right: 30, top: 10)
        .margin2(left: 65, right: 30, top: 0, bottom: 30)
        .forceY([0, $graph.data 'y-max'])
        .showLegend(false)
        .clipEdge false

      chart.xAxis.tickFormat (d) -> d3.time.format('%b %Y') new Date d

      chart.x2Axis.tickFormat (d) -> d3.time.format('%b %Y') new Date d

      chart.yAxis.tickFormat (d) -> '$' + d3.format(',f') d

      chart.y2Axis.tickFormat (d) -> '$' + d3.format(',f') d

      chart.tooltipContent (key, x, y, e, graph) -> "<h3>#{key}</h3><p>#{y} on #{x}</p>"

      d3.select("##{$graph.attr 'id'} svg")
        .datum($graph.data 'graph-data')
        .transition()
        .duration(0)
        .call chart

      nv.utils.windowResize chart.update

      chart
