$ ->
  $('.line-graph').each ->
    $graph = $(@)

    nv.addGraph ->
      chart = nv.models.lineChart()
        .useInteractiveGuideline(true)
        .color(d3.scale.category10().range())
        .margin(left: 65, right: 30, top: 10)
        .yDomain([0, $graph.data 'y-max'])
        .showLegend($graph.data 'show-legend')
        .clipEdge false

      chart.xAxis.tickFormat (d) -> d3.time.format('%b %Y') new Date d

      chart.yAxis.tickFormat (d) -> '$' + d3.format(',f') d

      d3.select("##{$graph.attr 'id'} svg")
        .datum($graph.data 'graph-data')
        .transition()
        .duration(0)
        .call chart

      nv.utils.windowResize chart.update

      chart
