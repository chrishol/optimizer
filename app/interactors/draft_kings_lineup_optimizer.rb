require 'ruby-cbc'

class DraftKingsLineupOptimizer
  DEFAULT_MIN_PRICE = 49_000

  attr_accessor :is_solved

  def initialize(decorated_players,
                 min_price: DEFAULT_MIN_PRICE,
                 excluded_lineups: [],
                 locked_player_ids: [],
                 excluded_player_ids: [])
    @decorated_players = decorated_players
    @min_price = min_price
    @excluded_lineups = excluded_lineups
    @locked_player_ids = locked_player_ids
    @excluded_player_ids = excluded_player_ids
  end

  def reoptimize(excluded_lineups: [])
    self.class.new(
      @decorated_players,
      min_price: @min_price,
      excluded_lineups: excluded_lineups,
      locked_player_ids: @locked_player_ids,
      excluded_player_ids: @excluded_player_ids
    )
  end

  def optimal_lineup
    solve
    DraftKingsLineup.new(
      decorated_players.select do |player|
        problem.value_of(model_variables[player]) > 0
      end
    )
  end

  def optimal_projection
    solve
    problem.objective_value.to_f / 100
  end

  def proven_optimal?
    solve
    problem.proven_optimal?
  end

  private

  attr_reader :problem, :decorated_players, :min_price, :excluded_lineups,
              :locked_player_ids, :excluded_player_ids

  def solve
    return if is_solved

    add_position_constraints
    add_price_constraints
    add_locked_player_constraints
    add_excluded_player_constraints
    add_excluded_lineups_constraints
    maximize_projection
    solve_problem
  end

  def model
    @model ||= Cbc::Model.new
  end

  def solve_problem
    @problem = model.to_problem
    @problem.solve
    @is_solved = true
  end

  def model_variables
    return @model_variables if defined?(@model_variables)

    @model_variables = {}
    decorated_players.each do |player|
      @model_variables[player] = model.bin_var(name: player.id)
    end
    @model_variables
  end

  def add_price_constraints
    model.enforce(
      model_variables.sum do |player, var|
        var * player.price.to_i
      end >= min_price
    )

    model.enforce(
      model_variables.sum do |player, var|
        var * player.price.to_i
      end <= DraftKingsLineup::SALARY_CAP
    )
  end

  def add_position_constraints
    model.enforce(model_variables.values.sum == DraftKingsLineup::TOTAL_PLAYER_COUNT)
    model.enforce(
      model_variables.select { |player, var| player.position == 'qb' }.values.sum == DraftKingsLineup::QB_COUNT
    )
    model.enforce(
      model_variables.select { |player, var| player.position == 'rb' }.values.sum >= DraftKingsLineup::RB_COUNT
    )
    model.enforce(
      model_variables.select { |player, var| player.position == 'rb' }.values.sum <= DraftKingsLineup::RB_COUNT + 1
    )
    model.enforce(
      model_variables.select { |player, var| player.position == 'wr' }.values.sum >= DraftKingsLineup::WR_COUNT
    )
    model.enforce(
      model_variables.select { |player, var| player.position == 'wr' }.values.sum <= DraftKingsLineup::WR_COUNT + 1
    )
    model.enforce(
      model_variables.select { |player, var| player.position == 'te' }.values.sum >= DraftKingsLineup::TE_COUNT
    )
    model.enforce(
      model_variables.select { |player, var| player.position == 'te' }.values.sum <= DraftKingsLineup::TE_COUNT + 1
    )
    model.enforce(
      model_variables.select { |player, var| player.position == 'dst' }.values.sum == DraftKingsLineup::DST_COUNT
    )
  end

  def add_locked_player_constraints
    locked_player_ids.each do |player_id|
      model.enforce(
        model_variables.fetch(
          decorated_players.find { |player, var| player.id == player_id }
        ) == 1
      )
    end
  end

  def add_excluded_player_constraints
    excluded_player_ids.each do |player_id|
      model.enforce(
        model_variables.fetch(
          decorated_players.find { |player, var| player.id == player_id }
        ) == 0
      )
    end
  end

  def add_excluded_lineups_constraints
    excluded_lineups.each do |lineup|
      model.enforce(
        lineup.players.sum { |player| model_variables[player] } <= DraftKingsLineup::TOTAL_PLAYER_COUNT - 1
      )
    end
  end

  def maximize_projection
    model.maximize(
      model_variables.sum do |player, var|
        var * (100 * player.points.to_f).to_i
      end
    )
  end
end
