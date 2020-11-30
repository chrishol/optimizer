class PlayerPoolOptimizerWorker
  # include Sidekiq::Worker

  def perform(player_pool_id, projection_set_id, number_of_lineups)
    player_pool = PlayerPool.find(player_pool_id)
    projection_set = ProjectionSet.find(projection_set_id)
    optimizer = PlayerPoolOptimizer.build(player_pool, projection_set)

    BulkOptimizer.new(optimizer, player_pool).optimal_lineups(
      number_of_lineups: number_of_lineups,
      broadcast: true
    )
  end
end
