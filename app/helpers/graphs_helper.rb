module GraphsHelper
  # generic graphs

  def graph(options)
    css_class = "#{options[:type]}-graph"
    id = [options[:id_prefix], css_class].join '-'

    content_tag :div, id: id, class: css_class, data: options[:data] do
      content_tag :svg
    end
  end

  def line_graph(options)
    # data format:
    # [
    #   {
    #     key: string,
    #     bar: boolean,
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

  def stacked_area_graph(options)
    # data format:
    # same as line plus bar graph

    graph options.merge(type: 'stacked-area')
  end

  # specific graphs

  def assets_stacked_area_graph
    return if AssetSnapshot.count.zero?

    empty_months = end_of_months_since AssetSnapshot.minimum(:date)

    query = FinancialAsset.includes(:snapshots).order(:name)

    graph_data = query.inject([]) do |array, asset|
      values = asset.snapshots.inject({}) do |hash, snapshot|
        hash[snapshot.date.to_js_time] = snapshot.value
        hash
      end

      values = empty_months.merge(values).sort_by { |month, value| month }

      array << { key: asset.name, values: values }
    end.to_json

    data = { 'graph-data' => graph_data }

    stacked_area_graph id_prefix: 'assets', data: data
  end

  def contributions_multi_bar_graph
    return if Contribution.count.zero?

    empty_months = end_of_months_since Contribution.minimum(:date)

    query = FinancialAsset.investments.includes(:contributions).order(:name)

    graph_data = query.inject([]) do |array, asset|
      query = asset.contributions.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)')

      contributions = query.inject({}) do |hash, contribution|
        hash[contribution.date.end_of_month.to_js_time] = contribution.total
        hash
      end

      contributions = empty_months.merge contributions

      values = contributions.keys.sort.inject([]) do |hash, month|
        hash << { x: month, y: contributions[month] }
      end

      array << { key: asset.name, values: values }
    end.to_json

    data = { 'graph-data' => graph_data }

    multi_bar_graph id_prefix: 'contributions', data: data
  end

  def contributions_line_graph
    return if Contribution.count.zero?

    empty_months = end_of_months_since Contribution.minimum(:date)

    query = Contribution.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)')

    contributions = query.inject({}) do |hash, contribution|
      hash[contribution.date.end_of_month.to_js_time] = contribution.total
      hash
    end

    contributions = empty_months.merge contributions
    cumulative_contributions = {}

    contributions.keys.sort.inject(0) do |sum, month|
      sum += contributions[month]
      cumulative_contributions[month] = sum
    end

    values = cumulative_contributions.inject([]) do |array, pair|
      month, total = pair
      array << { x: month, y: total }
    end

    graph_data = [ { key: 'Cumulative Contributions', values: values } ]

    data = {
      'graph-data' => graph_data.to_json,
      'y-max' => graph_data.first[:values].last[:y]
    }

    line_graph id_prefix: 'contributions', data: data
  end

  def investment_asset_line_plus_bar_graph(asset)
    return if asset.snapshots.count.zero?

    # snapshots

    all_months = asset.snapshots.order(:date).inject({}) do |hash, snapshot|
      hash[snapshot.date.to_js_time] = snapshot.value
      hash
    end

    values = all_months.sort_by { |month, value| month }

    graph_data = [ { key: 'Asset Value', values: values } ]

    # contributions

    all_months.each { |month, value| all_months[month] = 0 }

    query = asset.contributions.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)')

    grouped_contributions = query.inject({}) do |hash, contribution|
      hash[contribution.date.end_of_month.to_js_time] = contribution.total
      hash
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

  def net_worth_line_with_focus_graph
    return if AssetSnapshot.count.zero?

    query = AssetSnapshot.select([:date, 'SUM(value) AS value']).group(:date).order(:date)

    values = query.inject([]) do |array, snapshot|
      array << { x: snapshot.date.to_js_time, y: snapshot.value }
    end

    graph_data = [ { key: 'Net Worth', values: values } ].to_json

    data = {
      'graph-data' => graph_data,
      'y-max' => values.map { |v| v[:y] }.max
    }

    line_with_focus_graph id_prefix: 'net-worth', data: data
  end

  def non_investment_asset_line_graph(asset)
    return if asset.snapshots.count.zero?

    values = asset.snapshots.order(:date).inject([]) do |array, snapshot|
      array << { x: snapshot.date.to_js_time, y: snapshot.value }
    end

    graph_data = [ { key: 'Asset Value', values: values } ]

    data = {
      'graph-data' => graph_data.to_json,
      'y-max' => values.map { |v| v[:y] }.max
    }

    line_graph id_prefix: 'asset', data: data
  end

  # helpers

  def end_of_months_since(start)
    current, stop = start.end_of_month, Time.zone.now.to_date.end_of_month
    months = []

    until current > stop
      months << current
      current = current.next_month.end_of_month
    end

    months.inject({}) do |hash, month|
      hash[month.to_js_time] = 0
      hash
    end
  end
end
