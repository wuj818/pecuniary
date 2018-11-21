class Date
  def to_js_time
    to_time.to_i * 1000
  end
end
