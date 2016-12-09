class AddSeatsAvailableToListings < ActiveRecord::Migration
  def change
  	add_column :listings, :seats_available, :integer
  end
end
