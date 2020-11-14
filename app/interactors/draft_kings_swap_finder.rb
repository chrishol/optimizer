class DraftKingsSwapFinder
  def initialize(player_pool)
    @player_pool = player_pool
  end

  def swaps(swap_size: 2)
    raise 'Swap size needs to be 2 or more' if swap_size < 2

    swaps = []
    players.combination(swap_size).to_a.combination(2) do |combo1, combo2|
      next unless (combo1 & combo2).empty?

      next unless combo1.sum(&:price) == combo2.sum(&:price)

      next unless combo1.map(&:position).to_set == combo2.map(&:position).to_set

      swaps << DraftKingsSwap.new(combo1, combo2)
    end
    swaps
  end

  private

  attr_reader :player_pool

  def players
    @players ||= player_pool.players.sort_by(&:price).reverse!
  end
end
