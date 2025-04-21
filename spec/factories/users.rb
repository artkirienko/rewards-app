FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    points { 100 }
    password { "password" }
    password_confirmation { "password" }
  end
end
