# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @phone = session_params[:phone]
  end

  def create
    user = User.find_by(phone: session_params[:phone])
    otp = OneTimePassword.valid.order(created_at: :desc).find_by(user:)
    if session_params[:otp] == otp.value
      session[:user_id] = user.id
      redirect_to controller: :users, action: :show, id: user.id
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def session_params
    params.permit(:otp, :phone)
  end
end
