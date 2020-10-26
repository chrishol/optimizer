class Player < ApplicationRecord
  NFL_TEAMS = %w(
    ari atl bal buf car chi cin cle dal den det gb hou ind jax kc lac lar
    lv mia min ne no nyg nyj phi pit sea sf tb ten was
  )
  PLAYER_POSITIONS = %w(qb rb wr te dst)

  belongs_to :gameweek

  validates_presence_of :dk_id, :name, :team, :opponent, :price, :position
  validates_inclusion_of :team, :opponent, in: NFL_TEAMS
  validates_inclusion_of :position, in: PLAYER_POSITIONS
end
