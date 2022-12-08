# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login requests' do
  describe 'GET /new' do
    it 'returns HTTP 200' do
      get '/login_requests/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'when request is valid' do
      before do
        stub_request(:post, /twilio/)
      end

      let(:user) { create(:user) }

      it 'returns HTTP 200' do
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

      it 'redirects to the new session page, passing the user’s phone' do
        post '/login_requests', params: { phone: user.phone }
        expect(response).to redirect_to(new_session_path(phone: user.phone))
      end
    end

    context 'when request is not valid' do
      let(:non_existent_phone) { '+15555555555' }

      it 'returns HTTP 422' do
        post '/login_requests', params: { phone: non_existent_phone }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new login request form' do
        post '/login_requests', params: { phone: non_existent_phone }
        expect(response.body).to include('form', 'phone')
      end
    end
  end
end
