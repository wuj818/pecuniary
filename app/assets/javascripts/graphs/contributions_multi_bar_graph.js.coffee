$ ->
  $graph = $('#contributions-multi-bar-graph')

  if $graph.length isnt 0
    data = $graph.data 'graph-data'

    nv.addGraph ->
      chart = nv.models.multiBarChart()
        .color(d3.scale.category10().range())
        .stacked(true)
        .delay(0)
        .clipEdge false

      chart.xAxis.tickFormat (d) -> d3.time.format('%b %Y') new Date d

      chart.yAxis.tickFormat (d) -> '$' + d3.format(',f') d

      d3.select("##{$graph.attr 'id'} svg")
        .datum(data)
        .transition()
        .duration(0)
        .call chart

      nv.utils.windowResize chart.update

      chart
