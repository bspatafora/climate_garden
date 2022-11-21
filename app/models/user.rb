# frozen_string_literal: true

class User < ApplicationRecord
  has_one :inviter,
          class_name: 'User',
          foreign_key: 'inviter_id',
          dependent: :nullify,
          inverse_of: false
end
