FactoryBot.define do
  factory :job do
    title { "MyString" }
    description { "MyText" }
    job_type { "MyString" }
    location { "MyString" }
    address { "MyText" }
    budget { 1 }
    scheduled_date { "2026-01-27" }
    required_people { 1 }
    featured { false }
    urgent { false }
    extended_period { false }
    status { 1 }
    published_at { "2026-01-27 07:05:14" }
    expires_at { "2026-01-27 07:05:14" }
    client_id { nil }
  end
end
