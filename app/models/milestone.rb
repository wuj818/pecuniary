# frozen_string_literal: true

class Milestone < ApplicationRecord
  acts_as_taggable

  validates :date,
            presence: true,
            uniqueness: true

  validates :notes, presence: true

  after_initialize -> { self.date ||= Time.zone.now.to_date }

  before_validation :create_permalink

  def formatted_date
    date&.strftime "%B %-d, %Y"
  end

  def to_param
    permalink_was.presence || permalink
  end

  def to_s
    formatted_date
  end

  private

  def create_permalink
    self.permalink = formatted_date&.parameterize
  end
end
