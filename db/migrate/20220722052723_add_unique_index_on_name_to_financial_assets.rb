class AddUniqueIndexOnNameToFinancialAssets < ActiveRecord::Migration[7.0]
  def change
    add_index :financial_assets, :name, unique: true
  end
end
