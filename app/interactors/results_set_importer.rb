require 'csv'

# Example usage
# ----------------
# path = './tmp/contest_results.csv'
# gameweek = Gameweek.find_by(season: 2020, week_number: 11)
# ResultsSetImporter.new(gameweek, 'DraftKings $25 Double Up', 'cash').import_csv(path)

class ResultsSetImporter
  def initialize(gameweek, slate_name, slate_type)
    @gameweek = gameweek
    @slate_name = slate_name
    @slate_type = slate_type
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      player_name = row[:player]

      player = Player.find_by(gameweek: gameweek, name: player_name)
      next unless player

      player_result = PlayerResult.where(results_set: results_set).find_or_create_by!(player: player)
      player_result.update(
        points: row[:fpts],
        ownership: row[:drafted]
      )
    end
  end

  private

  attr_reader :gameweek, :slate_name, :slate_type

  def results_set
    @results_set ||= ResultsSet.where(
      gameweek: gameweek, slate_name: slate_name, slate_type: slate_type
    ).first_or_create
  end
end
