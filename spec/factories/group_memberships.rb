# frozen_string_literal: true

FactoryBot.define do
  factory :group_membership do
    group { nil }
    user { nil }
    role { 1 }
  end
end
