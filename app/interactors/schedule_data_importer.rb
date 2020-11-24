require 'csv'

# Example usage (data from Pro Football Reference)
# ---------------------------------------------------
# path = './tmp/schedule.csv'
# importer = ScheduleDataImporter.new(2020)
# importer.import_csv(path)

class ScheduleDataImporter
  NFL_TEAM_LOOKUP = {
    'Arizona Cardinals': 'ARI',
    'Atlanta Falcons': 'ATL',
    'Baltimore Ravens': 'BAL',
    'Buffalo Bills': 'BUF',
    'Carolina Panthers': 'CAR',
    'Chicago Bears': 'CHI',
    'Cincinnati Bengals': 'CIN',
    'Cleveland Browns': 'CLE',
    'Dallas Cowboys': 'DAL',
    'Denver Broncos': 'DEN',
    'Detroit Lions': 'DET',
    'Green Bay Packers': 'GB',
    'Houston Texans': 'HOU',
    'Indianapolis Colts': 'IND',
    'Jacksonville Jaguars': 'JAX',
    'Kansas City Chiefs': 'KC',
    'Miami Dolphins': 'MIA',
    'Minnesota Vikings': 'MIN',
    'New England Patriots': 'NE',
    'New Orleans Saints': 'NO',
    'New York Giants': 'NYG',
    'New York Jets': 'NYJ',
    'Las Vegas Raiders': 'LV',
    'Philadelphia Eagles': 'PHI',
    'Pittsburgh Steelers': 'PIT',
    'Los Angeles Chargers': 'LAC',
    'San Francisco 49ers': 'SF',
    'Seattle Seahawks': 'SEA',
    'Los Angeles Rams': 'LAR',
    'Tampa Bay Buccaneers': 'TB',
    'Tennessee Titans': 'TEN',
    'Washington Football Team': 'WAS'
  }.with_indifferent_access

  def initialize(season_year)
    @season_year = season_year
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      gameweek = Gameweek.where(
        season: season_year,
        week_number: row[:week]
      ).first_or_create!

      if row[:homeroad] == '@'
        home_team = row[:losertie]
        road_team = row[:winnertie]
      else
        home_team = row[:winnertie]
        road_team = row[:losertie]
      end

      start_time = Time.find_zone("America/New_York").parse(
        "#{row[:date]}, #{season_year} #{row[:time]}"
      )
      start_time += 1.year if start_time.month < 6

      ScheduledGame.where(gameweek: gameweek).find_or_create_by!(
        home_team: NFL_TEAM_LOOKUP[home_team].downcase,
        road_team: NFL_TEAM_LOOKUP[road_team].downcase
      ) do |game|
        game.gameweek = gameweek
        game.start_time = start_time
      end
    end
  end

  private

  attr_reader :season_year
end
