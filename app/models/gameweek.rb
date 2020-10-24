class Gameweek < ApplicationRecord
  has_many :players

  validates_presence_of :season, :week_number
end
