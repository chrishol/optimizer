class PlayerPoolOptimizer < DraftKingsLineupOptimizer
  def initialize(player_pool, projection_set, excluded_lineups: [])
    super(
      player_pool.players,
      projection_set,
      excluded_lineups: excluded_lineups,
      locked_player_ids: player_pool.player_pool_entries.select(&:is_locked).map(&:player_id)
    )
  end
end
