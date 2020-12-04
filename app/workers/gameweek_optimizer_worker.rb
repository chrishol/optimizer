class GameweekOptimizerWorker
  include Sidekiq::Worker

  def perform(gameweek_id, player_pool_id, projection_set_id, number_of_lineups)
    gameweek = Gameweek.find(gameweek_id)
    player_pool = PlayerPool.find(player_pool_id)
    projection_set = ProjectionSet.find(projection_set_id)
    optimizer = GameweekOptimizer.build(gameweek, player_pool, projection_set)

    BulkOptimizer.new(optimizer, player_pool).optimal_lineups(
      number_of_lineups: number_of_lineups,
      broadcast: true
    )
  end
end
