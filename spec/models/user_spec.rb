# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'creates users with valid params' do
    expect { create(:user) }.not_to raise_error
  end

  it 'disallows nil name' do
    user = build(:user, name: nil)

    expect { user.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'disallows nil phone' do
    user = build(:user, phone: nil)

    expect { user.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'limits names to 70 characters' do
    user = build(:user, name: 'a' * 71)

    expect { user.save! }.to raise_error(ActiveRecord::ValueTooLong)
  end

  it 'limits phones to 12 characters' do
    user = build(:user, phone: '+155555555559')

    expect { user.save! }.to raise_error(ActiveRecord::ValueTooLong)
  end
end
