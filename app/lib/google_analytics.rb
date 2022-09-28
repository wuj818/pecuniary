# frozen_string_literal: true

class GoogleAnalytics
  class << self
    def measurement_id
      ENV["GA4_MEASUREMENT_ID"].presence
    end

    def enabled?
      measurement_id.present?
    end
  end
end
