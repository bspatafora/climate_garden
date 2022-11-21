# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'creates users with valid params' do
    user_params = {
      name: 'a' * 70,
      phone: '+15555555555'
    }

    expect { described_class.create!(user_params) }.not_to raise_error
  end

  it 'limits names to 70 characters' do
    user_params = {
      name: 'a' * 71,
      phone: '+15555555555'
    }

    expect { described_class.create!(user_params) }.to raise_error(ActiveRecord::ValueTooLong)
  end

  it 'limits phones to 12 characters' do
    user_params = {
      name: 'a' * 70,
      phone: '+155555555559'
    }

    expect { described_class.create!(user_params) }.to raise_error(ActiveRecord::ValueTooLong)
  end
end
