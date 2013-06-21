class AssetSnapshot < ActiveRecord::Base
  attr_accessible :date, :permalink, :value

  belongs_to :asset, class_name: 'FinancialAsset', foreign_key: 'financial_asset_id'

  validates_presence_of :asset

  validates :date,
    presence: true,
    uniqueness: {
      scope: [:financial_asset_id],
      message: 'has already been taken for this asset'
    }

  validates_uniqueness_of :permalink

  before_validation :create_permalink

  before_validation :format_date

  def formatted_date
    date.to_time.strftime '%B %Y'
  end

  def to_param
    permalink_was.present? ? permalink_was : permalink
  end

  def to_s
    "#{asset} (#{formatted_date})"
  end

  private

  def create_permalink
    if date.present?
      self.permalink = [asset.permalink, formatted_date.parameterize].join '-'
    end
  end

  def format_date
    self.date = date.end_of_month if date.present?
  end
end
