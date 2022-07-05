# frozen_string_literal: true

class RenameAssetSnapshotsToSnapshots < ActiveRecord::Migration[5.2]
  def change
    rename_table :asset_snapshots, :snapshots
  end
end
