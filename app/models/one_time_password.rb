# frozen_string_literal: true

require 'securerandom'

class OneTimePassword < ApplicationRecord
  EXPIRATION = 5.minutes

  belongs_to :user

  attribute :value, default: -> { random_six_digit }
  attribute :expires_at, default: -> { EXPIRATION.from_now }

  validates :value, presence: true
  validates :expires_at, presence: true

  scope :valid, -> { where('expires_at > ?', Time.current) }

  def self.random_six_digit
    (SecureRandom.random_number(9e5) + 1e5).to_i
  end
end
