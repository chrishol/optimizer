class DraftKingsLineupGenerator
  def initialize(player_pool)
    @players = player_pool.players.sort_by(&:price).reverse!
  end

  def lineup_iterator
    players.select(&:qb?).each do |qb|
      players.select(&:rb?).combination(2).each do |rbs|
        players.select(&:wr?).combination(3).each do |wrs|
          players.select(&:te?).each do |te|
            players.select(&:flex?).each do |flex|
              next if [te].concat(rbs).concat(wrs).include? flex

              players.select(&:dst?).each do |dst|
                yield DraftKingsLineup.new(
                  [qb].concat(rbs).concat(wrs).concat([te, flex, dst])
                )
              end
            end
          end
        end
      end
    end
  end

  private

  attr_reader :players
end
