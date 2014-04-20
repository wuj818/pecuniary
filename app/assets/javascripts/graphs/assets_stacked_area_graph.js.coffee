$ ->
  $graph = $('#assets-stacked-area-graph')

  if $graph.length isnt 0
    nv.addGraph ->
      chart = nv.models.stackedAreaChart()
        .useInteractiveGuideline(true)
        .x( (d) -> d[0] )
        .y( (d) -> d[1] )
        .color(d3.scale.category10().range())
        .clipEdge false

      chart.xAxis.tickFormat (d) -> d3.time.format('%b %Y') new Date d

      chart.yAxis.tickFormat (d) -> '$' + d3.format(',f') d

      chart.margin left: 65, right: 25

      d3.select("##{$graph.attr 'id'} svg")
        .datum($graph.data 'graph-data')
        .transition()
        .duration(500)
        .call chart

      nv.utils.windowResize chart.update

      chart
