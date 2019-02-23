class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.date :date
      t.text :notes
      t.string :permalink

      t.timestamps
    end

    add_index :milestones, :date, unique: true
    add_index :milestones, :permalink, unique: true
  end
end
