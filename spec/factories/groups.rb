# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "グループ#{n}" }
    description { 'テスト用グループです' }
    association :owner, factory: :user
  end
end
