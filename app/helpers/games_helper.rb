module GamesHelper
  # https://www.rubydoc.info/github/rubyworks/facets/Array:median
  def median(array, offset=0)
    return nil if array.size == 0

    tmp = array.sort
    mid = (tmp.size / 2).to_i + offset

    tmp[mid]
  end

  def median_points_total(scheduled_game, total = :game)
    return if scheduled_game.game_lines.empty?

    median_total = nil
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

    median_total&.round(2)
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

  def team_ranking_table_classes(rank)
    classes = %w(px-4 text-right font-mono)
    case rank
    when 1..4
      classes.concat %w(bg-green-300 border-2 border-white)
    when 5..8
      classes.concat %w(bg-green-200 border-2 border-white)
    when 9..16
      classes.concat %w(bg-green-100 border-2 border-white)
    when 17..24
      classes.concat %w(bg-red-100 border-2 border-white)
    when 25..32
      classes.concat %w(bg-red-200 border-2 border-white)
    end
    classes.join(' ')
  end

  def game_total_table_classes(total)
    classes = %w(px-4 text-right font-mono)
    case total
    when 55.0..Float::INFINITY
      classes.concat %w(bg-green-300 border-2 border-white)
    when 50.0...55.0
      classes.concat %w(bg-green-200 border-2 border-white)
    when 45.0...50.0
      classes.concat %w(bg-green-100 border-2 border-white)
    when 40.0...45.0
      classes.concat %w(bg-red-100 border-2 border-white)
    when 20.0...40.0
      classes.concat %w(bg-red-200 border-2 border-white)
    else
      classes.concat %w(border-b border-gray-200)
    end
    classes.join(' ')
  end

  def team_total_table_classes(total)
    classes = %w(px-4 text-right font-mono)
    case total
    when 27.5..Float::INFINITY
      classes.concat %w(bg-green-300 border-2 border-white)
    when 25.0...27.5
      classes.concat %w(bg-green-200 border-2 border-white)
    when 22.5...25.0
      classes.concat %w(bg-green-100 border-2 border-white)
    when 20.0...22.5
      classes.concat %w(bg-red-100 border-2 border-white)
    when 10.0...20.0
      classes.concat %w(bg-red-200 border-2 border-white)
    end
    classes.join(' ')
  end
end
