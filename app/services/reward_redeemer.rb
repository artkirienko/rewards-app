require "ostruct"

class RewardRedeemer
  def initialize(user, reward)
    @user = user
    @reward = reward
  end

  def call
    return failure("Not enough points") if @user.points < @reward.points

    ActiveRecord::Base.transaction do
      PointsEvent.create!(user: @user, source: @reward, points: -@reward.points)
      @user.update!(points: @user.points - @reward.points)
    end

    success(@user.points, @reward.points)
  rescue ActiveRecord::RecordInvalid => e
    failure(e.message)
  end

  private

  def success(points_left, points_used)
    OpenStruct.new(
      success?: true,
      points_left: points_left,
      points_used: points_used
    )
  end

  def failure(error)
    OpenStruct.new(
      success?: false,
      error: error
    )
  end
end
