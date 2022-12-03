# frozen_string_literal: true

require 'sms_client'

class LoginRequestsController < ApplicationController
  def new; end

  def create
    user = User.find_by(phone: login_request_params[:phone])
    SmsClient.new.send(
      to: user.phone,
      message: "Code: #{user.one_time_passwords.create.value}"
    )
    redirect_to controller: :sessions, action: :new, phone: login_request_params[:phone]
  end

  private

  def login_request_params
    params.permit(:phone)
  end
end
