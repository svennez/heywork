class SettingsController < ApplicationController

  before_filter :except => :unsubscribe do |controller|
    controller.ensure_logged_in t("layouts.notifications.you_must_log_in_to_view_your_settings")
  end

  before_filter EnsureCanAccessPerson.new(:person_id, error_message_key: "layouts.notifications.you_are_not_authorized_to_view_this_content"), except: [:unsubscribe, :connect_callback, :stripe_disconnet, :update_stripe_fee]

  def show
    target_user = Person.find_by!(username: params[:person_id], community_id: @current_community.id)
    add_location_to_person!(target_user)
    flash.now[:notice] = t("settings.profile.image_is_processing") if target_user.image.processing?
    @selected_left_navi_link = "profile"
    render locals: {target_user: target_user}
  end

  def account
    target_user = Person.find_by!(username: params[:person_id], community_id: @current_community.id)
    @selected_left_navi_link = "account"
    target_user.emails.build
    has_unfinished = TransactionService::Transaction.has_unfinished_transactions(target_user.id)

    render locals: {has_unfinished: has_unfinished, target_user: target_user}
  end

  def notifications
    target_user = Person.find_by!(username: params[:person_id], community_id: @current_community.id)
    @selected_left_navi_link = "notifications"
    render locals: {target_user: target_user}
  end

  def unsubscribe
    target_user = find_person_to_unsubscribe(@current_user, params[:auth])

    if target_user && target_user.username == params[:person_id] && params[:email_type].present?
      if params[:email_type] == "community_updates"
        MarketplaceService::Person::Command.unsubscribe_person_from_community_updates(target_user.id)
      elsif [Person::EMAIL_NOTIFICATION_TYPES, Person::EMAIL_NEWSLETTER_TYPES].flatten.include?(params[:email_type])
        target_user.preferences[params[:email_type]] = false
        target_user.save!
      else
        render :unsubscribe, :status => :bad_request, locals: {target_user: target_user, unsubscribe_successful: false} and return
      end
      render :unsubscribe, locals: {target_user: target_user, unsubscribe_successful: true}
    else
      render :unsubscribe, :status => :unauthorized, locals: {target_user: target_user, unsubscribe_successful: false}
    end
  end

  def stripe_connect
    url = ENV['connect_url']
    redirect_to url
  end

  def connect_callback
    api_secret = ENV['stripe_secret']
    code = params[:code]

    response = HTTParty.post("https://connect.stripe.com/oauth/token?client_secret=#{api_secret}&code=#{code}&grant_type=authorization_code")
    stripe_account = StripeAccount.create_stripe_account(response, @current_user, @current_community)
    flash[:notice] = 'Stripe account connected successfully'
    redirect_to '/'
  end

  def stripe_disconnet
    api_secret = ENV['stripe_secret']
    stripe_account = StripeAccount.where(person_id: @current_user.id, community_id: @current_community.id).first

    response = HTTParty.post("https://#{api_secret}:@connect.stripe.com/oauth/deauthorize?client_id=ca_9gex5cTJVgvFGTBwuKd266XiYsx4cav2&stripe_user_id=#{stripe_account.stripe_user_id}")
    if response["stripe_user_id"].present?
      stripe_account.destroy
      flash[:notice] = 'Stripe account disconnected successfully'
      redirect_to '/'
    else
      flash[:error] = response["error_description"]
      redirect_to '/'
    end
  end

  def update_stripe_fee
    @current_community.stripe_fee = params[:community][:stripe_fee]
    @current_community.save
    flash[:notice] = "Stripe fee updated successfully"
    redirect_to '/'
  end

  private

  def add_location_to_person!(person)
    unless person.location
      person.build_location(:address => person.street_address)
      person.location.search_and_fill_latlng
    end
    person
  end

  def find_person_to_unsubscribe(current_user, auth_token)
    current_user || Maybe(AuthToken.find_by_token(auth_token)).person.or_else { nil }
  end

end
