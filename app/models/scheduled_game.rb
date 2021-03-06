class ScheduledGame < ApplicationRecord
  NFL_TEAMS = %w(
    ari atl bal buf car chi cin cle dal den det gb hou ind jax kc lac lar
    lv mia min ne no nyg nyj phi pit sea sf tb ten was
  )

  belongs_to :gameweek
  has_many :game_lines

  validates_presence_of :start_time, :home_team, :road_team
  validates_inclusion_of :home_team, :road_team, in: NFL_TEAMS

  def decorate(team_rankings: nil)
    ScheduledGameDecorator.new(self, team_rankings: team_rankings)
  end
end
