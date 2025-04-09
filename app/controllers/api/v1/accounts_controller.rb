module Api
  module V1
    class AccountsController < ApplicationController
      # GET /account
      def show
        render json: current_user.slice(:name, :email_address)
      end

      # GET /account/balance
      def balance
        render json: current_user.slice(:points)
      end

      # GET /account/history
      def history
        events = PointsEvent.includes(:source).where(user: current_user).order(created_at: :desc)
        history = events.map do |event|
          {
            points: event.points,
            type: event.source_type,
            name: event.source.name,
            description: event.source.description,
            created_at: event.created_at
          }
        end
        render json: history.as_json(only: [ :points, :type, :name, :description, :created_at ])
      end

      private
        def current_user
          User.first
        end
    end
  end
end
