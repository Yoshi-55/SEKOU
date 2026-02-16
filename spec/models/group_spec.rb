# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'バリデーション' do
    subject { build(:group) }

    it '有効なファクトリーであること' do
      expect(subject).to be_valid
    end

    it '名前が必須であること' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it '名前が100文字以内であること' do
      subject.name = 'a' * 101
      expect(subject).not_to be_valid
    end

    it 'オーナーが必須であること' do
      subject.owner = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'コールバック' do
    it 'グループ作成時にオーナーが自動でメンバーに追加されること' do
      owner = create(:user)
      group = create(:group, owner: owner)
      expect(group.members).to include(owner)
    end

    it 'オーナーのメンバーシップのroleがadminであること' do
      owner = create(:user)
      group = create(:group, owner: owner)
      membership = group.group_memberships.find_by(user: owner)
      expect(membership).to be_admin
    end
  end
end
