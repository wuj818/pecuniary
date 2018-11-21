class AssetSnapshot < ApplicationRecord
  belongs_to :asset, class_name: 'FinancialAsset', foreign_key: 'financial_asset_id', inverse_of: 'snapshots'

  validates_presence_of :asset

  validates :date,
    presence: true,
    uniqueness: {
      scope: [:financial_asset_id],
      message: 'has already been taken for this asset'
    }

  validates_uniqueness_of :permalink

  after_initialize lambda { self.date ||= Time.zone.now.to_date.end_of_month }

  before_validation :create_permalink

  before_validation :format_date

  after_save :update_asset_current_value

  after_destroy :update_asset_current_value

  def formatted_date
    date.to_time.strftime '%B %Y' rescue nil
  end

  def to_param
    permalink_was.present? ? permalink_was : permalink
  end

  def to_s
    ["#{asset} Snapshot", formatted_date].compact.join ' - '
  end

  private

  def create_permalink
    if date.present? && asset.present?
      self.permalink = [asset.permalink, formatted_date.parameterize].join '-'
    end
  end

  def format_date
    self.date = date.end_of_month if date.present?
  end

  def update_asset_current_value
    current_value = asset.snapshots.order('date DESC').first.value rescue 0
    asset.update_attribute :current_value, current_value
  end
end
