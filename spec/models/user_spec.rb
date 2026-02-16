# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '有効なファクトリーであること' do
    expect(build(:user)).to be_valid
  end

  it '名前が必須であること' do
    expect(build(:user, name: nil)).not_to be_valid
  end

  it 'メールアドレスが必須であること' do
    expect(build(:user, email: nil)).not_to be_valid
  end

  it 'パスワードが必須であること' do
    expect(build(:user, password: nil)).not_to be_valid
  end
end
