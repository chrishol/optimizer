class DraftKingsLineupGenerator
  def initialize(player_pool)
    @player_pool = player_pool
  end

  def lineup_iterator
    all_lineups = []

    players.select(&:qb?).each do |qb|
      players.select(&:rb?).combination(2).each do |rbs|
        players.select(&:wr?).combination(3).each do |wrs|
          players.select(&:te?).each do |te|
            players.select(&:flex?).each do |flex|
              next if [te].concat(rbs).concat(wrs).include? flex

              players.select(&:dst?).each do |dst|
                lineup = DraftKingsLineup.new(
                  [qb].concat(rbs).concat(wrs).concat([te, flex, dst])
                )
                next unless lineup.valid? && !all_lineups.include?(lineup) &&
                            lineup_contains_all_locked_players?(lineup)

                all_lineups << lineup
                yield lineup
              end
            end
          end
        end
      end
    end
  end

  private

  attr_reader :player_pool

  def players
    @players ||= player_pool.players.sort_by(&:price).reverse!
  end

  def locked_player_ids
    @locked_player_ids ||= player_pool.player_pool_entries.select(&:is_locked).map(&:player_id)
  end

  def lineup_contains_all_locked_players?(lineup)
    (locked_player_ids - lineup.players.map(&:id)).empty?
  end
end
