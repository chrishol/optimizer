class BulkOptimizer
  def initialize(optimizer, player_pool)
    @optimizer = optimizer
    @player_pool = player_pool
  end

  def optimal_lineups(number_of_lineups:, broadcast: true)
    optimal_lineups = []
    broadcaster = LineupBroadcaster.new(player_pool) if broadcast

    number_of_lineups.to_i.times do
      lineup = optimal_lineup(excluded_lineups: optimal_lineups)
      optimal_lineups << lineup

      broadcaster.broadcast_lineup(lineup) if broadcast
    end

    optimal_lineups
  end

  private

  attr_reader :player_pool, :optimizer

  def optimal_lineup(excluded_lineups: [])
    if excluded_lineups.empty?
      optimizer.optimal_lineup
    else
      optimizer.reoptimize(excluded_lineups: excluded_lineups).optimal_lineup
    end
  end
end
