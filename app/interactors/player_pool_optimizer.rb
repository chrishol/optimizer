class PlayerPoolOptimizer
  def self.build(player_pool, projection_set, excluded_lineups: [])
    DraftKingsLineupOptimizer.new(
      player_pool.players.map { |player| player.decorate(projection_set: projection_set) },
      excluded_lineups: excluded_lineups,
      locked_player_ids: player_pool.player_pool_entries.select(&:is_locked).map(&:player_id)
    )
  end
end
