class Milestone < ApplicationRecord
  acts_as_taggable

  validates :date,
    presence: true,
    uniqueness: true

  validates :notes, presence: true

  after_initialize -> { self.date ||= Time.zone.now.to_date }

  before_validation :create_permalink

  def formatted_date
    date.to_time.strftime '%B %-d, %Y' rescue nil
  end

  def to_param
    permalink_was.presence || permalink
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
