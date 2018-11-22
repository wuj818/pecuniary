class Contribution < ApplicationRecord
  belongs_to :asset, class_name: 'FinancialAsset', foreign_key: 'financial_asset_id', inverse_of: 'contributions'

  validates :asset, presence: true

  validates :date,
    presence: true,
    uniqueness: {
      scope: [:financial_asset_id],
      message: 'has already been taken for this asset'
    }

  validates :permalink, uniqueness: true

  validate :investment_asset

  after_initialize -> { self.date ||= Time.zone.now.to_date }

  before_validation :create_permalink

  after_save :update_asset_total_contributions

  after_destroy :update_asset_total_contributions

  def formatted_date
    date&.to_time&.strftime '%B %-d, %Y'
  end

  def to_param
    permalink_was.presence || permalink
  end

  def to_s
    ["#{asset} Contribution", formatted_date].join ' - '
  end

  private

  def create_permalink
    self.permalink = [asset&.permalink, formatted_date&.parameterize].join '-'
  end

  def investment_asset
    return if asset&.investment?

    errors.add :base, "#{asset} is not a contributable investment"
  end

  def update_asset_total_contributions
    total_contributions = asset.contributions.sum :amount
    asset.update total_contributions: total_contributions
  end
end
