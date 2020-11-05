class CreateScheduledGames < ActiveRecord::Migration[6.0]
  def change
    create_table :scheduled_games do |t|
      t.references :gameweek, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.column :home_team, :nfl_team, null: false
      t.column :road_team, :nfl_team, null: false

      t.timestamps
    end
  end
end
