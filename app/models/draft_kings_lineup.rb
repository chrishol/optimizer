class DraftKingsLineup
  SALARY_CAP = 50_000
  QB_COUNT = 1
  RB_COUNT = 2
  WR_COUNT = 3
  TE_COUNT = 1
  FLEX_COUNT = 1
  DST_COUNT = 1
  TOTAL_PLAYER_COUNT = QB_COUNT + RB_COUNT + WR_COUNT + TE_COUNT + FLEX_COUNT + DST_COUNT

  attr_reader :players

  def initialize(players)
    @players = players
  end

  def valid?
    valid_positions? && under_salary_cap?
  end

  def total_price
    players.sum(&:price)
  end

  def stack_description
    qb_team = players.find { |p| p.position == 'qb' }.team
    qb_stack = players.count { |p| %w(wr te).include?(p.position) && p.team == qb_team }
    runback_stack = players.count { |p| %w(wr te).include?(p.position) && p.opponent == qb_team }
    return unless qb_stack > 0

    other_players = players.select { |p| %w(rb wr te).include?(p.position) && p.team != qb_team && p.opponent != qb_team }
    extra_correlation = !(other_players.map(&:team) & other_players.map(&:opponent)).empty?

    description = "#{qb_stack + 1}x#{runback_stack}"
    description += ' ++' if extra_correlation
    description
  end

  def ==(other)
    Set.new(players) == Set.new(other.players)
  end

  def projection(projection_set)
    players.sum do |player|
      projection_set.projections.find { |proj| proj.player_id == player.id }.projection
    end
  end

  private

  attr_writer :players

  def valid_positions? # TODO - Refactor to use FLEX_POSITIOS
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
