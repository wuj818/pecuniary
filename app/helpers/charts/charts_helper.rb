# frozen_string_literal: true

module Charts
  module ChartsHelper
    def net_worth_line_chart
      return no_chart_data if Snapshot.count.zero?

      query = Snapshot.select([:date, "SUM(value) AS value"]).group(:date).order(:date)

      data = query.each_with_object([]) do |row, array|
        array << [row.date.to_js_time, row.value]
      end

      series = { name: "Net Worth", data: data }

      line_chart "net-worth", series
    end

    def assets_stacked_area_chart
      return no_chart_data if Snapshot.count.zero?

      empty_months = end_of_months_since Snapshot.minimum(:date)

      query = FinancialAsset.order(:name)

      series = query.each_with_object([]) do |asset, array|
        snapshots_query = asset.snapshots.select([:date, "SUM(value) AS value"]).group(:date).order(:date)

        snapshots = snapshots_query.each_with_object({}) do |row, points|
          points[row.date.to_js_time] = row.value
        end

        data = empty_months.merge(snapshots).to_a

        array << {
          name: asset.name,
          data: data
        }
      end

      options = {
        chart: { type: "area" },
        series: series
      }

      chart "assets-stacked-area-chart", options
    end

    def non_investment_asset_line_chart(asset)
      return no_chart_data if asset.snapshots.count.zero?

      query = asset.snapshots.order(:date)

      data = query.each_with_object([]) do |snapshot, array|
        array << [snapshot.date.to_js_time, snapshot.value]
      end

      series = { name: "Total Value", data: data }

      line_chart "non-investment-asset", series
    end

    def cumulative_contributions_line_chart
      return no_chart_data if Contribution.count.zero?

      empty_months = end_of_months_since(Contribution.minimum(:date))

      contributions = Contribution.group_by_month(:date, time_zone: false).sum(:amount)
      contributions.transform_keys! { |date| date.end_of_month.to_js_time }
      contributions.transform_values!(&:to_i)

      sum = 0
      data = empty_months.merge(contributions).map do |date, value|
        [date, sum += value]
      end

      series = { name: "Cumulative Contributions", data: data }

      line_chart "cumulative-contributions", series
    end

    def contributions_stacked_column_chart
      return no_chart_data if Contribution.count.zero?

      empty_months = end_of_months_since(Contribution.minimum(:date))

      query = FinancialAsset.where(investment: true).includes(:contributions).order(:name)

      series = query.each_with_object([]) do |asset, array|
        contributions = asset.contributions.group_by_month(:date, time_zone: false).sum(:amount)
        contributions.transform_keys! { |date| date.end_of_month.to_js_time }
        contributions.transform_values!(&:to_i)

        data = empty_months.merge(contributions).to_a

        array << {
          name: asset.name,
          data: data
        }
      end

      options = {
        chart: { type: "column" },
        plotOptions: {
          column: {
            stacking: "normal"
          }
        },
        series: series
      }

      chart "contributions-stacked-column-chart", options
    end

    def investment_asset_area_chart(asset)
      return no_chart_data if asset.snapshots.count.zero?

      snapshots = asset.snapshots.order(:date).each_with_object({}) do |snapshot, data|
        data[snapshot.date.to_js_time] = snapshot.value
      end

      empty_months = snapshots.keys.each_with_object({}) do |month, data|
        data[month] = 0
      end

      contributions = asset.contributions.group_by_month(:date, time_zone: false).sum(:amount)
      contributions.transform_keys! { |date| date.end_of_month.to_js_time }
      contributions.transform_values!(&:to_i)

      contributions = empty_months.merge(contributions)

      cumulative_contributions = {}

      contributions.keys.sort.inject(0) do |sum, month|
        sum += contributions[month]
        cumulative_contributions[month] = sum
      end

      investment_area_chart "investment-asset-area-chart", snapshots.to_a, cumulative_contributions.to_a
    end

    def investment_assets_area_chart(snapshots, cumulative_contributions)
      snapshots = snapshots.transform_keys(&:to_js_time)
      cumulative_contributions = cumulative_contributions.transform_keys(&:to_js_time)

      investment_area_chart "investment-assets-area-chart", snapshots.to_a, cumulative_contributions.to_a
    end

    def investment_area_chart(id, snapshots, cumulative_contributions)
      options = {
        chart: { type: "area" },
        plotOptions: {
          area: {
            stacking: nil
          }
        },
        series: [
          {
            name: "Total Value",
            data: snapshots
          },
          {
            name: "Cumulative Contributions",
            fillOpacity: 0.25,
            data: cumulative_contributions
          }
        ]
      }

      chart id, options
    end

    def investment_asset_performance_line_chart(asset)
      return no_chart_data if asset.snapshots.count.zero?

      snapshots = asset.snapshots.order(:date).each_with_object({}) do |snapshot, hash|
        hash[snapshot.date.to_js_time] = snapshot.value
      end

      empty_months = snapshots.keys.each_with_object({}) do |month, hash|
        hash[month] = 0
      end

      contributions = asset.contributions.group_by_month(:date, time_zone: false).sum(:amount)
      contributions.transform_keys! { |date| date.end_of_month.to_js_time }
      contributions.transform_values!(&:to_i)

      contributions = empty_months.merge(contributions)

      cumulative_contributions = {}

      contributions.keys.sort.inject(0) do |sum, month|
        sum += contributions[month]
        cumulative_contributions[month] = sum
      end

      investment_performance_line_chart "investment-asset-performance", snapshots, cumulative_contributions
    end

    def investment_assets_performance_line_chart(snapshots, cumulative_contributions)
      snapshots = snapshots.transform_keys(&:to_js_time)
      cumulative_contributions = cumulative_contributions.transform_keys(&:to_js_time)

      investment_performance_line_chart "investment-assets-performance", snapshots, cumulative_contributions
    end

    def investment_performance_line_chart(id, snapshots, cumulative_contributions)
      data = snapshots.keys.each_with_object([]) do |month, array|
        value = snapshots[month]
        contributions = cumulative_contributions[month]
        gain = (value - contributions) / contributions.to_f * 100

        array << [month, gain]
      end

      series = { name: "Total Return", data: data }

      custom_options = {
        title: { text: "Performance" },
        yAxis: { labels: { format: "{value:,.2f}%" } },
        tooltip: {
          valueDecimals: 2,
          valuePrefix: nil,
          valueSuffix: "%"
        }
      }

      line_chart id, series, custom_options
    end

    def investment_asset_contributions_column_chart(asset)
      return no_chart_data if asset.contributions.count.zero?

      empty_months = end_of_months_since(asset.contributions.minimum(:date))

      contributions = asset.contributions.group_by_month(:date, time_zone: false).sum(:amount)
      contributions.transform_keys! { |date| date.end_of_month.to_js_time }
      contributions.transform_values!(&:to_i)

      data = empty_months.merge(contributions).to_a

      options = {
        title: { text: "Contributions" },
        legend: { enabled: false },
        chart: { type: "column" },
        series: [
          {
            name: "Contributions",
            data: data
          }
        ]
      }

      chart "investment-asset-contributions-column-chart", options
    end

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
end
