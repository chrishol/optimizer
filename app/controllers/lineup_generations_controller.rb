class LineupGenerationsController < ApplicationController
  def create
    player_pool = PlayerPool.find(params[:player_pool_id])
    @lineups = DraftKingsLineupFinder.new.valid_lineups(player_pool.players)
  end
end
