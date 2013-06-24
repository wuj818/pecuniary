class AddInvestmentToFinancialAssets < ActiveRecord::Migration
  def change
    add_column :financial_assets, :investment, :boolean, default: true
  end
end
