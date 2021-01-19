class GameOddsDataImporter
  GAME_TIME_TOLERANCE = 60 * 60 * 96

  def initialize(line_data = nil)
    @line_data = line_data || OddsApiAdapter.new.get_totals_and_spreads
  end

  def import
    @line_data.each do |game_data|
      scheduled_game = ScheduledGame.where(start_time: start_time_tolerance_range(game_data[:start_time]))
                          .where(
                            home_team: team_lookup_hash[game_data[:home_team]],
                            road_team: team_lookup_hash[game_data[:road_team]]
                          ).first
      next unless scheduled_game

      game_data[:lines].each do |line_data|
        game_line = GameLine.where(scheduled_game: scheduled_game).find_or_initialize_by(site_name: line_data[:site_name])
        game_line.assign_attributes(
          home_spread: line_data[:home_spread],
          game_total: line_data[:game_total],
          home_total: line_data[:home_total],
          road_total: line_data[:road_total]
        )
        game_line.save!
      end
    end
  end

  private

  def team_lookup_hash
    ScheduleDataImporter::NFL_TEAM_LOOKUP.transform_values(&:downcase)
  end

  def start_time_tolerance_range(start_time_i)
    Time.at(start_time_i - GAME_TIME_TOLERANCE)..Time.at(start_time_i + GAME_TIME_TOLERANCE)
  end
end
