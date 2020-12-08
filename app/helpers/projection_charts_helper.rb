module ProjectionChartsHelper
  def projection_bar_data(players)
    {
      labels: players.map(&:name),
      datasets: [{
        data: players.map(&:projected_points)
      }]
    }.to_json.html_safe
  end

  def value_by_projection_scatter_data(players)
    player_data = players.map do |player|
      {
        x: player.projected_value,
        y: player.projected_ownership
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
