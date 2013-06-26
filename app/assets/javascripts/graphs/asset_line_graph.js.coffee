$ ->
  $graph = $('#asset-line-graph')

  if $graph.length isnt 0
    nv.addGraph ->
      chart = nv.models.lineChart()
        .margin(left: 65, right: 30)
        .yDomain([0, $graph.data 'y-max'])
        .color d3.scale.category10().range()

      chart.xAxis
        .tickFormat( (d) -> d3.time.format('%b %Y') new Date d )

      chart.yAxis
        .tickFormat( (d) -> '$' + d3.format(',f') d)

      d3.select("##{$graph.attr 'id'} svg")
        .datum($graph.data('graph-data'))
        .transition()
        .duration(500)
        .call chart

      nv.utils.windowResize chart.update

      chart
