class DfsToolsController < ApplicationController
  before_action :load_gameweek, :load_player_pool, :load_navigable_gameweeks

  private

  attr_reader :gameweek

  def load_gameweek
    @gameweek = Gameweek.find(params[:gameweek_id])
  end

  def load_player_pool
    @player_pool = PlayerPool.where(gameweek: gameweek)
                             .includes(player_pool_entries: :player)
                             .first || PlayerPool.create(gameweek: gameweek)
  end

  def load_projection_set
    @projection_set = gameweek.projection_sets
                              .includes(:projections)
                              .where(projection_sets: { source: 'Establish the Run' })
                              .last
  end

  def load_navigable_gameweeks
    @navigable_gameweeks = Gameweek.all.order('season ASC, week_number ASC')
  end

  def filter_params_valid?
    Player::PLAYER_POSITIONS.include?(params[:position])
  end
end
