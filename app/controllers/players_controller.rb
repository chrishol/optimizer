class PlayersController < DfsToolsController
  skip_before_action :load_gameweek, :load_player_pool, :load_navigable_gameweeks, only: %w(show)

  def index
    @players = Player.left_joins(projections: :projection_set)
                     .where(
                       gameweek_id: gameweek.id,
                       projection_sets: { source: 'Establish the Run' }
                     )
    @players = @players.where(position: params[:position]) if filter_params_valid?
    @players = @players.order('position ASC, projections.projection DESC')
  end

  def show
    @player = Player.find(params[:id])
    @all_player_entries = Player.where(
      name: @player.name,
      team: @player.team,
      position: @player.position
    ).joins(:gameweek).order('gameweeks.week_number ASC')
  end

  private

  def filter_params_valid?
    Player::PLAYER_POSITIONS.include?(params[:position])
  end
end
