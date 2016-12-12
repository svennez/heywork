# == Schema Information
#
# Table name: stripe_payments
#
#  id             :integer          not null, primary key
#  person_id      :string(255)
#  community_id   :integer
#  listing_id     :integer
#  charge_id      :string(255)
#  amount         :integer
#  last4          :integer
#  fee_amount     :integer
#  payment_status :string(255)
#  stripe_connect :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class StripePayment < ActiveRecord::Base
  belongs_to :listing
  belongs_to :person

  # Store payment to database
  def self.create_payment(current_user, current_community, listing_id, charge, fee, stripe_connect)
    stripe_payment = StripePayment.create(person_id: current_user.id,
                                          community_id: current_community.id,
                                          listing_id: listing_id,
                                          charge_id: charge.id,
                                          amount: charge.amount,
                                          last4: charge.source.last4,
                                          stripe_connect: stripe_connect,
                                          payment_status: charge.status,
                                          fee_amount: fee)
  end

  # when seller have stripe account
  def self.create_charge(amount, token, fee, stripe_account_id, listing_id)
    listing = Listing.where(id: listing_id).first
    currency = listing.currency.nil? ? 'SEK' : listing.currency
    charge = Stripe::Charge.create({
        :amount => amount, # amount in cents
        :currency => currency,
        :source => token,
        :description => "Payment for listing #{listing_id}",
        :application_fee => fee # amount in cents
      },
      {:stripe_account => stripe_account_id}
    )
    charge
  end

  # when seller doesn't have stripe account
  def self.create_charge_with_customer(amount, token, listing_id, email)
    listing = Listing.where(id: listing_id).first
    currency = listing.currency.nil? ? 'SEK' : listing.currency
    customer = Stripe::Customer.create(
      :email => email,
      :source  => token
    )
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => amount,
      :description => "Payment for listing #{listing_id}",
      :currency    => currency
    )
    charge
  end
end
