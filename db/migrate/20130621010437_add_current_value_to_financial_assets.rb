class AddCurrentValueToFinancialAssets < ActiveRecord::Migration
  def change
    add_column :financial_assets, :current_value, :integer, default: 0
  end
end
