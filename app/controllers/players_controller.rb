class PlayersController < DfsToolsController
  def index
    @players = Player.left_joins(projections: :projection_set)
                     .where(
                       gameweek_id: gameweek.id,
                       projection_sets: { source: 'Establish the Run' }
                     )
    @players = @players.where(position: params[:position]) if filter_params_valid?
    @players = @players.order('position ASC, projections.projection DESC')
  end

  private

  def filter_params_valid?
    Player::PLAYER_POSITIONS.include?(params[:position])
  end
end
