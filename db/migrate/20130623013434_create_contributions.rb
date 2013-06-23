class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.references :financial_asset
      t.integer :amount, default: 0
      t.date :date
      t.string :permalink

      t.timestamps
    end

    add_index :contributions, :financial_asset_id
    add_index :contributions, :permalink, unique: true
  end
end
