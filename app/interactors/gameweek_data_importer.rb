require 'csv'

# Example usage
# ----------------
# path = './tmp/DKSalaries.csv'
# gameweek = Gameweek.find_by(season: 2020, week_number: 7)
# GameweekDataImporter.new(gameweek).import_csv(path)

class GameweekDataImporter
  def initialize(gameweek)
    @gameweek = gameweek
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      team = row[:teamabbrev].downcase
      player_name = row[:name]&.strip
      position = row[:position].downcase
      price = row[:salary]

      Player.where(gameweek: gameweek).find_or_create_by!(dk_id: row[:id]) do |player|
        player.gameweek = gameweek
        player.name = player_name
        player.price = price
        player.team = team
        player.opponent = opponent_finder.opponent(team) || team
        player.game_venue = opponent_finder.game_venue(team) || :neutral
        player.position = position
        player.previous_price = previous_entry_finder.previous_price(player_name, position)
      end
    end
  end

  private

  attr_reader :gameweek

  def opponent_finder
    @opponent_finder ||= OpponentFinder.new(gameweek)
  end

  def previous_entry_finder
    @previous_entry_finder ||= PreviousPlayerEntryFinder.new(gameweek)
  end
end
