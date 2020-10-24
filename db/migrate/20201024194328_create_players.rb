class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.references :gameweek, null: false, foreign_key: true
      t.string :name, null: false
      t.string :team, null: false
      t.string :opponent, null: false
      t.integer :price, null: false
      t.string :position, null: false

      t.timestamps
    end
  end
end
