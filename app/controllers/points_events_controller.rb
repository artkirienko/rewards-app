class PointsEventsController < ApplicationController
  before_action :set_points_event, only: %i[ show update destroy ]

  # GET /points_events
  def index
    @points_events = PointsEvent.all

    render json: @points_events
  end

  # GET /points_events/1
  def show
    render json: @points_event
  end

  # POST /points_events
  def create
    @points_event = PointsEvent.new(points_event_params)

    if @points_event.save
      render json: @points_event, status: :created, location: @points_event
    else
      render json: @points_event.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /points_events/1
  def update
    if @points_event.update(points_event_params)
      render json: @points_event
    else
      render json: @points_event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /points_events/1
  def destroy
    @points_event.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_points_event
      @points_event = PointsEvent.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def points_event_params
      params.expect(points_event: [ :user_id, :source_id, :source_type, :points ])
    end
end
