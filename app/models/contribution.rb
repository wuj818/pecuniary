class Contribution < ApplicationRecord
  belongs_to :asset, class_name: 'FinancialAsset', foreign_key: 'financial_asset_id', inverse_of: 'contributions'

  validates_presence_of :asset

  validates :date,
    presence: true,
    uniqueness: {
      scope: [:financial_asset_id],
      message: 'has already been taken for this asset'
    }

  validates_uniqueness_of :permalink

  validate :investment_asset

  after_initialize lambda { self.date ||= Time.zone.now.to_date }

  before_validation :create_permalink

  after_save :update_asset_total_contributions

  after_destroy :update_asset_total_contributions

  def formatted_date
    date.to_time.strftime '%B %-d, %Y' rescue nil
  end

  def to_param
    permalink_was.presence || permalink
  end

  def to_s
    ["#{asset} Contribution", formatted_date].compact.join ' - '
  end

  private

  def create_permalink
    if date.present? && asset.present?
      self.permalink = [asset.permalink, formatted_date.parameterize].join '-'
    end
  end

  def investment_asset
    if asset.present? && !asset.investment?
      errors.add :base, "#{asset} is not a contributable investment"
    end
  end

  def update_asset_total_contributions
    total_contributions = asset.contributions.sum(:amount)
    asset.update_attribute :total_contributions, total_contributions
  end
end
