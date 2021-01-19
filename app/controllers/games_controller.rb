class GamesController < DfsToolsController
  def index
    @games = gameweek.scheduled_games.includes(:game_lines).order('start_time ASC')
    @team_rankings = TeamRanking.where(gameweek_id: @games.map(&:gameweek_id))

    @games = @games.map do |game|
      game.decorate(team_rankings: @team_rankings)
    end
  end
end
