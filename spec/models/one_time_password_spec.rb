# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OneTimePassword do
  describe 'value' do
    it 'disallows nil' do
      otp = build(:one_time_password, value: nil)

      expect { otp.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'expires_at' do
    it 'disallows nil' do
      otp = build(:one_time_password, expires_at: nil)

      expect { otp.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'has a default' do
      otp = create(:one_time_password)

      expect(otp.expires_at).to be_a(Time)
    end
  end

  describe 'user' do
    it 'disallows invalid foreign key' do
      otp = build(:one_time_password, user_id: 0)

      expect { otp.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'destroys on deletion' do
      user = create(:user)
      otp = create(:one_time_password, user:)
      user.destroy!

      expect { otp.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#valid' do
    it 'returns true if otp has not yet expired' do
      otp = create(:one_time_password, expires_at: 1.second.from_now)

      expect(described_class.where(user: otp.user).valid).to exist
    end

    it 'returns false if otp has expired' do
      otp = create(:one_time_password, expires_at: 1.second.ago)

      expect(described_class.where(user: otp.user).valid).not_to exist
    end
  end
end
