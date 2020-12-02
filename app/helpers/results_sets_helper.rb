module ResultsSetsHelper
  def points_by_ownership_scatter_data(results)
    player_data = results.map do |result|
      {
        x: result.points,
        y: result.ownership
      }
    end
    {
      labels: results.map(&:player).map(&:name),
      datasets: [{
        data: player_data,
        pointRadius: 10,
        pointHoverRadius: 12
      }]
    }.to_json.html_safe
  end

  def value_by_ownership_scatter_data(results)
    player_data = results.map do |result|
      {
        x: (1000 * result.points / result.player.price).round(2),
        y: result.ownership
      }
    end
    {
      labels: results.map(&:player).map(&:name),
      datasets: [{
        data: player_data,
        pointRadius: 10,
        pointHoverRadius: 12
      }]
    }.to_json.html_safe
  end
end
