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
      next if team == 'fa' # Skip free agents

      player_name = row[:name]&.strip
      position = row[:position].downcase
      price = row[:salary]

      player = Player.where(gameweek: gameweek).find_or_initialize_by(dk_id: row[:id])
      player.assign_attributes(
        name: player_name,
        price: price,
        team: team,
        opponent: opponent_finder.opponent(team) || team,
        game_venue: opponent_finder.game_venue(team) || :neutral,
        position: position,
        previous_price: previous_entry_finder.previous_price(player_name, position)
      )
      player.save!
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
