# frozen_string_literal: true

class PlantPhotosController < ApplicationController
  def index
    @plant_photos = current_user.plant_photos
  end

  def new; end

  def create
    current_user.plant_photos.attach(plant_photos_params[:plant_photo])
  end

  private

  def plant_photos_params
    params.permit(:plant_photo)
  end
end
