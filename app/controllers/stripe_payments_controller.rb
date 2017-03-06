class StripePaymentsController < ApplicationController

  before_filter :only => [ :create, :index ] do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_settings")
  end
  before_filter :check_access, only: [:index]

  def create
    token = params[:stripeToken]
    amount = params[:amount]
    amount_not_in_cents = params[:amount].to_i/100
    listing_id = params[:listing_id]
    if params[:stripe_account_id].present?
      stripe_account_id = params[:stripe_account_id]
      # 15% Fee Calculation
      fee = ((@current_community.stripe_fee.to_i * amount_not_in_cents)/100)*100
      # Create the charge with Stripe
      charge = StripePayment.create_charge(amount, token, fee, stripe_account_id, listing_id)

      begin
      rescue Stripe::StripeError => e
        flash[:error] = e.message
        redirect_to '/'
      else
        if charge.status == "succeeded"
          stripe_connect = true
          stripe_payment = StripePayment.create_payment(@current_user, @current_community, listing_id, charge, fee, stripe_connect)
          flash[:notice] = 'Payment successful'
          redirect_to listing_path(listing_id)
        end
      end
    else
      charge = StripePayment.create_charge_with_customer(amount, token, listing_id, params[:stripeEmail])
      begin
      rescue Stripe::StripeError => e
        flash[:error] = e.message
        redirect_to '/'
      else
        if charge.status == "succeeded"
          stripe_connect = false
          fee = 0
          stripe_payment = StripePayment.create_payment(@current_user, @current_community, listing_id, charge, fee, stripe_connect)
          flash[:notice] = 'Payment successful'
          redirect_to listing_path(listing_id)
        end
      end
    end
  end

  def index
    @stripe_payments = StripePayment.all
  end

  private
  def check_access
    if current_user.is_marketplace_admin?
    else
      flash[:error] = t "layouts.notifications.you_are_not_authorized_to_view_this_content"
      redirect_to '/'
    end
  end


end
