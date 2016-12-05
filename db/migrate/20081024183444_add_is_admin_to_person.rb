class AddIsAdminToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :is_admin, :integer, :default => false
  end

  def self.down
    remove_column :people, :is_admin
  end
end
