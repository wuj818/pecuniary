# frozen_string_literal: true

require "hirb"

Hirb.enable

Pry.config.print = proc do |output, value, pry_instance|
  Hirb::View.view_or_page_output(value) || Pry::ColorPrinter.default(output, value, pry_instance)
end

def formatted_env
  color = case Rails.env
          when "production" then :red
          when "staging"    then :yellow
          when "test"       then :blue
          else                   :green
          end

  Pry::Helpers::Text.send(color, Rails.env)
end

default_prompt = Pry::Prompt[:default]

Pry.config.prompt = Pry::Prompt.new(
  "prompt name",
  "prompt description",
  [
    proc { |*a| "[#{formatted_env}] #{default_prompt.wait_proc.call(*a)}" },
    proc { |*a| "[#{formatted_env}] #{default_prompt.incomplete_proc.call(*a)}" }
  ]
)
