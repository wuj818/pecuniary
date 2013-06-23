class AddTotalContributionsToFinancialAssets < ActiveRecord::Migration
  def change
    add_column :financial_assets, :total_contributions, :integer, default: 0
  end
end
