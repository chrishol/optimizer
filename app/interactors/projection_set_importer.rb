require 'csv'

# Example usage
# ----------------
# path = './tmp/etr_projections.csv'
# gameweek = Gameweek.find_by(season: 2020, week_number: 11)
# ProjectionSetImporter.new(gameweek).import_csv(path)

class ProjectionSetImporter
  ETR_SOURCE = 'Establish the Run'

  def initialize(gameweek)
    @gameweek = gameweek
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      dk_id = row[:dkslateid]

      player = Player.find_by(gameweek: gameweek, dk_id: dk_id)
      next unless player

      projection = Projection.where(projection_set: projection_set).find_or_create_by!(player: player)
      projection.update(
        projection: row[:dk_projection],
        projected_value: row[:dk_value],
        projected_ownership: row[:dk_ownership]
      )
    end
  end

  private

  attr_reader :gameweek

  def projection_set
    @projection_set ||= ProjectionSet.where(gameweek: gameweek).find_or_create_by!(source: ETR_SOURCE)
  end
end
