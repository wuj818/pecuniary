class InvestmentsController < ApplicationController
  def history
    start = Contribution.minimum :date
    @snapshots = AssetSnapshot.select('date, SUM(value) AS total').where('investment = ?', true).joins(:asset).group(:date).having('date >= ?', start).order(:date)
    @snapshots = @snapshots.each_with_object({}) do |snapshot, hash|
      hash[snapshot.date] = snapshot.total
    end

    current = start.end_of_month
    stop = Time.zone.now.to_date.end_of_month
    months = []

    until current > stop
      months << current
      current = current.next_month.end_of_month
    end

    empty_months = months.each_with_object({}) do |month, hash|
      hash[month] = 0
    end

    query = Contribution.select('date, SUM(amount) AS total').group('strftime("%m-%Y", date)').order(:date)

    contributions = query.each_with_object({}) do |contribution, hash|
      hash[contribution.date.end_of_month] = contribution.total
    end

    contributions = empty_months.merge contributions
    @cumulative_contributions = {}

    contributions.keys.sort.inject(0) do |sum, month|
      sum += contributions[month]
      @cumulative_contributions[month] = sum
    end
  end
end
