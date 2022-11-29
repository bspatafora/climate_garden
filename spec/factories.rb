# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'Usie McUserson' }
    phone { '+12345678900' }
  end

  factory :one_time_password do
    value { '12345' }
    expires_at { 5.minutes.from_now }
    assocation { :user }
  end
end
