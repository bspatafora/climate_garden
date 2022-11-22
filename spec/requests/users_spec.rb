# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /new' do
    it 'returns http success' do
      get '/users/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    it 'returns http success' do
      post '/users', params: { user: { name: 'Usie McUserson', phone: '+15555555555' } }
      follow_redirect!
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /show' do
    it 'returns http success' do
      get "/users/#{create(:user).id}"
      expect(response).to have_http_status(:success)
    end
  end
end
