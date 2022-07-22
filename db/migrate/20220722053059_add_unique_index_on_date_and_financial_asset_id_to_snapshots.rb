class AddUniqueIndexOnDateAndFinancialAssetIdToSnapshots < ActiveRecord::Migration[7.0]
  def change
    add_index :snapshots, [:date, :financial_asset_id], unique: true
  end
end
