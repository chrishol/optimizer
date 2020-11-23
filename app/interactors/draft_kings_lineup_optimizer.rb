class DraftKingsLineupOptimizer
  DEFAULT_MAX_LINEUPS = 5_000

  def initialize(player_pool)
    @player_pool = player_pool
  end

  def optimal_lineup(projection_set)
    optimal_lineup = nil
    optimal_lineup_total = 0
    lineup_count = 0

    catch(:finish) do
      DraftKingsLineupGenerator.new(player_pool).lineup_iterator do |lineup|
        lineup_count += 1
        total = lineup.projection(projection_set)

        if total > optimal_lineup_total
          optimal_lineup_total = total
          optimal_lineup = lineup
        end

        print '.' if lineup_count % 10 == 0

        if lineup_count >= DEFAULT_MAX_LINEUPS
          puts 'Found max lineup count'
          throw :finish
        end
      end
    end

    optimal_lineup
  end

  private

  attr_reader :player_pool
end
