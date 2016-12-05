class CreateStripeAccounts < ActiveRecord::Migration
  def change
    create_table :stripe_accounts do |t|
      t.string :person_id
      t.integer :community_id
      t.string :access_token
      t.string :refresh_token
      t.string :publishable_key
      t.string :stripe_user_id
      t.string :token_type
      t.boolean :livemode
      t.string :scope
      t.timestamps null: false
    end
  end
end
