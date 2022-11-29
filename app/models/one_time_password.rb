# frozen_string_literal: true

class OneTimePassword < ApplicationRecord
  belongs_to :user

  validates :value, presence: true
  validates :expires_at, presence: true
end
