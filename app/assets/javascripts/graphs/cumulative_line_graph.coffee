$ ->
  $('.cumulative-line-graph').each ->
    $graph = $(@)

    data = $(@).data 'graph-data'

    nv.addGraph ->
      chart = nv.models.cumulativeLineChart()
        .x( (d) -> d[0] )
        .y( (d) -> d[1] )
        .color d3.scale.category10().range()

      chart.xAxis.tickFormat (d) ->
        d3.time.format('%b %Y') new Date d

      chart.yAxis.tickFormat d3.format(',.1%')

      chart.tooltipContent (key, x, y, e, graph) -> "<h3>#{key}</h3><p>#{y} on #{x}</p>"

      d3.select("##{$graph.attr 'id'} svg")
        .datum(data)
        .transition()
        .duration(0)
        .call chart

      nv.utils.windowResize chart.update

      chart
