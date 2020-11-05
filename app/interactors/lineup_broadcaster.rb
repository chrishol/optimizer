class LineupBroadcaster
  def initialize(player_pool)
    @player_pool = player_pool
  end

  def broadcast(lineup)
    PlayerPoolChannel.broadcast_to(
      player_pool,
      lineup: render_lineup(lineup)
    )
  end

  private

  attr_reader :player_pool

  def render_lineup(lineup)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(partial: 'draft_kings_lineups/show', locals: { lineup: lineup })
  end
end
