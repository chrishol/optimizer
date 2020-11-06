class OpponentFinder
  def initialize(gameweek)
    @gameweek = gameweek
  end

  def opponent(team)
    opponent_lookup[team]
  end

  private

  attr_reader :gameweek

  def scheduled_games
    @scheduled_games ||= gameweek.scheduled_games
  end

  def opponent_lookup
    @opponent_lookup ||= begin
      lookup_hash = {}
      scheduled_games.each do |game|
        lookup_hash[game.home_team] = game.road_team
        lookup_hash[game.road_team] = game.home_team
      end
      lookup_hash
    end
  end
end
