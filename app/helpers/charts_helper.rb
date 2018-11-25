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

  def assets_stacked_area_chart
    return no_chart_data if AssetSnapshot.count.zero?

    empty_months = end_of_months_since AssetSnapshot.minimum(:date)

    query = FinancialAsset.order(:name)

    series = query.each_with_object([]) do |asset, array|
      snapshots_query = asset.snapshots.select([:date, 'SUM(value) AS value']).group(:date).order(:date)

      data = snapshots_query.each_with_object({}) do |row, points|
        points[row.date.to_js_time] = row.value
      end

      data = empty_months.merge(data).to_a

      array << {
        name: asset.name,
        data: data
      }
    end

    options = {
      chart: { type: 'area' },
      series: series
    }

    chart 'assets-stacked-area-chart', options
  end
end
