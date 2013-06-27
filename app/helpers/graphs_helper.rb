module GraphsHelper
  def asset_line_plus_bar_graph(asset)
    return if asset.snapshots.count.zero?

    all_dates = asset.snapshots.order(:date).inject({}) do |dates, snapshot|
      dates[snapshot.date.to_time.to_i * 1000] = snapshot.value
      dates
    end

    graph_data = [
      {
        key: 'Account Value',
        values: all_dates.sort_by { |date, value| date }
      }
    ]

    if asset.investment?
      all_dates.each { |date, value| all_dates[date] = 0 }

      grouped_contributions = asset.contributions.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)').inject({}) do |dates, contribution|
        dates[contribution.date.end_of_month.to_time.to_i * 1000] = contribution.total
        dates
      end

      graph_data << {
        key: 'Contributions',
        bar: true,
        values: all_dates.merge(grouped_contributions).sort_by { |date, total| date }
      }

      cumulative_contributions = []

      graph_data.last[:values].inject(0) do |sum, pair|
        date, amount = pair
        sum += amount
        cumulative_contributions << [date, sum]
        sum
      end

      graph_data << {
        key: 'Cumulative Contributions',
        values: cumulative_contributions
      }
    end

    data = { 'graph-data' => graph_data.to_json }

    content_tag :div, id: 'asset-line-plus-bar-graph', data: data do
      content_tag :svg
    end
  end

  def assets_stacked_area_graph(assets)
    return if assets.length.zero?

    empty_dates = AssetSnapshot.pluck(:date).uniq.inject({}) do |dates, date|
      dates[date.to_time.to_i * 1000] = 0
      dates
    end

    graph_data = assets.inject([]) do |groups, asset|
      values = asset.snapshots.inject({}) do |points, snapshot|
        points[snapshot.date.to_time.to_i * 1000] = snapshot.value
        points
      end

      groups << {
        key: asset.name,
        values: empty_dates.merge(values).sort_by { |date, value| date }
      }
      groups
    end.to_json

    data = { 'graph-data' => graph_data }

    content_tag :div, id: 'assets-stacked-area-graph', data: data do
      content_tag :svg
    end
  end

  def net_worth_line_with_focus_graph
    history = AssetSnapshot.select([:date, 'SUM(value) AS value']).group(:date).order(:date)
    return if history.length.zero?

    y_max = 0

    graph_data = [
      {
        key: 'Net Worth',
        values: history.inject([]) do |points, snapshot|
          y_max = snapshot.value if snapshot.value > y_max

          points << {
            x: snapshot.date.to_time.to_i * 1000,
            y: snapshot.value
          }

          points
        end
      }
    ].to_json

    data = {
      'graph-data' => graph_data,
      'y-max' => y_max
    }

    content_tag :div, id: 'net-worth-line-with-focus-graph', data: data do
      content_tag :svg
    end
  end
end
