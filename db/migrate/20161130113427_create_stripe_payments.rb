class CreateStripePayments < ActiveRecord::Migration
  def change
    create_table :stripe_payments do |t|
      t.string :person_id
      t.integer :community_id
      t.integer :listing_id
      t.string :charge_id
      t.integer :amount
      t.integer :last4
      t.integer :fee_amount
      t.string :payment_status
      t.boolean :stripe_connect
      t.timestamps null: false
    end
  end
end
