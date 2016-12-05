class ChangeListingTimesViewedDefault < ActiveRecord::Migration
  def self.up
    change_column :listings, :times_viewed, :integer, :default => false
  end

  def self.down
    change_column :listings, :times_viewed, :integer
  end
end
