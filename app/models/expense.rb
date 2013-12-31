class Expense < ActiveRecord::Base
  FREQUENCIES = {
    'Monthly' => 12,
    'Yearly' => 1
  }

  attr_accessible :cost, :frequency, :name, :notes

  before_validation :create_permalink

  validates :cost,
    numericality: {
      greater_than: 0
    }

  validates :frequency,
    inclusion: {
      in: FREQUENCIES.values,
      message: 'is not valid'
    }

  validates :name,
    presence: true,
    uniqueness: true

  validates_uniqueness_of :permalink

  def frequency_label
    FREQUENCIES.invert[frequency]
  end

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
end
