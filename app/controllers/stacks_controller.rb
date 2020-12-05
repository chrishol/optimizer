class StacksController < DfsToolsController
  before_action :load_projection_set, only: %w(index)

  def index
    @stack_builder = StackBuilder.new(gameweek, @projection_set)
  end
end
