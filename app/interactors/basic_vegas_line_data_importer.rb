require 'csv'

# Example usage
# ----------------
# path = './tmp/basic_vegas_data.csv'
# gameweek = Gameweek.find_by(season: 2020, week_number: 16)
# BasicVegasLineDataImporter.new(gameweek).import_csv(path)

class BasicVegasLineDataImporter
  DEFAULT_SITE_NAME = 'Reddit'

  def initialize(gameweek)
    @gameweek = gameweek
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      scheduled_game = gameweek.scheduled_games.where(
        home_team: row[:team_name]
      ).first

      is_home_team = scheduled_game.present?
      scheduled_game = gameweek.scheduled_games.where(
        road_team: row[:team_name]
      ).first unless is_home_team

      next unless scheduled_game

      game_line = GameLine.where(scheduled_game: scheduled_game).find_or_initialize_by(site_name: DEFAULT_SITE_NAME)
      game_line.assign_attributes(
        home_spread: is_home_team ? row[:spread] : -row[:spread],
        game_total: row[:game_total],
        home_total: is_home_team ? row[:team_total] : row[:game_total] - row[:team_total],
        road_total: is_home_team ? row[:game_total] - row[:team_total] : row[:team_total]
      )
      game_line.save!
    end
  end

  private

  attr_reader :gameweek
end
