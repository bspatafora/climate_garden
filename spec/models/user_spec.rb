# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'name' do
    it 'disallows nil' do
      user = build(:user, name: nil)

      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'limits to 70 characters' do
      user = build(:user, name: 'a' * 71)

      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe 'phone' do
    it 'disallows nil' do
      user = build(:user, phone: nil)

      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'limits to 12 characters' do
      user = build(:user, phone: '+123456789000')

      expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'normalizes phone' do
      user = create(:user, phone: '(234) 567-8900')

      expect(user.phone).to eq('+12345678900')
    end
  end

  describe 'inviter' do
    it 'disallows invalid foreign key' do
      user = build(:user, inviter_id: 0)

      expect { user.save! }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it 'nullifies on deletion' do
      inviter = create(:user)
      user = create(:user, inviter:)
      inviter.destroy!

      expect(user.reload.inviter).to be_nil
    end
  end

  describe 'find_by' do
    it 'normalizes phone' do
      user = create(:user, phone: '+12345678900')
      expect(described_class.find_by(phone: '(234) 567-8900')).to eq(user)
    end
  end

  describe 'normalize' do
    it 'normalizes to E.164 format' do
      expect(described_class.normalize('1 (234) 567-8900')).to eq('+12345678900')
    end

    it 'assumes US number' do
      expect(described_class.normalize('(234) 567-8900')).to eq('+12345678900')
    end
  end
end
