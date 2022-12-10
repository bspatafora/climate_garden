# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to controller: :login_requests, action: :new unless session_params[:phone]

    @phone = session_params[:phone]
  end

  # TODO: Rate limit
  def create
    user = User.find_by(phone: session_params[:phone])
    otp = session_params[:otp]

    if OneTimePassword.valid?(otp, user)
      log_in(user)
      redirect_to controller: :users, action: :show, id: user.id
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
