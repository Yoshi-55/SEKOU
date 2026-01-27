FactoryBot.define do
  factory :payment do
    amount { 1 }
    stripe_charge_id { "MyString" }
    status { 1 }
    base_price { 1 }
    featured_price { 1 }
    urgent_price { 1 }
    extended_price { 1 }
    paid_at { "2026-01-27 07:11:53" }
    job_id { nil }
  end
end
