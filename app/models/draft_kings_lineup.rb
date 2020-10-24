class DraftKingsLineup
  SALARY_CAP = 50_000
  QB_COUNT = 1
  RB_COUNT = 2
  WR_COUNT = 3
  TE_COUNT = 1
  FLEX_COUNT = 1
  DST_COUNT = 1
  TOTAL_PLAYER_COUNT = QB_COUNT + RB_COUNT + WR_COUNT + TE_COUNT + FLEX_COUNT + DST_COUNT

  def initialize(players)
    @players = players
  end

  def valid?
    valid_positions? && under_salary_cap?
  end

  private

  attr_accessor :players

  def valid_positions?
    return false unless players.count == TOTAL_PLAYER_COUNT

    return false unless players.count { |p| p.position == 'qb' } == QB_COUNT

    return false unless players.count { |p| p.position == 'rb' }.between?(RB_COUNT, RB_COUNT + 1)

    return false unless players.count { |p| p.position == 'wr' }.between?(WR_COUNT, WR_COUNT + 1)

    return false unless players.count { |p| p.position == 'te' }.between?(TE_COUNT, TE_COUNT + 1)

    return false unless players.count { |p| p.position == 'dst' } == DST_COUNT

    true
  end

  def under_salary_cap?
    players.sum(&:price) <= SALARY_CAP
  end
end
