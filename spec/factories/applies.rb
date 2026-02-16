# frozen_string_literal: true

FactoryBot.define do
  factory :apply do
    message { 'カーラッピング施工歴5年です。ぜひ担当させてください。' }
    status { :pending }
    association :job
    association :craftsman, factory: :user
  end
end
