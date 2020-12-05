class PlayersController < DfsToolsController
  skip_before_action :load_gameweek, :load_player_pool, :load_navigable_gameweeks, only: %w(show)

  before_action :load_projection_set, only: %w(index)

  def index
    @players = gameweek.players
    @players = @players.where(position: params[:position]) if filter_params_valid?
    @players = @players.map { |player| player.decorate(projection_set: @projection_set) }
                       .sort_by { |player| [-player.projected_points, -player.price] }
  end

  def show
    @player = Player.find(params[:id])
    @all_player_entries = Player.where(
      name: @player.name,
      team: @player.team,
      position: @player.position
    ).joins(:gameweek).order('gameweeks.week_number ASC')

    @player_results_cash = player_results('cash')
    @player_results_gpp = player_results('gpp')
  end

  private

  def filter_params_valid?
    Player::PLAYER_POSITIONS.include?(params[:position])
  end

  def player_results(slate_type)
    PlayerResult.joins(:results_set).joins(:player).joins(player: :gameweek).where(
      players: { id: @all_player_entries.map(&:id) },
      results_sets: { slate_type: slate_type }
    ).order('gameweeks.week_number ASC')
  end
end
