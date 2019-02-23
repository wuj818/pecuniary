class AddCurrentValueToFinancialAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_assets, :current_value, :integer, default: 0
  end
end
