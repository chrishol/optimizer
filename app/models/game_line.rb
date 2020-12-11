class GameLine < ApplicationRecord
  belongs_to :scheduled_game

  validates_presence_of :home_total, :road_total, :game_total, :home_spread
end
