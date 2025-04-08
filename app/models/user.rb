class User < ApplicationRecord
  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :email_address,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            length: { maximum: 255 }
  validates :points,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
