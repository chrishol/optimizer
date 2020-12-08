class ProjectionChartsController < DfsToolsController
  before_action :load_projection_set, only: %w(index)

  def index
    @players = gameweek.players
    @players = @players.where(position: params[:position]) if filter_params_valid?
    @players = @players.map { |player| player.decorate(projection_set: @projection_set) }
                       .sort_by { |player| [-player.projected_points, -player.price] }
    @players = @players.select(&:has_projection?)
  end
end
