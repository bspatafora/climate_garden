# frozen_string_literal: true

class OneTimePassword < ApplicationRecord
  belongs_to :user
end
