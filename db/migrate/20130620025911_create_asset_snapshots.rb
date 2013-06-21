class CreateAssetSnapshots < ActiveRecord::Migration
  def change
    create_table :asset_snapshots do |t|
      t.references :financial_asset
      t.integer :value, default: 0
      t.date :date
      t.string :permalink

      t.timestamps
    end

    add_index :asset_snapshots, :financial_asset_id
    add_index :asset_snapshots, :permalink, unique: true
  end
end
