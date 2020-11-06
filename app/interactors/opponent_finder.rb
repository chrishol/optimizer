class OpponentFinder
  def initialize(gameweek)
    @gameweek = gameweek
  end

  def opponent(team)
    opponent_lookup.dig(team, :team)
  end

  def game_venue(team)
    opponent_lookup.dig(team, :game_venue)
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
        lookup_hash[game.home_team] = { team: game.road_team, game_venue: :home }
        lookup_hash[game.road_team] = { team: game.home_team, game_venue: :road }
      end
      lookup_hash
    end
  end
end
