module Charts
  module LineHelper
    def line_chart(id, series, custom_options = {})
      id = [id, "line-chart"].join "-"

      series = [series] unless series.is_a? Array

      options = {
        legend: { enabled: false },
        series: series
      }.deep_merge custom_options

      chart id, options
    end
  end
end
