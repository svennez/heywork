class AddStripeFeeToCommunity < ActiveRecord::Migration
  def change
  	add_column :communities, :stripe_fee, :float, default: '15.0'
  end
end
