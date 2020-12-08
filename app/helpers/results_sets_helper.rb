module ResultsSetsHelper
  def points_by_ownership_scatter_data(players)
    player_data = players.map do |player|
      {
        x: player.actual_points,
        y: player.actual_ownership
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

  def value_by_ownership_scatter_data(players)
    player_data = players.map do |player|
      {
        x: player.actual_value,
        y: player.actual_ownership
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

  def ownership_diff_bar_data(players)
    players = players.sort_by(&:ownership_differential).reverse
    {
      labels: players.map(&:name),
      datasets: [{
        data: players.map(&:ownership_differential)
      }]
    }.to_json.html_safe
  end
end
