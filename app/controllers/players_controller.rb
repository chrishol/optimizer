class PlayersController < ApplicationController
  before_action :load_gameweek, :load_navigable_gameweeks, :load_player_pool

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

  attr_reader :gameweek

  def load_gameweek
    @gameweek = Gameweek.find(params[:gameweek_id])
  end

  def load_player_pool
    @player_pool = PlayerPool.where(gameweek: gameweek).first_or_create
  end

  def load_navigable_gameweeks
    @navigable_gameweeks = Gameweek.all.order('season ASC, week_number ASC')
  end

  def filter_params_valid?
    Player::PLAYER_POSITIONS.include?(params[:position])
  end
end
