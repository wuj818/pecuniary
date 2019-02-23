class AddEmployerToContributions < ActiveRecord::Migration[5.2]
  def change
    add_column :contributions, :employer, :boolean, default: false
    add_index :contributions, :employer
  end
end
