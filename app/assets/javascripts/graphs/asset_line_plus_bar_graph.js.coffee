$ ->
  $graph = $('#asset-line-plus-bar-graph')

  if $graph.length isnt 0
    data = $graph.data 'graph-data'

    nv.addGraph ->
      chart = nv.models.linePlusBarChart()
        .x( (d, i) -> i )
        .y( (d) -> d[1] )
        .color d3.scale.category10().range()

      chart.xAxis.tickFormat (d) ->
        dx = data[0].values[d] and data[0].values[d][0] or 0
        d3.time.format('%b %Y') new Date dx

      chart.y1Axis.tickFormat (d) -> '$' + d3.format(',f') d

      chart.y2Axis.tickFormat (d) -> '$' + d3.format(',f') d

      d3.select("##{$graph.attr 'id'} svg")
        .datum(data)
        .transition()
        .duration(500)
        .call chart

      nv.utils.windowResize chart.update

      chart
