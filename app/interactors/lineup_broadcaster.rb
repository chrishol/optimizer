class LineupBroadcaster
  def initialize(player_pool)
    @player_pool = player_pool
  end

  def broadcast_lineup(lineup)
    PlayerPoolChannel.broadcast_to(
      player_pool,
      lineup: render_lineup(lineup)
    )
  end

  def broadcast_start
    PlayerPoolChannel.broadcast_to(
      player_pool,
      status_message: 'Finding lineups...'
    )
  end

  def broadcast_end(lineup_count)
    PlayerPoolChannel.broadcast_to(
      player_pool,
      status_message: "#{lineup_count} lineups found"
    )
  end

  def broadcast_max_reached(max_limit)
    PlayerPoolChannel.broadcast_to(
      player_pool,
      status_message: "Maximum limit (#{max_limit}) reached"
    )
  end

  private

  attr_reader :player_pool

  def render_lineup(lineup)
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.render(partial: 'draft_kings_lineups/show', locals: { lineup: lineup })
  end
end
