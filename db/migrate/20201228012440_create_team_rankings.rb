class CreateTeamRankings < ActiveRecord::Migration[6.0]
  def change
    create_table :team_rankings do |t|
      t.references :gameweek, null: false, foreign_key: true
      t.string :team_name
      t.integer :off_dvoa_rank
      t.integer :off_pass_dvoa_rank
      t.integer :off_rush_dvoa_rank
      t.integer :def_dvoa_rank
      t.integer :def_pass_dvoa_rank
      t.integer :def_rush_dvoa_rank
      t.integer :etr_ol_rank
      t.integer :etr_dl_rank

      t.timestamps
    end
  end
end
