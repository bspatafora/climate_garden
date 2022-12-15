# frozen_string_literal: true

module Helpers
  def log_in
    user = create(:user, phone: '+12345678901')
    stub_request(:post, /twilio/)
    post '/login_requests', params: { phone: user.phone }
    post '/sessions', params: { phone: user.phone, otp: user.otps.last.value }
  end
end

RSpec.configure do |config|
  config.include Helpers
end
