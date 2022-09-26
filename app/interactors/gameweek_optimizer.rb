class GameweekOptimizer
  def self.build(gameweek, player_pool, projection_set, excluded_lineups: [], options: {})
    DraftKingsLineupOptimizer.new(
      gameweek.players.map { |player| player.decorate(projection_set: projection_set, options: options) },
      excluded_lineups: excluded_lineups,
      locked_player_ids: player_pool.player_pool_entries.select(&:is_locked).map(&:player_id),
      excluded_player_ids: player_pool.player_pool_entries.select(&:is_excluded).map(&:player_id)
    )
  end
end
