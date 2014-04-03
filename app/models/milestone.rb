class Milestone < ActiveRecord::Base
  attr_accessible :date, :notes, :permalink

  validates :date,
    presence: true,
    uniqueness: true

  validates_presence_of :notes

  after_initialize lambda { self.date ||= Time.zone.now.to_date }

  before_validation :create_permalink

  def formatted_date
    date.to_time.strftime '%B %-d, %Y' rescue nil
  end

  def to_param
    permalink_was.present? ? permalink_was : permalink
  end

  def to_s
    formatted_date
  end

  private

  def create_permalink
    if date.present?
      self.permalink = formatted_date.parameterize
    end
  end
end
