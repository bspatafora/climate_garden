# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_user!
    # TODO: Flash message
    redirect_to new_login_request_path unless user_signed_in?
  end
end
