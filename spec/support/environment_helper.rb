# frozen_string_literal: true

module EnvironmentHelper
  def stub_env(stubs = {})
    init_stubs unless env_stubbed?

    stubs.each { |key, value| add_stub(key, value) }
  end

  private

  STUBBED_KEY = "__STUBBED__"

  def init_stubs
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:fetch).and_call_original

    add_stub(STUBBED_KEY, true)
  end

  def env_stubbed?
    ENV.key?(STUBBED_KEY)
  end

  def add_stub(key, value)
    key = key.to_s
    value = value.to_s unless value.nil?

    stub_indexes(key, value)
    stub_fetches(key, value)
  end

  def stub_indexes(key, value)
    allow(ENV).to receive(:[]).with(key).and_return(value)
  end

  def stub_fetches(key, value)
    stub = allow(ENV).to receive(:fetch).with(key)

    if value.nil?
      stub.and_raise(KeyError, "key not found: \"#{key}\"")
    else
      stub.and_return(value)
    end

    allow(ENV).to receive(:fetch).with(key, anything) do |_key, default_value|
      value || default_value
    end
  end
end

RSpec.configure { |config| config.include EnvironmentHelper }
