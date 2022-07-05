# frozen_string_literal: true

class RemoveExpenses < ActiveRecord::Migration[5.2]
  def up
    drop_table :expenses
  end

  def down
    create_table :expenses do |t|
      t.string :name
      t.integer :cost, default: 0
      t.integer :frequency, default: 12
      t.text :notes
      t.string :permalink

      t.timestamps
    end

    add_index :expenses, :permalink, unique: true
  end
end
