require 'httparty'

class PaypalService
  include HTTParty
  base_uri ENV['PAYPAL_API_BASE_URL']

  def initialize
    @auth = {
      username: ENV['PAYPAL_CLIENT_ID'],
      password: ENV['PAYPAL_SECRET']
    }
  end

  def get_access_token
    response = self.class.post('/v1/oauth2/token',
      basic_auth: @auth,
      headers: { 'Content-Type' => 'application/x-www-form-urlencoded' },
      body: { grant_type: 'client_credentials' }
    )
    response.parsed_response["access_token"]
  end

  def create_order(amount)
    token = get_access_token
    response = self.class.post('/v2/checkout/orders',
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{token}"
      },
      body: {
        intent: "CAPTURE",
        purchase_units: [{
          amount: {
            currency_code: "USD",
            value: amount
          }
        }]
      }.to_json
    )
    response.parsed_response
  end
end
