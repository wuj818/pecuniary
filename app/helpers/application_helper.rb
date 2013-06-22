module ApplicationHelper
  def nav_class(controller)
    controller.to_s == controller_name ? 'active' : nil
  end

  def currency(number)
    amount = "$#{number_with_delimiter number.abs}"
    number < 0 ? "-#{amount}" : amount
  end
end
