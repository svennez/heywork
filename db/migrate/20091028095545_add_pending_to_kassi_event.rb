class AddPendingToKassiEvent < ActiveRecord::Migration
  def self.up
    add_column :kassi_events, :pending, :integer, :default => false
  end

  def self.down
    remove_column :kassi_events, :pending
  end
end
