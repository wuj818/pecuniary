require 'machinist/active_record'

FinancialAsset.blueprint do
  name { "Asset-#{sn}" }
  current_value { 350 }
end

AssetSnapshot.blueprint do
  asset
  date { Date.new 2010, 7, 28 }
  value { 350 }
end

Contribution.blueprint do
  asset
  date { Date.new 2010, 7, 28}
  amount { 350 }
end
