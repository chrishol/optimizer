class ResultsSetsController < DfsToolsController
  USERNAMES_OF_INTEREST = %w(
    clhol TheHumanCespedes CSURAM88 AdamLevitan Dinkpiece EmpireMaker2 Makisupa Daut44
    DavisMattek changsveeshuskies leonem revertzeetop uncbluehen Awesemo
  )
  before_action :load_results_sets

  before_action :load_projection_set, only: %w(show)

  def index
  end

  def show
    @results_set = ResultsSet.find(params[:id])
    redirect_to gameweek_results_sets_path(gameweek) unless @results_set.gameweek_id == gameweek.id

    @players = gameweek.players
    @players = @players.where(position: params[:position]) if filter_params_valid?
    @players = @players.map do |player|
                 player.decorate(
                   projection_set: @projection_set,
                   results_set: @results_set
                 )
               end
    @players = @players.select(&:has_result?)

    @lineups_to_display = @results_set.entered_lineups.where('slate_rank <= 10').limit(10).order('slate_rank ASC').to_a
    @lineups_to_display = @lineups_to_display.concat(
      @results_set.entered_lineups.where(entry_name: USERNAMES_OF_INTEREST).order('slate_rank ASC').to_a
    )
  end

  private

  def load_results_sets
    @results_sets = ResultsSet.where(gameweek: gameweek)
  end
end
