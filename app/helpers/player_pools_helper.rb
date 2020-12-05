module PlayerPoolsHelper
  def entry_bg_color(entry)
    if entry.is_locked
      'bg-yellow-400'
    elsif entry.is_excluded
      'bg-red-400'
    else
      'bg-gray-400'
    end
  end
end
