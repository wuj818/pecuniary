module GraphsHelper
  def asset_line_graph(snapshots)
    y_max = 0

    graph_data = [
      {
        key: 'Value',
        values: snapshots.inject([]) do |points, snapshot|
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
      'y-max' => y_max,
    }

    content_tag :div, id: 'asset-line-graph', data: data do
      content_tag :svg
    end
  end

  def assets_stacked_area_graph(assets)
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
      'y-max' => y_max,
    }

    content_tag :div, id: 'net-worth-line-with-focus-graph', data: data do
      content_tag :svg
    end
  end
end
