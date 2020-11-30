class PlayerPoolOptimizationsController < ApplicationController
  def create
    PlayerPoolOptimizerWorker.perform_async(
      params[:player_pool_id],
      params[:projection_set_id],
      params[:number_of_lineups]
    )
    head :ok
  end
end
