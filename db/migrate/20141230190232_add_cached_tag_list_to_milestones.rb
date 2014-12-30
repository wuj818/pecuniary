class AddCachedTagListToMilestones < ActiveRecord::Migration
  def change
    add_column :milestones, :cached_tag_list, :string
  end
end
