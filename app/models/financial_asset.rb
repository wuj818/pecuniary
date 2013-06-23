class FinancialAsset < ActiveRecord::Base
  attr_accessible :name

  has_many :snapshots, class_name: 'AssetSnapshot', dependent: :destroy

  has_many :contributions, dependent: :destroy

  validates :name,
    presence: true,
    uniqueness: true

  validates_uniqueness_of :permalink

  before_validation :create_permalink

  after_update :update_association_permalinks

  def to_param
    permalink_was.present? ? permalink_was : permalink
  end

  def to_s
    name
  end

  private

  def create_permalink
    self.permalink = name.parameterize if name.present?
  end

  def update_association_permalinks
    if name_changed?
      contributions.each &:save
      snapshots.each &:save
    end
  end
end
