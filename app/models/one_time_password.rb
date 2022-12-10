# frozen_string_literal: true

require 'securerandom'

# TODO: Job to clean up old, expired OTPs
class OneTimePassword < ApplicationRecord
  EXPIRATION = 5.minutes

  belongs_to :user

  attribute :value, default: -> { random_six_digit }
  attribute :expires_at, default: -> { EXPIRATION.from_now }
  attribute :used, default: false

  validates :value, presence: true
  validates :expires_at, presence: true
  validates :used, inclusion: { in: [true, false] }

  scope :unexpired, -> { where('expires_at > ?', Time.current) }
  scope :unused, -> { where(used: false) }

  def self.random_six_digit
    (SecureRandom.random_number(9e5) + 1e5).to_i
  end

  def self.valid?(value, user)
    latest_unexpired = where(user:).unexpired.unused.order(created_at: :desc).first

    return false if latest_unexpired.nil?
    return false if value != latest_unexpired.value

    latest_unexpired.update!(used: true)
    true
  end
end
