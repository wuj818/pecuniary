module GraphsHelper
  def asset_line_graph(snapshots)
    graph_data = [
      {
        key: 'Value',
        values: snapshots.inject([]) do |points, snapshot|
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
      'y-max' => snapshots.maximum(:value),
    }

    content_tag :div, id: 'asset-line-graph', data: data do
      content_tag :svg
    end
  end
end
