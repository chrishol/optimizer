class PlayerPool < ApplicationRecord
  belongs_to :gameweek
  has_many :player_pool_entries

  def players
    player_pool_entries.includes(:player).map(&:player)
  end

end
