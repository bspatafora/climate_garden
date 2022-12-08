# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions' do
  let(:user) { create(:user) }

  describe 'GET /new' do
    context 'when request is valid' do
      it 'returns HTTP 200' do
        get '/sessions/new', params: { phone: user.phone }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when phone is missing' do
      it 'redirects to the new login request page' do
        get '/sessions/new', params: {}
        expect(response).to redirect_to(new_login_request_path)
      end
    end
  end

  describe 'POST /create' do
    let(:otp) { user.one_time_passwords.create }

    context 'when request is valid' do
      it 'returns HTTP 200' do
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

    context 'when the user-input OTP is incorrect' do
      let(:incorrect_otp) { otp.value << '1' }

      it 'returns HTTP 422' do
        post '/sessions', params: { phone: user.phone, otp: incorrect_otp }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new login request form' do
        post '/sessions', params: { phone: user.phone, otp: incorrect_otp }
        expect(response.body).to include('form', 'otp')
      end
    end
  end
end
