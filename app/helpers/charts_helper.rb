module ChartsHelper
  def chart(id, options)
    tag.div id: id, class: 'chart', data: { options: options.to_json }
  end

  def net_worth_line_chart
    query = AssetSnapshot.select([:date, 'SUM(value) AS value']).group(:date).order(:date)

    data = query.each_with_object([]) do |row, array|
      array << [row.date.to_js_time, row.value]
    end

    options = {
      title: { text: nil },
      legend: { enabled: false },
      chart: { zoomType: 'x' },
      xAxis: { type: 'datetime' },
      yAxis: {
        title: { text: nil },
        labels: { format: '${value:,.0f}' }
      },
      tooltip: {
        shared: true,
        crosshairs: true,
        xDateFormat: '%B %e, %Y',
        valuePrefix: '$'
      },
      series: [
        {
          type: 'line',
          name: 'Net Worth',
          marker: { enabled: false },
          data: data
        }
      ],
      credits: { enabled: false }
    }

    chart 'net-worth-line-chart', options
  end
end
