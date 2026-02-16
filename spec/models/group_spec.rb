# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  it '有効なファクトリーであること' do
    expect(create(:group)).to be_valid
  end

  it '名前が必須であること' do
    expect(build(:group, name: nil)).not_to be_valid
  end

  it 'オーナーが必須であること' do
    expect(build(:group, owner: nil)).not_to be_valid
  end

  it 'グループ作成時にオーナーが自動でメンバーに追加されること' do
    group = create(:group)
    expect(group.members).to include(group.owner)
  end
end
