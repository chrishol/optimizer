class Player < ApplicationRecord
  belongs_to :gameweek

  validates_presence_of :name, :team, :opponent, :price, :position
end
