# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login requests' do
  describe 'GET /new' do
    it 'returns http success' do
      get '/login_requests/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    before do
      stub_request(:post, /twilio/)
    end

    let(:user) { create(:user) }

    it 'returns http success' do
      post '/login_requests', params: { phone: user.phone }
      follow_redirect!
      expect(response).to have_http_status(:success)
    end

    it 'creates a OneTimePassword for the user' do
      expect do
        post '/login_requests', params: { phone: user.phone }
      end.to change(user.one_time_passwords, :count).by(1)
    end

    it 'sends an SMS with the one-time password' do
      post '/login_requests', params: { phone: user.phone }
      expect(a_request(:any, /.*/).with(body: /#{user.otps.last.value}/)).to have_been_made
    end
  end
end
