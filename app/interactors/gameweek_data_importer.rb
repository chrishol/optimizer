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

      Player.where(gameweek: gameweek).find_or_create_by!(dk_id: row[:id]) do |player|
        player.gameweek = gameweek
        player.name = row[:name]&.strip
        player.price = row[:salary]
        player.team = team
        player.opponent = opponent_finder.opponent(team) || team
        player.game_venue = opponent_finder.game_venue(team) || :neutral
        player.position = row[:position].downcase
      end
    end
  end

  private

  attr_reader :gameweek

  def opponent_finder
    @opponent_finder ||= OpponentFinder.new(gameweek)
  end
end
