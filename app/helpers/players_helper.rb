module PlayersHelper
  def player_pool_entry_for(player_pool, player)
    player_pool.player_pool_entries.find { |entry| entry.player_id == player.id } ||
      player_pool.player_pool_entries.build(player: player)
  end

  def game_venue_symbol(player)
    case player.game_venue
    when 'home'
      'vs'
    when 'road'
      '@'
    else
      ''
    end
  end

  def projection_bar_data(players)
    {
      labels: players.map(&:name),
      datasets: [{
        data: players.map { |p| p.projections.first.projection.to_f }
      }]
    }.to_json.html_safe
  end

  def value_by_projection_scatter_data(players)
    player_data = players.map do |player|
      {
        x: player.projections.first.projected_value,
        y: player.projections.first.projected_ownership
      }
    end
    {
      labels: players.map(&:name),
      datasets: [{
        data: player_data,
        pointRadius: 10,
        pointHoverRadius: 12
      }]
    }.to_json.html_safe
  end
end
