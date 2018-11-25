module ChartsHelper
  def chart(id, options)
    tag.div id: id, class: 'chart', data: { options: options.to_json }
  end

  def no_chart_data
    tag.code 'no chart data...'
  end

  def net_worth_line_chart
    return no_chart_data if AssetSnapshot.count.zero?

    query = AssetSnapshot.select([:date, 'SUM(value) AS value']).group(:date).order(:date)

    data = query.each_with_object([]) do |row, array|
      array << [row.date.to_js_time, row.value]
    end

    options = {
      legend: { enabled: false },
      chart: { zoomType: 'x' },
      xAxis: { type: 'datetime' },
      yAxis: { labels: { format: '${value:,.0f}' } },
      tooltip: {
        xDateFormat: '%B %e, %Y',
        valuePrefix: '$'
      },
      series: [
        {
          type: 'line',
          name: 'Net Worth',
          data: data
        }
      ]
    }

    chart 'net-worth-line-chart', options
  end
end
