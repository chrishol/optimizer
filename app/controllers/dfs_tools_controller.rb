class DfsToolsController < ApplicationController
  before_action :load_gameweek, :load_player_pool, :load_navigable_gameweeks

  private

  attr_reader :gameweek

  def load_gameweek
    @gameweek = Gameweek.find(params[:gameweek_id])
  end

  def load_player_pool
    @player_pool = PlayerPool.where(gameweek: gameweek).first_or_create
    @player_pool.player_pool_entries.includes(:player)
  end

  def load_navigable_gameweeks
    @navigable_gameweeks = Gameweek.all.order('season ASC, week_number ASC')
  end

  def filter_params_valid?
    Player::PLAYER_POSITIONS.include?(params[:position])
  end
end
