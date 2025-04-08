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
