class InvestmentsController < ApplicationController
  def history
    start = Contribution.minimum :date
    @snapshots = AssetSnapshot.select('date, SUM(value) AS total').where('investment = ?', true).joins(:asset).group(:date).having('date >= ?', start).order(:date)

    current, stop = start.end_of_month, Time.zone.now.to_date.end_of_month
    months = []

    until current > stop
      months << current
      current = current.next_month.end_of_month
    end

    empty_months = months.inject({}) do |hash, month|
      hash[month] = 0
      hash
    end

    query = Contribution.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)').order(:date)

    contributions = query.inject({}) do |hash, contribution|
      hash[contribution.date.end_of_month] = contribution.total
      hash
    end

    contributions = empty_months.merge contributions
    @cumulative_contributions = {}

    contributions.keys.sort.inject(0) do |sum, month|
      sum += contributions[month]
      @cumulative_contributions[month] = sum
    end
  end
end
