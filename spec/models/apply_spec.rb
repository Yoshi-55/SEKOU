# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Apply, type: :model do
  it '有効なファクトリーであること' do
    expect(build(:apply)).to be_valid
  end

  it 'メッセージが必須であること' do
    expect(build(:apply, message: nil)).not_to be_valid
  end

  it '#accept! でステータスがacceptedになること' do
    apply = create(:apply)
    apply.accept!
    expect(apply.reload).to be_accepted
  end

  it '#cancel! でpending状態なら取り消せること' do
    apply = create(:apply, status: :pending)
    apply.cancel!
    expect(apply.reload).to be_cancelled
  end
end
