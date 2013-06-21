module ApplicationHelper
  def currency(number)
    amount = "$#{number_with_delimiter number.abs}"
    number < 0 ? "-#{amount}" : amount
  end
end
