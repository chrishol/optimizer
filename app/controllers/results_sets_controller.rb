class ResultsSetsController < DfsToolsController
  before_action :load_results_sets

  def index
  end

  def show
    @results_set = ResultsSet.find(params[:id])
    redirect_to gameweek_results_sets_path(gameweek) unless @results_set.gameweek_id == gameweek.id

    @results = @results_set.player_results.joins(:player)
    @results = @results.where(players: { position: params[:position] }) if filter_params_valid?
  end

  private

  def load_results_sets
    @results_sets = ResultsSet.where(gameweek: gameweek)
  end
end
