module Charts::RenderHelper
  def chart(id, options)
    tag.div id: id, class: 'chart', data: { options: options.to_json }
  end

  def no_chart_data
    tag.code 'no chart data...'
  end
end
