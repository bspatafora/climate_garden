# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:user) { create(:user) }

  describe 'GET /new' do
    it 'returns http success' do
      get '/sessions/new', params: { phone: user.phone }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    let(:otp) { user.one_time_passwords.create }

    it 'returns http success' do
      post '/sessions', params: { phone: user.phone, otp: otp.value }
      follow_redirect!
      expect(response).to have_http_status(:success)
    end

    it 'stores the user’s ID in the session' do
      post '/sessions', params: { phone: user.phone, otp: otp.value }
      follow_redirect!
      expect(session[:user_id]).to eq(user.id)
    end

    it 'redirects to the user’s page' do
      post '/sessions', params: { phone: user.phone, otp: otp.value }
      expect(response).to redirect_to(user_path(user))
    end
  end
end
