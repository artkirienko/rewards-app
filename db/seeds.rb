# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user_data = [
  { name: 'Bryan Rainlord', email_address: 'one@example.com', points: 0 },
  { name: 'Cherry Undersun', email_address: 'two@example.com', points: 0 },
  { name: 'Jim Thorton', email_address: 'three@example.com', points: 0 }
]

user_data.each do |data|
  User.find_or_create_by!(email_address: data[:email_address]) do |user|
    user.name = data[:name]
    user.points = data[:points]
  end
end

reward_data = [
  { name: "Tim's Favourite Soup", description: 'Free Tim\'s favourite soup, slice of bread included.', points: 80 },
  { name: '1 Baked Pie', description: 'Small size free baked pie at the cafe.', points: 50 },
  { name: 'Free Brewed Coffee or Tea', description: 'Any size free brewed coffee or tea at the cafe.', points: 50 },
  { name: 'Vanilla Cone Pick Up only', description: 'Regular size free Vanilla Cone Pick Up only at the cafe.', points: 60 },
  { name: 'Any Size Latte', description: 'Any size coffee latte at the cafe.', points: 70 },
  { name: 'Breakfast Wrap', description: 'Free breakfast wrap at the cafe.', points: 80 },
  { name: 'Eggs Benedict Meal', description: 'Free Eggs Benedict meal including any size brewed tea or coffee, salad, and french fries.', points: 150 },
  { name: 'Dinner Voucher', description: 'A voucher for a dinner at the cafe.', points: 300 }
]

reward_data.each do |data|
  Reward.find_or_create_by!(name: data[:name]) do |reward|
    reward.description = data[:description]
    reward.points = data[:points]
  end
end

bonus_data = [
  { name: 'Sign Up Bonus', description: 'Bonus for signing up.', points: 100 },
  { name: 'Referral Bonus', description: 'Bonus for referring a friend.', points: 50 },
  { name: 'Birthday Bonus', description: 'Birthday bonus for users.', points: 200 },
  { name: 'Anniversary Bonus', description: 'Anniversary bonus for users.', points: 150 },
  { name: 'Feedback Bonus', description: 'Bonus for providing feedback.', points: 75 }
]

bonus_data.each do |data|
  Bonus.find_or_create_by!(name: data[:name]) do |bonus|
    bonus.description = data[:description]
    bonus.points = data[:points]
  end
end

points_events_data = [
  { user_id: 1, source_type: 'Bonus', source_id: 1, points: 100 }, # Sign Up Bonus
  { user_id: 1, source_type: 'Reward', source_id: 1, points: -80 }, # Redeemed Tim's Favourite Soup
  { user_id: 1, source_type: 'Bonus', source_id: 2, points: 50 }, # Referral Bonus
  { user_id: 1, source_type: 'Reward', source_id: 2, points: -50 }, # Redeemed 1 Baked Pie
  { user_id: 1, source_type: 'Bonus', source_id: 3, points: 200 }, # Birthday Bonus
  { user_id: 1, source_type: 'Bonus', source_id: 4, points: 150 }, # Anniversary Bonus,
  { user_id: 1, source_type: 'Bonus', source_id: 5, points: 75 }, # Feedback Bonus
  { user_id: 1, source_type: 'Reward', source_id: 3, points: -50 }, # Redeemed Free Brewed Coffee or Tea
  { user_id: 2, source_type: 'Bonus', source_id: 1, points: 100 }, # Sign Up Bonus
  { user_id: 2, source_type: 'Reward', source_id: 4, points: -80 }, # Redeemed Breakfast Wrap
  { user_id: 2, source_type: 'Bonus', source_id: 2, points: 50 }, # Referral Bonus
  { user_id: 2, source_type: 'Bonus', source_id: 3, points: 200 }, # Birthday Bonus
  { user_id: 2, source_type: 'Reward', source_id: 5, points: -50 }, # Redeemed Free Brewed Coffee or Tea
  { user_id: 2, source_type: 'Bonus', source_id: 4, points: 150 }, # Anniversary Bonus
  { user_id: 2, source_type: 'Bonus', source_id: 5, points: 75 }, # Feedback Bonus
  { user_id: 3, source_type: 'Bonus', source_id: 1, points: 100 }, # Sign Up Bonus
  { user_id: 3, source_type: 'Reward', source_id: 6, points: -60 }, # Redeemed Vanilla Cone Pick Up only
  { user_id: 3, source_type: 'Bonus', source_id: 2, points: 50 }, # Referral Bonus
  { user_id: 3, source_type: 'Bonus', source_id: 3, points: 200 }, # Birthday Bonus
  { user_id: 3, source_type: 'Reward', source_id: 7, points: -70 } # Redeemed Any Size Latte
]

points_events_data.each do |data|
  PointsEvent.find_or_create_by!(user_id: data[:user_id], source_type: data[:source_type], source_id: data[:source_id]) do |points_event|
    points_event.points = data[:points]
  end
end

# Update users' points based on their PointsEvents
User.find_each do |user|
  total_points = user.points_events.sum(:points)
  user.update!(points: total_points)
end
