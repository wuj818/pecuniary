class CreateAssetSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :asset_snapshots do |t|
      t.references :financial_asset
      t.integer :value, default: 0
      t.date :date
      t.string :permalink

      t.timestamps
    end

    add_index :asset_snapshots, :permalink, unique: true
  end
end
