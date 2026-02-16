# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    subject { build(:user) }

    it '有効なファクトリーであること' do
      expect(subject).to be_valid
    end

    it '名前が必須であること' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it '電話番号が必須であること' do
      subject.phone = nil
      expect(subject).not_to be_valid
    end

    it 'メールアドレスが必須であること' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'メールアドレスが一意であること' do
      create(:user, email: 'test@example.com')
      subject.email = 'test@example.com'
      expect(subject).not_to be_valid
    end

    it 'パスワードが必須であること' do
      subject.password = nil
      expect(subject).not_to be_valid
    end

    it 'パスワードが6文字以上であること' do
      subject.password = 'short'
      subject.password_confirmation = 'short'
      expect(subject).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'グループを持てること' do
      user = create(:user)
      group = create(:group, owner: user)
      expect(user.owned_groups).to include(group)
    end

    it 'グループのメンバーになれること' do
      user = create(:user)
      group = create(:group)
      group.group_memberships.create!(user: user, role: :member)
      expect(user.groups).to include(group)
    end
  end
end
