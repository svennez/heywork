class AddNewMailNotificationOptionsToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :email_when_new_kassi_event, :integer, :default => true
    add_column :settings, :email_when_new_comment_to_kassi_event, :integer, :default => true
    add_column :settings, :email_when_new_listing_from_friend, :integer, :default => true
  end

  def self.down
    remove_column :settings, :email_when_new_kassi_event
    remove_column :settings, :email_when_new_comment_to_kassi_event
    remove_column :settings, :email_when_new_listing_from_friend
  end
end
