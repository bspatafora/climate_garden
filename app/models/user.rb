# frozen_string_literal: true

class User < ApplicationRecord
  has_one :inviter,
          class_name: 'User',
          foreign_key: 'inviter_id',
          dependent: :nullify,
          inverse_of: false
  has_many :one_time_passwords,
           dependent: :destroy

  validates :name, presence: true, length: { maximum: 70 }
  validates :phone, presence: true, length: { maximum: 12 }, phone: true

  before_validation :normalize_phone

  def normalize_phone
    self.phone = Phonelib.parse(phone, 'US').e164
  end
end
