class CreateFinancialAssets < ActiveRecord::Migration
  def change
    create_table :financial_assets do |t|
      t.string :name

      t.timestamps
    end
  end
end
