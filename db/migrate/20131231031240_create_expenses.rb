class CreateExpenses < ActiveRecord::Migration
  def change
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
