require 'csv'

# Example usage
# ----------------
# path = './tmp/DKSalaries.csv'
# gameweek = Gameweek.find_by(season: 2020, week_number: 7)
# importer = GameweekDataImporter.new(gameweek)
# importer.import_csv(path)

class GameweekDataImporter
  def initialize(gameweek)
    @gameweek = gameweek
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      Player.where(gameweek: gameweek).find_or_create_by!(dk_id: row[:id]) do |player|
        player.gameweek = gameweek
        player.name = row[:name]
        player.price = row[:salary]
        player.team = row[:teamabbrev].downcase
        player.opponent = row[:teamabbrev].downcase
        player.position = row[:position].downcase
      end
    end
  end

  private

  attr_reader :gameweek
end
