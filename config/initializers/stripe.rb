if Rails.env == 'production'
  Rails.configuration.stripe = {
    publishable_key: ENV['stripe_publishable'],
    secret_key:      ENV['stripe_secret']
  }
else
  Rails.configuration.stripe = {
    publishable_key: ENV['stripe_publishable'],
    secret_key:      ENV['stripe_secret']
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]