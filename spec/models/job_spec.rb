# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job, type: :model do
  it '有効なファクトリーであること' do
    expect(create(:job)).to be_valid
  end

  it 'タイトルが必須であること' do
    expect(build(:job, title: nil)).not_to be_valid
  end

  it '予算が5000円単位でないと無効であること' do
    expect(build(:job, budget: 12_000)).not_to be_valid
  end

  it '予算が5000円単位なら有効であること' do
    expect(build(:job, budget: 25_000)).to be_valid
  end

  it 'job_type_labelが日本語を返すこと' do
    expect(build(:job, job_type: 'car_wrapping').job_type_label).to eq 'カーラッピング施工'
  end

  it '#publish! でステータスがpublishedになること' do
    job = create(:job, status: :pending_payment)
    job.publish!
    expect(job.reload).to be_published
  end
end
