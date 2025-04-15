class Reward < ApplicationRecord
  has_many :points_events, as: :source, dependent: :destroy

  validates :name,
            presence: true,
            length: { maximum: 255 }
  validates :description,
            presence: true,
            length: { maximum: 500 }
  validates :points,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
