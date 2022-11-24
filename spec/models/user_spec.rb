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

    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'limits names to 70 characters' do
    user = build(:user, name: 'a' * 71)

    expect { user.save! }.to raise_error(ActiveRecord::ValueTooLong)
  end

  it 'limits phones to 12 characters' do
    user = build(:user, phone: '+123456789000')

    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'disallows invalid phone' do
    user = build(:user, phone: '234-567-8900')

    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'disallows invalid inviter' do
    user = build(:user, inviter_id: 0)

    expect { user.save! }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  it 'nullifies inviter upon deletion' do
    inviter = create(:user)
    user = create(:user, inviter:)
    inviter.destroy!

    expect(user.reload.inviter).to be_nil
  end
end
