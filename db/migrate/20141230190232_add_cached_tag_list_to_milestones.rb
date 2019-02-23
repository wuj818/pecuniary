class AddCachedTagListToMilestones < ActiveRecord::Migration[5.2]
  def change
    add_column :milestones, :cached_tag_list, :string
  end
end
