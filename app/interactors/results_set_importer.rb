require 'csv'

# Example usage
# ----------------
# path = './tmp/contest_results.csv'
# gameweek = Gameweek.find_by(season: 2020, week_number: 12)
# ResultsSetImporter.new(gameweek, 'DraftKings $50 Red Zone', 'gpp').import_csv(path)

class ResultsSetImporter
  def initialize(gameweek, slate_name, slate_type)
    @gameweek = gameweek
    @slate_name = slate_name
    @slate_type = slate_type
  end

  def import_csv(csv_path)
    CSV.table(csv_path).each do |row|
      player_name = row[:player]

      if player_name.present? && (player = Player.find_by(gameweek: gameweek, name: player_name))
        player_result = PlayerResult.where(results_set: results_set).find_or_create_by!(player: player)
        player_result.update(
          points: row[:fpts],
          ownership: row[:drafted]
        )
      end

      entry_id = row[:entryid]
      lineup_string = row[:lineup]

      if entry_id.present? && lineup_string.present?
        entered_lineup = EnteredLineup.where(results_set: results_set).find_or_initialize_by(entry_id: entry_id)
        entered_lineup.assign_attributes(
          points: row[:points],
          entry_name: row[:entryname],
          slate_rank: row[:rank],
          players: find_players(lineup_string)
        )
        entered_lineup.save!
      end
    end
  end

  private

  LINEUP_DIVIDERS = %w(QB RB WR TE FLEX DST)

  attr_reader :gameweek, :slate_name, :slate_type

  def results_set
    @results_set ||= ResultsSet.where(
      gameweek: gameweek, slate_name: slate_name, slate_type: slate_type
    ).first_or_create
  end

  def find_players(lineup_string)
    player_names = [lineup_string]

    LINEUP_DIVIDERS.each do |divider|
      player_names = player_names.flat_map { |w| w.split(divider) }
    end

    player_names = player_names.map(&:strip).select(&:present?)

    Player.where(gameweek: gameweek, name: player_names)
  end
end
