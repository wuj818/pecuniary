module ApplicationHelper
  def currency(number)
    amount = "$#{number_with_delimiter number.abs}"
    number < 0 ? "-#{amount}" : amount
  end

  def icon(name)
    content_tag :span, nil, class: "glyphicon glyphicon-#{name.to_s.dasherize}"
  end

  def nav_class(controller)
    controller.to_s == controller_name ? 'active' : nil
  end
end
