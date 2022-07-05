# frozen_string_literal: true

class InvestmentsController < ApplicationController
  def history
    investment_ids = FinancialAsset.where(investment: true).select(:id)
    @snapshots = Snapshot.where(financial_asset_id: investment_ids).group_by_month(:date, time_zone: false).sum(:value)
    @snapshots.transform_keys!(&:end_of_month)
    @snapshots.transform_values!(&:to_i)

    current = Contribution.minimum(:date).end_of_month
    stop = Date.current.end_of_month
    months = []

    until current > stop
      months << current
      current = current.next_month.end_of_month
    end

    empty_months = months.index_with { 0 }

    results = Contribution.group_by_month(:date, time_zone: false).sum(:amount)
    results.transform_keys!(&:end_of_month)
    results.transform_values!(&:to_i)

    contributions = empty_months.merge(results)
    @cumulative_contributions = {}

    contributions.keys.sort.inject(0) do |sum, month|
      sum += contributions[month]
      @cumulative_contributions[month] = sum
    end
  end
end
