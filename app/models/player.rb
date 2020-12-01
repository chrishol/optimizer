class Player < ApplicationRecord
  PLAYER_POSITIONS = %w(qb rb wr te dst)
  FLEX_POSITIONS = %w(rb wr te)
  GAME_VENUES = %w(home road neutral)

  belongs_to :gameweek
  has_many :player_pool_entries
  has_many :projections
  has_many :player_results
  has_and_belongs_to_many :entered_lineups

  validates_presence_of :dk_id, :name, :team, :opponent, :price, :position
  validates_inclusion_of :team, :opponent, in: ScheduledGame::NFL_TEAMS
  validates_inclusion_of :position, in: PLAYER_POSITIONS
  validates_inclusion_of :game_venue, in: GAME_VENUES

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
