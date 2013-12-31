require 'machinist/active_record'

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

FinancialAsset.blueprint do
  name { "Asset-#{sn}" }
  current_value { 350 }
  investment { true }
end

Expense.blueprint do
  name { "Expense-#{sn}" }
  cost { 350 }
  frequency { 12 }
  notes { 'too damn high' }
end
