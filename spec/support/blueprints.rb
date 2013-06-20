require 'machinist/active_record'

FinancialAsset.blueprint do
  name { "Asset-#{sn}" }
end
