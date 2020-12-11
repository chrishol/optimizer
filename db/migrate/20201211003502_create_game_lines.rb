class CreateGameLines < ActiveRecord::Migration[6.0]
  def change
    create_table :game_lines do |t|
      t.references :scheduled_game, null: false, foreign_key: true
      t.string :site_name
      t.numeric :home_total, precision: 5, scale: 2, null: false
      t.numeric :road_total, precision: 5, scale: 2, null: false
      t.numeric :game_total, precision: 5, scale: 2, null: false
      t.numeric :home_spread, precision: 5, scale: 2, null: false

      t.timestamps
    end
  end
end
