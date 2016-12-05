class AddAmountToItems < ActiveRecord::Migration
  def self.up
    add_column :items, :amount, :integer, :default => true
  end

  def self.down
    remove_column :items, :amount
  end
end
