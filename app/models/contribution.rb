class Contribution < ActiveRecord::Base
  attr_accessible :amount, :date, :permalink

  belongs_to :asset, class_name: 'FinancialAsset', foreign_key: 'financial_asset_id'

  validates_presence_of :asset

  validates :amount,
    numericality: { greater_than: 0 }

  validates :date,
    presence: true,
    uniqueness: {
      scope: [:financial_asset_id],
      message: 'has already been taken for this asset'
    }

  validates_uniqueness_of :permalink

  before_validation :create_permalink

  after_save :update_asset_total_contributions

  after_destroy :update_asset_total_contributions

  def formatted_date
    date.to_time.strftime '%B %d %Y'
  end

  def to_param
    permalink_was.present? ? permalink_was : permalink
  end

  def to_s
    ["#{asset} Contribution", formatted_date].join ' - '
  end

  private

  def create_permalink
    if date.present?
      self.permalink = [asset.permalink, formatted_date.parameterize].join '-'
    end
  end

  def update_asset_total_contributions
    total_contributions = asset.contributions.sum(:amount)
    asset.update_attribute :total_contributions, total_contributions
  end
end
