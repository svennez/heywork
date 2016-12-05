class AddStripeFeeToCommunity < ActiveRecord::Migration
  def change
  	add_column :communities, :stripe_fee, :float
  end
end
