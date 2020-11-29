class PlayerPoolEntry < ApplicationRecord
  belongs_to :player_pool
  belongs_to :player

  validates :is_locked, absence: true, if: :is_excluded
end
