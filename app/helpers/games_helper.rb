module GamesHelper
  # https://www.rubydoc.info/github/rubyworks/facets/Array:median
  def median(array, offset=0)
    return nil if array.size == 0

    tmp = array.sort
    mid = (tmp.size / 2).to_i + offset

    tmp[mid]
  end

  def median_points_total(scheduled_game, total = :game)
    median_total = 0

    unless scheduled_game.game_lines.empty?
      case total
      when :game
        median_total = median(
          scheduled_game.game_lines.map(&:game_total)
        )
      when :home
        median_total = median(
          scheduled_game.game_lines.map(&:home_total)
        )
      when :road
        median_total = median(
          scheduled_game.game_lines.map(&:road_total)
        )
      end
    end

    median_total.round(2)
  end

  def points_total_range(scheduled_game, total = :game)
    low_total = 0
    high_total = 0

    unless scheduled_game.game_lines.empty?
      case total
      when :game
        low_total = scheduled_game.game_lines.map(&:game_total).min
        high_total = scheduled_game.game_lines.map(&:game_total).max
      when :home
        low_total = scheduled_game.game_lines.map(&:home_total).min
        high_total = scheduled_game.game_lines.map(&:home_total).max
      when :road
        low_total = scheduled_game.game_lines.map(&:road_total).min
        high_total = scheduled_game.game_lines.map(&:road_total).max
      end
    end

    "#{low_total.round(2)} to #{high_total.round(2)}"
  end
end
