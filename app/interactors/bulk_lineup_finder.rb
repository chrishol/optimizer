class BulkLineupFinder
  def initialize(player_pool, projection_set)
    @player_pool = player_pool
    @projection_set = projection_set
  end

  def optimal_lineups(number_of_lineups:, broadcast: true)
    optimal_lineups = []
    broadcaster = LineupBroadcaster.new(player_pool) if broadcast

    number_of_lineups.times do
      lineup = optimal_lineup(player_pool, projection_set, optimal_lineups)
      optimal_lineups << lineup

      broadcaster.broadcast_lineup(lineup) if broadcast
    end

    optimal_lineups
  end

  private

  attr_reader :player_pool, :projection_set

  def optimal_lineup(player_pool, projection_set, excluded_lineups)
    DraftKingsLineupOptimizer.new(
      player_pool,
      projection_set,
      excluded_lineups: excluded_lineups
    ).optimal_lineup
  end
end
