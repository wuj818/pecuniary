module ApplicationHelper
  def currency(number)
    number_to_currency number, precision: 0
  end

  def icon(name)
    content_tag :span, nil, class: "glyphicon glyphicon-#{name.to_s.dasherize}"
  end

  def nav_class(controller)
    controller.to_s == controller_name ? 'active' : nil
  end
end
