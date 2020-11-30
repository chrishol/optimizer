class OptimizerToolsController < DfsToolsController
  before_action :load_projection_set

  def index
  end

  private

  def load_projection_set
    @projection_set = gameweek.projection_sets.where(source: 'Establish the Run').first
  end
end
