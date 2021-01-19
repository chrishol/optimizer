class PlayerDecorator < SimpleDelegator
  def initialize(player, projection_set: nil, results_set: nil)
    super(player)
    @projection_set = projection_set
    @results_set = results_set
  end

  alias_method :player, :__getobj__

  def has_projection?
    projection.present?
  end

  def has_result?
    player_result.present?
  end

  def points
    has_result? ? actual_points : projected_points
  end

  def ownership
    has_result? ? actual_ownership : projected_ownership
  end

  def value
    has_result? ? actual_value : projected_value
  end

  def projected_points
    @projected_points ||= projection&.projection || 0
  end

  def projected_ownership
    @projected_ownership ||= projection&.projected_ownership || 0
  end

  def projected_value
    @projected_value ||= projection&.projected_value || 0
  end

  def actual_ownership
    @actual_ownership ||= player_result&.ownership || 0
  end

  def actual_points
    @actual_points ||= player_result&.points || 0
  end

  def actual_value
    @actual_value ||= begin
      (1000 * actual_points.to_f / price).round(2)
    end
  end

  def ownership_differential
    actual_ownership - projected_ownership
  end

  private

  attr_reader :projection_set, :results_set

  def projection
    @projection ||= begin
      return unless projection_set

      projection_set.projections.find do |projection|
        projection.player_id == player.id
      end
    end
  end

  def player_result
    @player_result ||= begin
      return unless results_set

      results_set.player_results.find do |result|
        result.player_id == player.id
      end
    end
  end
end
