class PointsEvent < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true

  validates :points,
            presence: true,
            numericality: { only_integer: true }
end
