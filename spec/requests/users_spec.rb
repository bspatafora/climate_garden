# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /show' do
    let(:user) { create(:user) }

    it 'returns http success' do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end

    it 'returns data associated with the user' do
      get "/users/#{user.id}"
      expect(response.body).to include(user.name)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/users/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    let(:user_params) { { name: 'Usie McUserson', phone: '+15555555555' } }

    it 'returns http success' do
      post '/users', params: { user: user_params }
      follow_redirect!
      expect(response).to have_http_status(:success)
    end

    it 'saves the user to the database' do
      expect { post '/users', params: { user: user_params } }.to change(User, :count).by(1)
    end
  end
end
