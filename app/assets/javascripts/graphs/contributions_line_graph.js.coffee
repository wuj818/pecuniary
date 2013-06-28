$ ->
  $graph = $('#contributions-line-graph')

  if $graph.length isnt 0
    data = $graph.data 'graph-data'

    nv.addGraph ->
      chart = nv.models.lineChart()
        .color(d3.scale.category10().range())
        .margin(left: 65, right: 30, top: 10)
        .yDomain([0, $graph.data 'y-max'])
        .showLegend(false)
        .clipEdge false

      chart.xAxis.tickFormat (d) -> d3.time.format('%b %Y') new Date d

      chart.yAxis.tickFormat (d) -> '$' + d3.format(',f') d

      chart.tooltipContent (key, x, y, e, graph) -> "<h3>#{key}</h3><p>#{y} on #{x}</p>"

      d3.select("##{$graph.attr 'id'} svg")
        .datum(data)
        .transition()
        .duration(500)
        .call chart

      nv.utils.windowResize chart.update

      chart
