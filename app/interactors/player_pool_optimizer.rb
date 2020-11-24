class PlayerPoolOptimizer < DraftKingsLineupOptimizer
  def initialize(player_pool, projection_set, min_price: DEFAULT_MIN_PRICE, excluded_lineups: [])
    @players = player_pool.players
    @projection_set = projection_set
    @min_price = min_price
    @excluded_lineups = excluded_lineups
    @locked_player_ids = player_pool.player_pool_entries.select(&:is_locked).map(&:player_id)
  end
end
