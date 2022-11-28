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

    it 'normalizes to E.164 format' do
      user = build(:user, phone: '1-234-567-8900')

      expect { user.save! }.not_to raise_error
    end

    it 'assumes US number' do
      user = build(:user, phone: '(234) 567-8900')

      user.save!

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
end
