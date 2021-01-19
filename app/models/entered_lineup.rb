class EnteredLineup < ApplicationRecord
  include DraftKingsLineupMethods

  belongs_to :results_set
  has_and_belongs_to_many :players

  validates_presence_of :slate_rank, :entry_name

  def players
    return @decorated_players if defined?(@decorated_players)

    @decorated_players = super.map do |player|
      player.decorate(results_set: results_set)
    end.sort_by(&PLAYER_SORT)
  end
end
