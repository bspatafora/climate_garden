# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OneTimePassword do
  describe 'value' do
    it 'disallows nil' do
      otp = build(:one_time_password, value: nil)
      expect { otp.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'defaults to a random, six-digit number' do
      otp = create(:one_time_password)
      expect(otp.value.length).to eq(6)
    end
  end

  describe 'expires_at' do
    it 'disallows nil' do
      otp = build(:one_time_password, expires_at: nil)
      expect { otp.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'defaults to some future time' do
      otp = create(:one_time_password)
      expect(otp.expires_at).to be > Time.current
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

  describe 'unexpired' do
    it 'returns true if OTP has not yet expired' do
      otp = create(:one_time_password, expires_at: 1.second.from_now)
      expect(described_class.where(user: otp.user).unexpired).to exist
    end

    it 'returns false if OTP has expired' do
      otp = create(:one_time_password, expires_at: 1.second.ago)
      expect(described_class.where(user: otp.user).unexpired).not_to exist
    end
  end

  describe 'valid?' do
    it 'returns true if value matches the user’s newest, unexpired OTP' do
      otp = create(:one_time_password)
      expect(described_class.valid?(otp.value, otp.user)).to be true
    end

    it 'returns false if value matches OTP of another user' do
      otp = create(:one_time_password)
      other_user = create(:user)
      expect(described_class.valid?(otp.value, other_user)).to be false
    end

    it 'returns false if value does not match the user’s newest, unexpired OTP' do
      otp = create(:one_time_password)
      expect(described_class.valid?('wrong', otp.user)).to be false
    end

    it 'returns false if value matches the user’s newest, but expired, OTP' do
      otp = create(:one_time_password, expires_at: 1.second.ago)
      expect(described_class.valid?(otp.value, otp.user)).to be false
    end

    it 'returns false if value matches an unexpired, but not newest, OTP of the user’s' do
      otp1 = create(:one_time_password)
      otp1.user.one_time_passwords.create
      expect(described_class.valid?(otp1.value, otp1.user)).to be false
    end
  end
end
