FactoryBot.define do
  factory :points_event do
    user
    source { |event| event.association(:reward) }
    points { -50 }
  end
end
