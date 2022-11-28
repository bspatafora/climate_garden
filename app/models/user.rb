# frozen_string_literal: true

class User < ApplicationRecord
  has_one :inviter,
          class_name: 'User',
          foreign_key: 'inviter_id',
          dependent: :nullify,
          inverse_of: false

  validates :name, presence: true, length: { maximum: 70 }
  validates :phone, presence: true, length: { maximum: 12 }, phone: true
end
