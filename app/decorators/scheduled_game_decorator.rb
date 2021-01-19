class ScheduledGameDecorator < SimpleDelegator
  def initialize(scheduled_game, team_rankings: nil)
    super(scheduled_game)
    @home_team_ranking = team_rankings.find { |ranking| ranking.team_name == scheduled_game.home_team }
    @road_team_ranking = team_rankings.find { |ranking| ranking.team_name == scheduled_game.road_team }
  end

  alias_method :scheduled_game, :__getobj__

  def has_home_ranking?
    home_team_ranking.present?
  end

  def has_road_ranking?
    road_team_ranking.present?
  end

  %i(
    off_dvoa_rank
    off_pass_dvoa_rank
    off_rush_dvoa_rank
    def_dvoa_rank
    def_pass_dvoa_rank
    def_rush_dvoa_rank
    etr_ol_rank
    etr_dl_rank
  ).each do |ranking_field|
    delegate ranking_field, to: :home_team_ranking, prefix: :home, allow_nil: true
    delegate ranking_field, to: :road_team_ranking, prefix: :road, allow_nil: true
  end

  private

  attr_reader :home_team_ranking, :road_team_ranking
end
