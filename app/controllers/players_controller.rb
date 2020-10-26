class PlayersController < ApplicationController
  def index
    @players = Player.all.order('position ASC, price DESC')
  end
end
