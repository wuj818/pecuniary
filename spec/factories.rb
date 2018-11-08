FactoryBot.define do
  factory :asset_snapshot do
    asset
    date { Date.new 2010, 7, 28 }
    value { 350 }
  end

  factory :contribution do
    asset
    date { Date.new 2010, 7, 28 }
    amount { 350 }
  end

  factory :financial_asset, aliases: [:asset] do
    sequence(:name) { |n| "Asset-#{n}" }
    current_value { 350 }
    investment { true }
  end

  factory :milestone do
    date { Date.new 2010, 7, 28 }
    notes { 'none' }
  end
end
