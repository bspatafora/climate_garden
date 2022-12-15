# frozen_string_literal: true

class User < ApplicationRecord
  has_one :inviter,
          class_name: 'User',
          foreign_key: 'inviter_id',
          dependent: :nullify,
          inverse_of: false
  has_many :one_time_passwords,
           dependent: :destroy

  has_many_attached :plant_photos

  validates :name, presence: true, length: { maximum: 70 }
  validates :phone, presence: true, length: { maximum: 12 }, phone: true

  before_validation :normalize_phone

  alias otps one_time_passwords

  def self.find_by(*args)
    conditions = args[0]
    phone = conditions[:phone]
    conditions[:phone] = normalize(phone) if phone
    super(*args)
  end

  def self.normalize(phone)
    Phonelib.parse(phone, 'US').e164
  end

  def normalize_phone
    self.phone = self.class.normalize(phone)
  end
end
