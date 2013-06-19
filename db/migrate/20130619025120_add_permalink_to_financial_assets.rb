class AddPermalinkToFinancialAssets < ActiveRecord::Migration
  def change
    add_column :financial_assets, :permalink, :string
    add_index :financial_assets, :permalink, unique: true
  end
end
