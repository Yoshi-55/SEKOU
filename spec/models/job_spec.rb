# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'バリデーション' do
    subject { build(:job) }

    it '有効なファクトリーであること' do
      expect(subject).to be_valid
    end

    it 'タイトルが必須であること' do
      subject.title = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:title]).to be_present
    end

    it 'タイトルが100文字以内であること' do
      subject.title = 'a' * 101
      expect(subject).not_to be_valid
    end

    it '説明が必須であること' do
      subject.description = nil
      expect(subject).not_to be_valid
    end

    it '案件種別が必須であること' do
      subject.job_type = nil
      expect(subject).not_to be_valid
    end

    it '地域が必須であること' do
      subject.location = nil
      expect(subject).not_to be_valid
    end

    it '予算が必須であること' do
      subject.budget = nil
      expect(subject).not_to be_valid
    end

    it '予算が0より大きいこと' do
      subject.budget = 0
      expect(subject).not_to be_valid
    end

    it '予算が5000円単位であること' do
      subject.budget = 12_000
      expect(subject).not_to be_valid
      expect(subject.errors[:budget]).to include('は5000円単位で入力してください')
    end

    it '予算が5000円単位なら有効であること' do
      subject.budget = 25_000
      expect(subject).to be_valid
    end

    it '作業日が必須であること' do
      subject.scheduled_date = nil
      expect(subject).not_to be_valid
    end

    it '必要人数が必須であること' do
      subject.required_people = nil
      expect(subject).not_to be_valid
    end

    it '必要人数が1以上であること' do
      subject.required_people = 0
      expect(subject).not_to be_valid
    end

    it 'グループが必須であること' do
      subject.group_id = nil
      expect(subject).not_to be_valid
    end
  end

  describe '#job_type_label' do
    it 'car_wrapping をカーラッピング施工と返すこと' do
      job = build(:job, job_type: 'car_wrapping')
      expect(job.job_type_label).to eq 'カーラッピング施工'
    end

    it 'fleet をフリート施工と返すこと' do
      job = build(:job, job_type: 'fleet')
      expect(job.job_type_label).to eq 'フリート施工'
    end

    it '未知の値はそのまま返すこと' do
      job = build(:job, job_type: 'unknown')
      expect(job.job_type_label).to eq 'unknown'
    end
  end

  describe '#publish!' do
    it 'ステータスがpublishedになること' do
      job = create(:job, status: :pending_payment)
      job.publish!
      expect(job.reload).to be_published
    end

    it 'published_atが設定されること' do
      job = create(:job, status: :pending_payment)
      job.publish!
      expect(job.reload.published_at).to be_present
    end

    it 'expires_atが30日後に設定されること' do
      job = create(:job, status: :pending_payment)
      job.publish!
      expect(job.reload.expires_at).to be_within(1.minute).of(30.days.from_now)
    end
  end
end
