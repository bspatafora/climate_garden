# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /show' do
    let(:user) { create(:user) }

    it 'returns HTTP 200' do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end

    it 'returns data associated with the user' do
      get "/users/#{user.id}"
      expect(response.body).to include(user.name)
    end
  end

  describe 'GET /new' do
    it 'returns HTTP 200' do
      get '/users/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    context 'when request is valid' do
      let(:user_attributes) { attributes_for(:user) }

      it 'returns HTTP 200' do
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

    context 'when submitted attributes are invalid' do
      let(:invalid_user_attributes) { { bad: 'data' } }

      it 'returns HTTP 422' do
        post '/users', params: { user: invalid_user_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the new user form' do
        post '/users', params: { user: invalid_user_attributes }
        expect(response.body).to include('form', 'name', 'phone')
      end
    end
  end
end
