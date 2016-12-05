class InsertIsHandledToFeedbacks < ActiveRecord::Migration
  def self.up
    add_column :feedbacks, :is_handled, :integer, :default => false
  end

  def self.down
    remove_column :feedbacks, :is_handled
  end
end
