# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Apply, type: :model do
  describe 'バリデーション' do
    subject { build(:apply) }

    it '有効なファクトリーであること' do
      expect(subject).to be_valid
    end

    it 'メッセージが必須であること' do
      subject.message = nil
      expect(subject).not_to be_valid
    end

    it 'メッセージが1000文字以内であること' do
      subject.message = 'a' * 1001
      expect(subject).not_to be_valid
    end

    it '同じ案件に重複応募できないこと' do
      job = create(:job)
      craftsman = create(:user)
      create(:apply, job: job, craftsman: craftsman)
      duplicate = build(:apply, job: job, craftsman: craftsman)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:job_id]).to be_present
    end

    it '別の案件には応募できること' do
      craftsman = create(:user)
      create(:apply, craftsman: craftsman)
      another_job = create(:job)
      apply2 = build(:apply, job: another_job, craftsman: craftsman)
      expect(apply2).to be_valid
    end
  end

  describe '#accept!' do
    it 'ステータスがacceptedになること' do
      apply = create(:apply)
      apply.accept!
      expect(apply.reload).to be_accepted
    end

    it 'responded_atが設定されること' do
      apply = create(:apply)
      apply.accept!
      expect(apply.reload.responded_at).to be_present
    end
  end

  describe '#reject!' do
    it 'ステータスがrejectedになること' do
      apply = create(:apply)
      apply.reject!
      expect(apply.reload).to be_rejected
    end
  end

  describe '#cancel!' do
    it 'pending状態なら取り消せること' do
      apply = create(:apply, status: :pending)
      result = apply.cancel!
      expect(result).to be_truthy
      expect(apply.reload).to be_cancelled
    end

    it 'accepted状態は取り消せないこと' do
      apply = create(:apply, status: :accepted)
      result = apply.cancel!
      expect(result).to be_falsey
      expect(apply.reload).to be_accepted
    end
  end
end
