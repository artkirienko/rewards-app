FactoryBot.define do
  factory :reward do
    sequence(:name) { |n| "Reward #{n}" }
    description { "A sample reward description" }
    points { 50 }
  end
end
