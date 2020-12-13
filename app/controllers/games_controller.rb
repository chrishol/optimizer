class GamesController < DfsToolsController
  def index
    @games = gameweek.scheduled_games.includes(:game_lines)
  end
end
