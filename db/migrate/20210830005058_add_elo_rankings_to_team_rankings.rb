class AddEloRankingsToTeamRankings < ActiveRecord::Migration[6.0]
  def change
    add_column :team_rankings, :elo_rating, :integer
    add_column :team_rankings, :elo_rank, :integer
  end
end
