class GameweekOptimizer < DraftKingsLineupOptimizer
  def initialize(gameweek, player_pool, projection_set, excluded_lineups: [])
    super(
      gameweek.players,
      projection_set,
      excluded_lineups: excluded_lineups,
      locked_player_ids: player_pool.player_pool_entries.select(&:is_locked).map(&:player_id),
      excluded_player_ids: player_pool.player_pool_entries.select(&:is_excluded).map(&:player_id)
    )
  end
end
