class LineupGenerationsController < ApplicationController
  def create
    LineupGeneratorWorker.perform_async(params[:player_pool_id])
    head :ok
  end
end
