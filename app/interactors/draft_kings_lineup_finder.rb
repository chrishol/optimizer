class DraftKingsLineupFinder
  # TODO:
  # Create error class for too large a data set
  # Expand to 2x RBs
  # Expand to 3x WRs
  # Expand to 1x TEs
  # Expand to 1x DSTs
  # Expand to 1x FLEX
  # Allow lock buttons on players

  DEFAULT_MAX_PRICE = DraftKingsLineup::SALARY_CAP
  DEFAULT_MAX_LINEUPS = 50

  def initialize(min_price: DEFAULT_MAX_PRICE, max_price: DEFAULT_MAX_PRICE)
    @min_price = min_price
    @max_price = max_price
  end

  def valid_lineups(player_pool, broadcast: true, max_lineups: DEFAULT_MAX_LINEUPS)
    lineup_solutions = []
    @players = player_pool.players.sort_by(&:price).reverse!
    @broadcaster = LineupBroadcaster.new(player_pool)

    catch(:finish) do
      broadcaster.broadcast_start if broadcast
      players.select(&:qb?).each do |qb|
        players.select(&:rb?).combination(2).each do |rbs|
          players.select(&:wr?).combination(3).each do |wrs|
            players.select(&:te?).each do |te|
              players.select(&:flex?).each do |flex|
                next if [te].concat(rbs).concat(wrs).include? flex

                players.select(&:dst?).each do |dst|
                  if lineup_solutions.count >= max_lineups
                    broadcaster.broadcast_max_reached(max_lineups) if broadcast
                    throw :finish
                  end

                  current_lineup = DraftKingsLineup.new(
                    [qb].concat(rbs).concat(wrs).concat([te, flex, dst])
                  )
                  next unless current_lineup.valid? &&
                              !lineup_solutions.include?(current_lineup) &&
                              min_price <= current_lineup.total_price &&
                              current_lineup.total_price <= max_price

                  lineup_solutions << current_lineup

                  broadcaster.broadcast_lineup(current_lineup) if broadcast
                end
              end
            end
          end
        end
      end
      broadcaster.broadcast_end(lineup_solutions.count) if broadcast
    end

    lineup_solutions
  end

  private

  attr_reader :min_price, :max_price, :players, :broadcaster
end
