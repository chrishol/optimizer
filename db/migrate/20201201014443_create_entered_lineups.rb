class CreateEnteredLineups < ActiveRecord::Migration[6.0]
  def change
    create_table :entered_lineups do |t|
      t.references :results_set, null: false, foreign_key: true
      t.integer :slate_rank, null: false
      t.string :entry_name, null: false
      t.numeric :points, precision: 5, scale: 2, default: 0

      t.timestamps
    end

    create_table :entered_lineups_players, id: false do |t|
      t.references :entered_lineup, null: false, foreign_key: true,index: true
      t.references :player, null: false, foreign_key: true, index: true
    end
  end
end
