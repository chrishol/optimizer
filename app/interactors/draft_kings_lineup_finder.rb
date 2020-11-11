class DraftKingsLineupFinder
  DEFAULT_MAX_PRICE = DraftKingsLineup::SALARY_CAP
  DEFAULT_MAX_LINEUPS = 50

  def initialize(min_price: DEFAULT_MAX_PRICE, max_price: DEFAULT_MAX_PRICE)
    @min_price = min_price
    @max_price = max_price
  end

  def valid_lineups(player_pool, broadcast: true, max_lineups: DEFAULT_MAX_LINEUPS)
    lineup_solutions = []
    @broadcaster = LineupBroadcaster.new(player_pool)

    catch(:finish) do
      broadcaster.broadcast_start if broadcast

      DraftKingsLineupGenerator.new(player_pool).lineup_iterator do |lineup|
        next unless min_price <= lineup.total_price &&
                    lineup.total_price <= max_price

        lineup_solutions << lineup
        broadcaster.broadcast_lineup(lineup) if broadcast

        if lineup_solutions.count >= max_lineups
          broadcaster.broadcast_max_reached(max_lineups) if broadcast
          throw :finish
        end
      end

      broadcaster.broadcast_end(lineup_solutions.count) if broadcast
    end

    lineup_solutions
  end

  private

  attr_reader :min_price, :max_price, :broadcaster
end
