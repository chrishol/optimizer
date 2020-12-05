class PlayerDecorator < SimpleDelegator
  def initialize(player, projection_set: nil, results_set: nil)
    super(player)
    @projection_set = projection_set
    @results_set = results_set
  end

  alias_method :player, :__getobj__

  def projected_points
    @projected_points ||= projection&.projection || 0
  end

  def projected_ownership
    @projected_ownership ||= projection&.projected_ownership || 0
  end

  def projected_value
    @projected_value ||= projection&.projected_value || 0
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
