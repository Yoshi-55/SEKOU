# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    sequence(:title) { |n| "カーラッピング施工スタッフ募集#{n}" }
    description { '車両のカーラッピング施工をお願いします。経験者優遇。' }
    job_type { 'car_wrapping' }
    location { '東京都' }
    address { '渋谷区神南1-1-1' }
    budget { 25_000 }
    scheduled_date { 1.week.from_now }
    required_people { 2 }
    status { :published }
    published_at { Time.current }
    expires_at { 30.days.from_now }
    association :client, factory: :user
    association :group
  end
end
