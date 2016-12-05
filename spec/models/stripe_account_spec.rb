# == Schema Information
#
# Table name: stripe_accounts
#
#  id              :integer          not null, primary key
#  person_id       :string(255)
#  community_id    :integer
#  access_token    :string(255)
#  refresh_token   :string(255)
#  publishable_key :string(255)
#  stripe_user_id  :string(255)
#  token_type      :string(255)
#  livemode        :boolean
#  scope           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe StripeAccount, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
