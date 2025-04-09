module Api
  module V1
    class RewardsController < ApplicationController
      before_action :authenticate_user!, only: %i[ redeem ]
      before_action :set_reward, only: %i[ show ]

      # GET /rewards
      def index
        @rewards = Reward.all

        render json: @rewards
      end

      # GET /rewards/1
      def show
        render json: @reward
      end

      # POST /rewards/1/redeem
      def redeem
        reward = Reward.find(params.expect(:reward_id))
        result = RewardRedeemer.new(current_user, reward).call

        if result.success?
          render json: {
            message: "Reward redeemed successfully",
            points_left: result.points_left,
            points_used: result.points_used
          }, status: :ok
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_reward
          @reward = Reward.find(params.expect(:id))
        end

        # Only allow a list of trusted parameters through.
        def reward_params
          params.expect(reward: [ :name, :description, :points ])
        end
    end
  end
end
