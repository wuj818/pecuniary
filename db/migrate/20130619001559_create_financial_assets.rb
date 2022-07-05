# frozen_string_literal: true

class CreateFinancialAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_assets do |t|
      t.string :name

      t.timestamps
    end
  end
end
