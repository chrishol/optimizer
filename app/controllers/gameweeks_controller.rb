class GameweeksController < ApplicationController
  def index
    redirect_to gameweek_players_path(most_recent_player.gameweek)
  end

  private

  def most_recent_player
    Player.last
  end
end
