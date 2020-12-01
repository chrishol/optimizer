class CreatePlayerResults < ActiveRecord::Migration[6.0]
  def change
    create_table :player_results do |t|
      t.references :results_set, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.numeric :ownership, precision: 5, scale: 2, default: 0
      t.numeric :points, precision: 5, scale: 2, default: 0

      t.timestamps
    end
  end
end
