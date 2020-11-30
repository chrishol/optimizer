class OptimizerToolsController < ApplicationController
  before_action :load_gameweek, :load_player_pool, :load_projection_set

  def index
  end

  private

  attr_reader :gameweek

  def load_gameweek
    @gameweek = Gameweek.find(params[:gameweek_id])
  end

  def load_player_pool
    @player_pool = PlayerPool.where(gameweek: gameweek).first_or_create
  end

  def load_projection_set
    @projection_set = gameweek.projection_sets.where(source: 'Establish the Run').first
  end
end
