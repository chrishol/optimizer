class PreviousPlayerEntryFinder
  def initialize(gameweek)
    @previous_gameweek = Gameweek.where(
      season: gameweek.season,
      week_number: gameweek.week_number - 1
    ).first
  end

  def previous_price(player_name, position)
    return unless @previous_gameweek.present?

    @previous_gameweek.players.find_by_name_and_position(player_name, position)&.price
  end
end
