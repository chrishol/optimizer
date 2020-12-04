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

  def price_change(player)
    return unless player.previous_price.present?

    price_change = player.price - player.previous_price
    return if price_change.zero?

    classes = %w(pl-2)
    if price_change.positive?
      classes << 'text-green-400'
      symbol = '↑'
    else
      classes << 'text-red-400'
      symbol = '↓'
    end

    "<span class='#{classes.join(' ')}'>#{symbol} #{price_change.abs}</span>".html_safe
  end

  def player_line_data(all_player_entries)
    {
      labels: all_player_entries.map(&:gameweek).map(&:week_number),
      datasets: [{
        data: all_player_entries.map(&:price)
      }]
    }.to_json.html_safe
  end

  def player_points_bar_data(player_results)
    {
      labels: player_results.map(&:results_set).map(&:gameweek).map(&:week_number),
      datasets: [{
        data: player_results.map(&:points)
      }]
    }.to_json.html_safe
  end

  def player_ownership_bar_data(player_results)
    {
      labels: player_results.map(&:results_set).map(&:gameweek).map(&:week_number),
      datasets: [{
        data: player_results.map(&:ownership)
      }]
    }.to_json.html_safe
  end

  def fantasy_data_link_url(player)
    uri = URI('https://duckduckgo.com/')
    uri.query = URI.encode_www_form({ 'q' => "!ducky #{player.name} fantasydata"})
    uri.to_s
  end
end
