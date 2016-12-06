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

class StripeAccount < ActiveRecord::Base
  belongs_to :person
  belongs_to :community

  def self.create_stripe_account(response, current_user, current_community)
    stripe_account = StripeAccount.create(access_token: response["access_token"],
                                          refresh_token: response["refresh_token"],
                                          publishable_key: response["stripe_publishable_key"],
                                          stripe_user_id: response["stripe_user_id"],
                                          token_type: response["token_type"],
                                          livemode: response["livemode"],
                                          scope: response["scope"],
                                          person_id: current_user.id,
                                          community_id: current_community.id)
  end
end
