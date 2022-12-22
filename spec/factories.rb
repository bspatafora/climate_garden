# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
  end

  factory :one_time_password do
    user
  end
end
