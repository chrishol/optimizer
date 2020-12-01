class Gameweek < ApplicationRecord
  has_many :players
  has_many :player_pools
  has_many :scheduled_games
  has_many :projection_sets
  has_many :results_sets

  validates_presence_of :season, :week_number
end
