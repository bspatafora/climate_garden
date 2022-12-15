# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PlantPhotos' do
  describe 'GET /new' do
    xit 'returns http success' do
      get '/plant_photos/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    xit 'returns http success' do
      get '/plant_photos/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /index' do
    xit 'returns http success' do
      get '/plant_photos/index'
      expect(response).to have_http_status(:success)
    end
  end
end
