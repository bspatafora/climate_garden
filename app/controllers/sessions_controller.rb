# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    redirect_to new_login_request_path unless session_params[:phone]

    @phone = session_params[:phone]
  end

  # TODO: Don’t expire session on browser close
  # TODO: Rate limit
  def create
    user = User.find_by(phone: session_params[:phone])
    otp = session_params[:otp]

    if OneTimePassword.valid?(otp, user)
      log_in(user)
      redirect_to user
    else
      flash.now[:alert] = 'Invalid code'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def session_params
    params.permit(:otp, :phone)
  end
end
