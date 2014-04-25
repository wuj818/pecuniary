module ApplicationHelper
  def currency(number)
    number_to_currency number, precision: 0
  end

  def financial_independence_progress
    net_worth = FinancialAsset.net_worth
    goal = Figaro.env.fi_goal || 1_000_000

    progress = (net_worth / goal.to_f * 100).round 2
    progress = 100 if progress > 100
    color = financial_independence_progress_color progress
    percentage = "#{progress}%"

    content_tag :div, class: 'progress progress-striped active' do
      content_tag :div, class: "progress-bar #{color}", style: "width: #{percentage}" do
        content_tag :strong, percentage, style: 'color: black;'
      end
    end
  end

  def financial_independence_progress_color(progress)
    color = if progress == 100
      :success
    elsif progress >= 100 / 3.0 * 2
      :info
    elsif progress >= 100 / 3.0
      :warning
    else
      :danger
    end

    "progress-bar-#{color}"
  end

  def icon(names = 'flag', options = {})
    classes = [:fa].concat names.to_s.split.map { |name| "fa-#{name}" }

    classes << options.delete(:class)
    text = options.delete :text
    icon = content_tag :i, nil, options.merge(class: classes.compact)

    return icon if text.blank?

    result = [icon, ERB::Util.html_escape(text)]
    safe_join (options.delete(:text_first) ? result.reverse : result), ' '
  end

  def kramdown(text)
    Kramdown::Document.new(text).to_html.html_safe
  end

  def nav_class(controller)
    controller.to_s == controller_name ? :active : nil
  end
end
