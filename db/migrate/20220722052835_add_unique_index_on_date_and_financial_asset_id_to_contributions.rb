class AddUniqueIndexOnDateAndFinancialAssetIdToContributions < ActiveRecord::Migration[7.0]
  def change
    add_index :contributions, [:date, :financial_asset_id], unique: true
  end
end
