class BonusesController < ApplicationController
  before_action :set_bonus, only: %i[ show update destroy ]

  # GET /bonuses
  def index
    @bonuses = Bonus.all

    render json: @bonuses
  end

  # GET /bonuses/1
  def show
    render json: @bonus
  end

  # POST /bonuses
  def create
    @bonus = Bonus.new(bonus_params)

    if @bonus.save
      render json: @bonus, status: :created, location: @bonus
    else
      render json: @bonus.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bonuses/1
  def update
    if @bonus.update(bonus_params)
      render json: @bonus
    else
      render json: @bonus.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bonuses/1
  def destroy
    @bonus.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bonus
      @bonus = Bonus.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bonus_params
      params.expect(bonus: [ :name, :description, :points ])
    end
end
