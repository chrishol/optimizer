class StackBuilder
  def initialize(gameweek, projection_set)
    @gameweek = gameweek
    @projection_set = projection_set
  end

  def stack_list
    @stack_list ||= begin
      stacks = []
      players_by_team_and_position.each do |team, player_group|
        opponent = game_opponents[team]

        qb1 = player_group['qb'].first
        wr1 = player_group['wr'].first
        wr2 = player_group['wr'].second
        wr3 = player_group['wr'].third
        te1 = player_group['te'].first

        oppo_wr1 = players_by_team_and_position[opponent]['wr'].first
        oppo_wr2 = players_by_team_and_position[opponent]['wr'].second

        [wr2, wr3, te1].each do |secondary_stack_option|
          [oppo_wr1, oppo_wr2].each do |bring_back_stack_option|
            stack = [qb1, wr1, secondary_stack_option, bring_back_stack_option]
            next unless stack.all? { |player| player.projected_points.positive? }

            stacks << stack
          end
        end
      end
      stacks
    end
  end

  def sorted_stacks_by_points
    stack_list.sort_by { |stack| stack.sum(&:projected_points) }.reverse
  end

  def sorted_stacks_by_value
    stack_list.sort_by { |stack| (stack.sum(&:projected_points) / stack.sum(&:price)) }.reverse
  end

  private

  attr_reader :gameweek, :projection_set

  def decorated_players
    @decorated_players ||= gameweek.players.map do |player|
      player.decorate(projection_set: projection_set)
    end.sort_by(&:projected_points).reverse
  end

  def players_by_team_and_position
    @players_by_team_and_position ||= begin
      decorated_players.group_by(&:team).transform_values do |players|
        players.group_by(&:position)
      end
    end
  end

  def game_opponents
    @game_opponents ||= begin
      gameweek.scheduled_games.flat_map do |game|
        [
          [game.home_team, game.road_team],
          [game.road_team, game.home_team]
        ]
      end.to_h
    end
  end
end
