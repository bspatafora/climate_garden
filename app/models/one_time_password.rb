# frozen_string_literal: true

require 'securerandom'

# TODO: Job to clean up old, expired OTPs
class OneTimePassword < ApplicationRecord
  EXPIRATION = 5.minutes

  belongs_to :user

  attribute :value, default: -> { random_six_digit }
  attribute :expires_at, default: -> { EXPIRATION.from_now }

  validates :value, presence: true
  validates :expires_at, presence: true

  scope :unexpired, -> { where('expires_at > ?', Time.current) }

  def self.random_six_digit
    (SecureRandom.random_number(9e5) + 1e5).to_i
  end

  # TODO: Prevent same code from being used twice
  def self.valid?(value, user)
    latest_unexpired = where(user:).unexpired.order(created_at: :desc).first

    return false if latest_unexpired.nil?

    value == latest_valid.value
  end
end
