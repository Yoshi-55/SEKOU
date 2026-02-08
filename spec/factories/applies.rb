# frozen_string_literal: true

FactoryBot.define do
  factory :apply do
    message { 'MyText' }
    status { 1 }
    applied_at { '2026-01-27 07:08:37' }
    responded_at { '2026-01-27 07:08:37' }
    association :job
    association :craftsman, factory: :user
  end
end
