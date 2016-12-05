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

require 'rails_helper'

RSpec.describe StripePayment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
