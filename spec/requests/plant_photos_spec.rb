# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PlantPhotos' do
  let(:current_user) { create(:user) }
  let(:plant_photo) { fixture_file_upload('plant_photo.png') }

  before { log_in(current_user) }

  describe 'index' do
    it 'returns HTTP 200' do
      get '/plant_photos'
      expect(response).to have_http_status(:success)
    end

    it 'returns the user’s plant photos' do
      current_user.plant_photos.attach(plant_photo)
      get '/plant_photos'
      expect(response.body).to include('plant_photo.png')
    end
  end

  describe 'new' do
    it 'returns HTTP 200' do
      get '/plant_photos/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'create' do
    it 'returns HTTP 200' do
      post '/plant_photos', params: { plant_photo: }
      follow_redirect!
      expect(response).to have_http_status(:success)
    end

    it 'saves the plant photo to the database' do
      expect { post '/plant_photos', params: { plant_photo: } }.to change(current_user.plant_photos, :count).by(1)
    end

    it 'redirects to the plant photos page' do
      post '/plant_photos', params: { plant_photo: }
      expect(response).to redirect_to(plant_photos_path)
    end
  end
end
