class Snapshot < ApplicationRecord
  belongs_to :asset, class_name: 'FinancialAsset', foreign_key: 'financial_asset_id', inverse_of: 'snapshots'

  validates :asset, presence: true

  validates :date,
    presence: true,
    uniqueness: {
      scope: [:financial_asset_id],
      message: 'has already been taken for this asset'
    }

  validates :permalink, uniqueness: true

  after_initialize -> { self.date ||= Time.zone.now.to_date.end_of_month }

  before_validation :create_permalink

  before_validation :format_date

  after_save :update_asset_current_value

  after_destroy :update_asset_current_value

  def formatted_date
    date&.strftime '%B %Y'
  end

  def to_param
    permalink_was.presence || permalink
  end

  def to_s
    ["#{asset} Snapshot", formatted_date].join ' - '
  end

  private

  def create_permalink
    self.permalink = [asset&.permalink, formatted_date&.parameterize].join '-'
  end

  def format_date
    self.date = date&.end_of_month
  end

  def update_asset_current_value
    current_value = asset.snapshots.order('date DESC').first&.value || 0
    asset.update current_value: current_value
  end
end
