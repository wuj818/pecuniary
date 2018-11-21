class FinancialAsset < ApplicationRecord
  has_many :snapshots, class_name: 'AssetSnapshot', dependent: :destroy, inverse_of: 'asset'

  has_many :contributions, dependent: :destroy, inverse_of: 'asset'

  validates :name,
    presence: true,
    uniqueness: true

  validates :permalink, uniqueness: true

  before_validation :create_permalink

  after_update :update_association_permalinks, if: :saved_change_to_name?

  scope :investments, -> { where(investment: true) }
  scope :non_investments, -> { where(investment: false) }

  class << self
    def net_worth
      sum :current_value
    end
  end

  def total_return
    (current_value - total_contributions.to_f) / total_contributions * 100
  end

  def to_param
    permalink_was.presence || permalink
  end

  def to_s
    name
  end

  private

  def create_permalink
    self.permalink = name.parameterize if name.present?
  end

  def update_association_permalinks
    contributions.each(&:save)
    snapshots.each(&:save)
  end
end
