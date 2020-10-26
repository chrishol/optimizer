class GameweeksController < ApplicationController
  before_action :load_navigable_gameweeks

  def index
  end

  private

  def load_navigable_gameweeks
    @navigable_gameweeks = Gameweek.all.order('season ASC, week_number ASC')
  end
end
