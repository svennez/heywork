if Rails.env == 'production'
  Rails.configuration.stripe = {
    publishable_key: 'pk_test_YQaKMjcR47Wxv47Gx4ZwTgn7',
    secret_key:      'sk_test_DQW3n1NektIPgiPoEOhuFJ1m'
  }
else
  Rails.configuration.stripe = {
    publishable_key: 'pk_test_YQaKMjcR47Wxv47Gx4ZwTgn7',
    secret_key:      'sk_test_DQW3n1NektIPgiPoEOhuFJ1m'
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]