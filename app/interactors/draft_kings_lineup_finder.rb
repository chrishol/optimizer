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

  def initialize(min_price:, max_price: DEFAULT_MAX_PRICE)
    @min_price = min_price
    @max_price = max_price
  end

  def valid_lineups(players)
    lineup_solutions = []
    @players = players

    players.select(&:qb?).each do |qb|
      players.select(&:rb?).combination(2).each do |rbs|
        players.select(&:wr?).combination(3).each do |wrs|
          players.select(&:te?).each do |te|
            players.select(&:flex?).each do |flex|
              next if [te].concat(rbs).concat(wrs).include? flex

              players.select(&:dst?).each do |dst|
                current_lineup = DraftKingsLineup.new(
                  [qb].concat(rbs).concat(wrs).concat([te, flex, dst])
                )
                if current_lineup.valid? && !lineup_solutions.include?(current_lineup)
                  lineup_solutions << current_lineup
                end
              end
            end
          end
        end
      end
    end

    lineup_solutions
  end

  private

  attr_reader :min_price, :max_price
end
