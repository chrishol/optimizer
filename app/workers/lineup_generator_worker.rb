class LineupGeneratorWorker
  include Sidekiq::Worker

  def perform(player_pool_id)
    player_pool = PlayerPool.find(player_pool_id)
    DraftKingsLineupFinder.new.valid_lineups(player_pool)
  end
end
