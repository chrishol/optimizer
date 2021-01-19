require 'csv'

# Example usage
# ----------------
# path = './tmp/team_ranking_data.csv'
# gameweek = Gameweek.find_by(season: 2020, week_number: 16)
# TeamRankingImporter.new(gameweek).import_csv(path)

class TeamRankingImporter
  def initialize(gameweek)
    @gameweek = gameweek
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      team_name = row[:team_name]

      ranking = TeamRanking.where(gameweek: gameweek).find_or_initialize_by(team_name: team_name)
      ranking.assign_attributes(
        off_dvoa_rank: integer_or_nil(row[:off_dvoa_rank]),
        off_pass_dvoa_rank: integer_or_nil(row[:off_pass_dvoa_rank]),
        off_rush_dvoa_rank: integer_or_nil(row[:off_rush_dvoa_rank]),
        def_dvoa_rank: integer_or_nil(row[:def_dvoa_rank]),
        def_pass_dvoa_rank: integer_or_nil(row[:def_pass_dvoa_rank]),
        def_rush_dvoa_rank: integer_or_nil(row[:def_rush_dvoa_rank]),
        etr_ol_rank: integer_or_nil(row[:etr_ol_rank]),
        etr_dl_rank: integer_or_nil(row[:etr_dl_rank]),
      )
      ranking.save!
    end
  end

  private

  attr_reader :gameweek

  def integer_or_nil(value)
    value ? value.to_i : nil
  end
end
