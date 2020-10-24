class CreateGameweeks < ActiveRecord::Migration[6.0]
  def change
    create_table :gameweeks do |t|
      t.integer :season, null: false
      t.integer :week_number, null: false

      t.timestamps
    end
  end
end
