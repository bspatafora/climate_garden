# frozen_string_literal: true

class SmsClient
  def initialize
    @config = Rails.configuration.twilio
    @conn = Faraday.new(url: @config[:url_base]) do |conn|
      conn.request :authorization, :basic, @config[:account_sid], @config[:auth_token]
      conn.request :url_encoded
      conn.response :json
    end
  end

  def send(to:, message:)
    params = {
      Body: message,
      From: @config[:phone_number],
      To: to
    }

    @conn.post("/2010-04-01/Accounts/#{@config[:account_sid]}/Messages.json", params)
  end
end
