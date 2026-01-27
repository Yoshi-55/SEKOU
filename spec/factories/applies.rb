FactoryBot.define do
  factory :apply do
    message { "MyText" }
    desired_budget { 1 }
    available_date { "2026-01-27" }
    status { 1 }
    applied_at { "2026-01-27 07:08:37" }
    responded_at { "2026-01-27 07:08:37" }
    job_id { nil }
    craftsman_id { nil }
  end
end
