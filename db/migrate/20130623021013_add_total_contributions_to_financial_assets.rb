# frozen_string_literal: true

class AddTotalContributionsToFinancialAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_assets, :total_contributions, :integer, default: 0
  end
end
