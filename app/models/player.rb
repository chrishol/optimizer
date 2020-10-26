class Player < ApplicationRecord
  NFL_TEAMS = %w(
    ari atl bal buf car chi cin cle dal den det gb hou ind jax kc lac lar
    lv mia min ne no nyg nyj phi pit sea sf tb ten was
  )
  PLAYER_POSITIONS = %w(qb rb wr te dst)
  FLEX_POSITIONS = %w(rb wr te)

  belongs_to :gameweek

  validates_presence_of :dk_id, :name, :team, :opponent, :price, :position
  validates_inclusion_of :team, :opponent, in: NFL_TEAMS
  validates_inclusion_of :position, in: PLAYER_POSITIONS

  def qb?
    position == 'qb'
  end

  def rb?
    position == 'rb'
  end

  def wr?
    position == 'wr'
  end

  def te?
    position == 'te'
  end

  def flex?
    FLEX_POSITIONS.include?(position)
  end

  def dst?
    position == 'dst'
  end
end
