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

  def non_investment_asset_line_chart(asset)
    return no_chart_data if asset.snapshots.count.zero?

    query = asset.snapshots.order(:date)

    data = query.each_with_object([]) do |snapshot, array|
      array << [snapshot.date.to_js_time, snapshot.value]
    end

    options = {
      legend: { enabled: false },
      series: [
        {
          type: 'line',
          name: 'Asset Value',
          data: data
        }
      ]
    }

    chart 'non-investment-asset-line-chart', options
  end

  def cumulative_contributions_line_chart
    return no_chart_data if Contribution.count.zero?

    empty_months = end_of_months_since Contribution.minimum(:date)

    query = Contribution.select('date, SUM(amount) AS total').group('STRFTIME("%m-%Y", date)').order(:date)

    contributions = query.each_with_object({}) do |row, hash|
      hash[row.date.end_of_month.to_js_time] = row.total
    end

    sum = 0
    data = empty_months.merge(contributions).map do |date, value|
      [date, sum += value]
    end

    options = {
      legend: { enabled: false },
      series: [
        {
          type: 'line',
          name: 'Cumulative Contributions',
          data: data
        }
      ]
    }

    chart 'cumulative-contributions-line-chart', options
  end

  def contributions_stacked_column_chart
    return if Contribution.count.zero?

    empty_months = end_of_months_since Contribution.minimum(:date)

    query = FinancialAsset.investments.includes(:contributions).order(:name)

    series = query.each_with_object([]) do |asset, array|
      contributions_query = asset.contributions.select('date, SUM(amount) AS total').group('STRFTIME("%m-%Y", date)').order(:date)

      contributions = contributions_query.each_with_object({}) do |contribution, hash|
        hash[contribution.date.end_of_month.to_js_time] = contribution.total
      end

      data = empty_months.merge(contributions).to_a

      array << {
        name: asset.name,
        data: data
      }
    end

    options = {
      chart: { type: 'column' },
      plotOptions: {
        column: {
          stacking: 'normal'
        }
      },
      series: series
    }

    chart 'contributions-stacked-column-chart', options
  end
end
