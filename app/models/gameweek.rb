class Gameweek < ApplicationRecord
  has_many :players
  has_many :player_pools

  validates_presence_of :season, :week_number
end
