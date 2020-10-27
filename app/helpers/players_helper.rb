module PlayersHelper
  def player_pool_entry_for(player_pool, player)
    player_pool.player_pool_entries.find { |entry| entry.player_id == player.id } ||
      player_pool.player_pool_entries.build(player: player)
  end
end
