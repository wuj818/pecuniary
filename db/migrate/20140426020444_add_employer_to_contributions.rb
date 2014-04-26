class AddEmployerToContributions < ActiveRecord::Migration
  def change
    add_column :contributions, :employer, :boolean, default: false
    add_index :contributions, :employer
  end
end
