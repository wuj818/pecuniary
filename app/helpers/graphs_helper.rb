module GraphsHelper
  # generic graphs

  def graph(options)
    css_class = "#{options[:type]}-graph"
    id = [options[:id_prefix], css_class].join '-'

    tag.div id: id, class: css_class, data: options[:data] do
      tag.svg
    end
  end

  def cumulative_line_graph(options)
    # data format:
    # [
    #   {
    #     key: string,
    #     bar: boolean,
    #     values: [
    #       [js_time, y_value],
    #     ]
    #   },
    # ]

    graph options.merge(type: 'cumulative-line')
  end

  def line_graph(options)
    # data format:
    # [
    #   {
    #     key: string,
    #     values: [
    #       { x: js_time, y: value },
    #     ]
    #   },
    # ]

    graph options.merge(type: 'line')
  end

  def line_plus_bar_graph(options)
    # data format:
    # [
    #   {
    #     key: string,
    #     bar: boolean,
    #     values: [
    #       [js_time, y_value],
    #     ]
    #   },
    # ]

    graph options.merge(type: 'line-plus-bar')
  end

  def line_with_focus_graph(options)
    # data format:
    # same as line graph

    graph options.merge(type: 'line-with-focus')
  end

  def multi_bar_graph(options)
    # data format:
    # same as line graph

    graph options.merge(type: 'multi-bar')
  end

  # specific graphs

  def investment_asset_line_plus_bar_graph(asset)
    return if asset.snapshots.count.zero?

    # snapshots

    all_months = asset.snapshots.order(:date).each_with_object({}) do |snapshot, hash|
      hash[snapshot.date.to_js_time] = snapshot.value
    end

    values = all_months.sort_by { |month, value| month }

    graph_data = [{ key: 'Asset Value', values: values }]

    # contributions

    all_months.each { |month, value| all_months[month] = 0 }

    query = asset.contributions.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)')

    grouped_contributions = query.each_with_object({}) do |contribution, hash|
      hash[contribution.date.end_of_month.to_js_time] = contribution.total
    end

    values = all_months.merge(grouped_contributions).sort_by { |month, total| month }

    graph_data << { key: 'Contribution', bar: true, values: values }

    cumulative_contributions = []

    graph_data.last[:values].sort.inject(0) do |sum, pair|
      month, total = pair
      sum += total
      cumulative_contributions << [month, sum]
      sum
    end

    graph_data << {
      key: 'Cumulative Contributions',
      values: cumulative_contributions
    }

    data = { 'graph-data' => graph_data.to_json }

    line_plus_bar_graph id_prefix: 'asset', data: data
  end

  def investment_history_line_graph(snapshots, cumulative_contributions)
    graph_data = [
      {
        key: 'Cumulative Contributions',
        area: true,
        values: cumulative_contributions.keys.inject([]) do |array, date|
          array << {
            x: date.to_js_time,
            y: cumulative_contributions[date]
          }
        end
      },
      {
        key: 'Investment Value',
        values: snapshots.keys.inject([]) do |array, date|
          array << {
            x: date.to_js_time,
            y: snapshots[date]
          }
        end
      }
    ]

    data = {
      'graph-data' => graph_data.to_json,
      'y-max' => [snapshots.values.max, cumulative_contributions.values.max].max,
      'show-legend' => true
    }

    line_graph id_prefix: 'investment-history', data: data
  end

  def investment_history_cumulative_line_graph(snapshots, cumulative_contributions)
    graph_data = [
      {
        key: 'Total Return',
        values: snapshots.keys.sort.inject([]) do |array, date|
          value = snapshots[date]
          contributions = cumulative_contributions[date]
          gain = (value - contributions) / contributions.to_f

          array << [date.to_js_time, gain]
        end
      }
    ]

    data = {
      'graph-data' => graph_data.to_json
    }

    cumulative_line_graph id_prefix: 'investment-history', data: data
  end

  # helpers

  def end_of_months_since(start)
    current = start.end_of_month
    stop = Time.zone.now.to_date.end_of_month
    months = []

    until current > stop
      months << current
      current = current.next_month.end_of_month
    end

    months.each_with_object({}) do |month, hash|
      hash[month.to_js_time] = 0
    end
  end
end
