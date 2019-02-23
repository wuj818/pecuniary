class AddInvestmentToFinancialAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_assets, :investment, :boolean, default: true
  end
end
