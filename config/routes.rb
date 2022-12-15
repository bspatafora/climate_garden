# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[new create show]
  resources :sessions, only: %i[new create]
  resources :login_requests, only: %i[new create]
  resources :plant_photos, only: %i[new create index]
end
