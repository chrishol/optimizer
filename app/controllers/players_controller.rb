class PlayersController < ApplicationController
  before_action :load_gameweek, :load_navigable_gameweeks, :load_player_pool

  def index
    @players = gameweek.players.order('position ASC, price DESC')
  end

  private

  attr_reader :gameweek

  def load_gameweek
    @gameweek = Gameweek.find(params[:gameweek_id])
  end

  def load_player_pool
    @player_pool = PlayerPool.first_or_create(gameweek: gameweek)
  end

  def load_navigable_gameweeks
    @navigable_gameweeks = Gameweek.all.order('season ASC, week_number ASC')
  end
end
