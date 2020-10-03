class DraftKingsLineupFinder
  DEFAULT_MAX_PRICE = 50_000

  def initialize(min_price:, max_price: DEFAULT_MAX_PRICE)
    @min_price = min_price
    @max_price = max_price
  end

  def valid_lineups(price_position_data)
    lineup_solutions = []
    @price_position_data = price_position_data

    quarterbacks.each do |qb_data|
      running_backs.each do |rb_data|
        total_price = qb_data[:price].to_i + rb_data[:price].to_i
        if total_price >= min_price && total_price <= max_price
          lineup_solutions << [
            qb_data[:key], rb_data[:key]
          ]
        end
      end
    end

    lineup_solutions
  end

  private

  attr_reader :min_price, :max_price, :price_position_data

  def quarterbacks
    price_position_data.select do |data|
      data[:position] == "QB"
    end
  end

  def running_backs
    price_position_data.select do |data|
      data[:position] == "RB"
    end
  end
end
