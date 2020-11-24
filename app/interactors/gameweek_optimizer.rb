class GameweekOptimizer < DraftKingsLineupOptimizer
  def initialize(gameweek, projection_set, min_price: DEFAULT_MIN_PRICE, excluded_lineups: [])
    @players = gameweek.players
    @projection_set = projection_set
    @min_price = min_price
    @excluded_lineups = excluded_lineups
    @locked_player_ids = []
  end
end
