module GraphsHelper
  # generic graphs

  def graph(options)
    css_class = "#{options[:type]}-graph"
    id = [options[:id_prefix], css_class].join '-'

    tag.div id: id, class: css_class, data: options[:data] do
      tag.svg
    end
  end

  def cumulative_line_graph(options)
    # data format:
    # [
    #   {
    #     key: string,
    #     bar: boolean,
    #     values: [
    #       [js_time, y_value],
    #     ]
    #   },
    # ]

    graph options.merge(type: 'cumulative-line')
  end

  def line_graph(options)
    # data format:
    # [
    #   {
    #     key: string,
    #     values: [
    #       { x: js_time, y: value },
    #     ]
    #   },
    # ]

    graph options.merge(type: 'line')
  end

  def line_plus_bar_graph(options)
    # data format:
    # [
    #   {
    #     key: string,
    #     bar: boolean,
    #     values: [
    #       [js_time, y_value],
    #     ]
    #   },
    # ]

    graph options.merge(type: 'line-plus-bar')
  end

  def line_with_focus_graph(options)
    # data format:
    # same as line graph

    graph options.merge(type: 'line-with-focus')
  end

  def multi_bar_graph(options)
    # data format:
    # same as line graph

    graph options.merge(type: 'multi-bar')
  end

  # helpers

  def end_of_months_since(start)
    current = start.end_of_month
    stop = Time.zone.now.to_date.end_of_month
    months = []

    until current > stop
      months << current
      current = current.next_month.end_of_month
    end

    months.each_with_object({}) do |month, hash|
      hash[month.to_js_time] = 0
    end
  end
end
