# frozen_string_literal: true

class CreateContributions < ActiveRecord::Migration[5.2]
  def change
    create_table :contributions do |t|
      t.references :financial_asset
      t.integer :amount, default: 0
      t.date :date
      t.string :permalink

      t.timestamps
    end

    add_index :contributions, :permalink, unique: true
  end
end
