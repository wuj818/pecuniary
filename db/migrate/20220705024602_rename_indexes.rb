class RenameIndexes < ActiveRecord::Migration[7.0]
  def change
    rename_index :contributions, "idx_33855_index_contributions_on_employer", "index_contributions_on_employer"
    rename_index :contributions, "idx_33855_index_contributions_on_financial_asset_id", "index_contributions_on_financial_asset_id"
    rename_index :contributions, "idx_33855_index_contributions_on_permalink", "index_contributions_on_permalink"

    rename_index :financial_assets, "idx_33843_index_financial_assets_on_permalink", "index_financial_assets_on_permalink"

    rename_index :milestones, "idx_33866_index_milestones_on_date", "index_milestones_on_date"
    rename_index :milestones, "idx_33866_index_milestones_on_permalink", "index_milestones_on_permalink"

    rename_index :snapshots, "idx_33833_index_snapshots_on_financial_asset_id", "index_snapshots_on_financial_asset_id"
    rename_index :snapshots, "idx_33833_index_snapshots_on_permalink", "index_snapshots_on_permalink"

    rename_index :taggings, "idx_33885_taggings_idx", "taggings_idx"
    rename_index :taggings, "idx_33885_index_taggings_on_taggable_id_and_taggable_type_and_c", "index_taggings_on_taggable_id_and_taggable_type_and_context"

    rename_index :tags, "idx_33875_index_tags_on_name", "index_tags_on_name"
  end
end
