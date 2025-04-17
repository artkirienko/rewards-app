module Api
  module V1
    class RewardsController < ApplicationController
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
        # Redeem reward for current user
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
