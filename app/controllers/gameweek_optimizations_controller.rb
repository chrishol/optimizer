class GameweekOptimizationsController < ApplicationController
  def create
    GameweekOptimizerWorker.perform_async(
      params[:gameweek_id],
      params[:player_pool_id],
      params[:projection_set_id],
      params[:number_of_lineups]
    )
    head :ok
  end
end
