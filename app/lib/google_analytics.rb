# frozen_string_literal: true

class GoogleAnalytics
  class << self
    def web_stream_measurement_id
      ENV["GA4_WEB_STREAM_MEASUREMENT_ID"].presence
    end

    def enabled?
      web_stream_measurement_id.present?
    end
  end
end
