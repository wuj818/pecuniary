# frozen_string_literal: true

FactoryBot.define do
  factory :snapshot do
    asset
    date { generate :date }
    value { 350 }

    factory :invalid_snapshot do
      value { "not a number" }
    end
  end

  factory :contribution do
    asset
    date { generate :date }
    amount { 350 }
    employer { false }
  end

  factory :financial_asset, aliases: [:asset] do
    sequence(:name) { |n| "Asset-#{n}" }
    current_value { 350 }
    investment { true }
  end

  factory :milestone do
    date { generate :date }
    notes { "none" }
  end

  sequence :date do |n|
    start = Date.new 2010, 7, 28
    stop = Time.zone.today

    (start..stop).to_a[n]
  end
end
