# == Schema Information
#
# Table name: custom_field_values
#
#  id              :integer          not null, primary key
#  custom_field_id :integer
#  listing_id      :integer
#  text_value      :text(65535)
#  numeric_value   :float(24)
#  date_value      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  type            :string(255)
#  delta           :boolean          default(TRUE), not null
#
# Indexes
#
#  index_custom_field_values_on_listing_id  (listing_id)
#  index_custom_field_values_on_type        (type)
#

class CustomFieldValue < ActiveRecord::Base
  attr_accessible :type

  belongs_to :listing
  belongs_to :question, :class_name => "CustomField", :foreign_key => "custom_field_id"

  delegate :with_type, :to => :question

  default_scope { includes(:question).order("custom_fields.sort_priority") }


  after_create :update_seats_availability
  def update_seats_availability
    listing = self.listing
    if listing.present?
      listing.custom_field_values.each do |custom_field_value|
        if custom_field_value.question.name(I18n.locale) == "Number of seats available"
          listing.seats_available = custom_field_value.display_value
          listing.save!
        end
      end
    end
  end
end
