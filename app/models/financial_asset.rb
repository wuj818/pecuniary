class FinancialAsset < ActiveRecord::Base
  attr_accessible :name

  validates :name,
    presence: true,
    uniqueness: true

  validates_uniqueness_of :permalink

  before_save :create_permalink

  def to_param
    permalink
  end

  private

  def create_permalink
    self.permalink = name.parameterize
  end
end
