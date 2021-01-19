module DraftKingsLineupMethods
  PLAYER_POSITION_SORT_ORDER = {
    qb: 0,
    rb: 1,
    wr: 2,
    te: 3,
    dst: 4
  }.with_indifferent_access
  PLAYER_SORT = proc { |player| [PLAYER_POSITION_SORT_ORDER.fetch(player.position), -player.price] }

  def total_price
    players.sum(&:price)
  end

  def total_points
    players.sum(&:points)
  end

  def total_ownership
    players.sum(&:ownership)
  end

  def stack_description
    qb_team = players.find { |p| p.position == 'qb' }.team
    qb_stack = players.count { |p| %w(wr te).include?(p.position) && p.team == qb_team }
    runback_stack = players.count { |p| %w(wr te).include?(p.position) && p.opponent == qb_team }
    return unless qb_stack > 0

    other_players = players.select { |p| %w(rb wr te).include?(p.position) && p.team != qb_team && p.opponent != qb_team }
    extra_correlation = !(other_players.map(&:team) & other_players.map(&:opponent)).empty?

    description = "#{qb_stack + 1}x#{runback_stack}"
    description += '++' if extra_correlation
    description
  end

  def sorted_players
    players.sort_by(&PLAYER_SORT)
  end
end
