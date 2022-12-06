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
    let(:user_attributes) { attributes_for(:user) }

    it 'returns http success' do
      post '/users', params: { user: user_attributes }
      follow_redirect!
      expect(response).to have_http_status(:success)
    end

    it 'saves the user to the database' do
      expect { post '/users', params: { user: user_attributes } }.to change(User, :count).by(1)
    end

    it 'redirects to the user’s page' do
      post '/users', params: { user: user_attributes }
      user = User.find_by(phone: user_attributes[:phone])
      expect(response).to redirect_to(user_path(user))
    end
  end
end
