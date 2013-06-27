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
        key: 'Contribution',
        bar: true,
        values: all_dates.merge(grouped_contributions).sort_by { |date, total| date }
      }

      total_contributions = []

      graph_data.last[:values].inject(0) do |sum, pair|
        date, amount = pair
        sum += amount
        total_contributions << [date, sum]
        sum
      end

      graph_data << {
        key: 'Total Contributions',
        values: total_contributions
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

  def contributions_multi_bar_graph
    all_months = all_end_of_months_between Contribution.minimum(:date), Contribution.maximum(:date)

    graph_data = FinancialAsset.investments.includes(:contributions).order(:name).inject([]) do |array, asset|
      contributions = asset.contributions.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)').inject({}) do |hash, contribution|
        hash[contribution.date.end_of_month.to_time.to_i * 1000] = contribution.total
        hash
      end

      contributions = all_months.merge contributions

      array << {
        key: asset.name,
        values: contributions.keys.sort.inject([]) do |hash, month|
          hash << {
            x: month,
            y: contributions[month]
          }

          hash
        end
      }

      array
    end.to_json

    data = { 'graph-data' => graph_data }

    content_tag :div, id: 'contributions-multi-bar-graph', data: data do
      content_tag :svg
    end
  end

  def contributions_line_graph
    return if Contribution.count.zero?

    all_months = all_end_of_months_between Contribution.minimum(:date), Contribution.maximum(:date)

    contributions = Contribution.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)').inject({}) do |hash, contribution|
      hash[contribution.date.end_of_month.to_time.to_i * 1000] = contribution.total
      hash
    end

    contributions = all_months.merge(contributions).sort_by { |date, total| date }
    total_contributions = {}

    contributions.inject(0) do |sum, pair|
      date, amount = pair
      sum += amount
      total_contributions[date] = sum
      sum
    end

    graph_data = [
      {
        key: 'Total Contributions',
        values: total_contributions.inject([]) do |array, pair|
          date, total = pair

          array << {
            x: date,
            y: total
          }

          array
        end
      }
    ]

    data = {
      'graph-data' => graph_data.to_json,
      'y-max' => graph_data.first[:values].last[:y]
    }

    content_tag :div, id: 'contributions-line-graph', data: data do
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

  def all_end_of_months_between(start, stop)
    current, stop = start.end_of_month, stop.end_of_month
    months = []

    until current > stop
      months << current
      current = current.next_month.end_of_month
    end

    months.inject({}) do |hash, month|
      hash[month.to_time.to_i * 1000] = 0
      hash
    end
  end
end
