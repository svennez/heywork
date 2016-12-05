class AddSortPriorityToCommunityCategories < ActiveRecord::Migration
  def change
    add_column :community_categories, :sort_priority, :integer, :default => false
  end
end
