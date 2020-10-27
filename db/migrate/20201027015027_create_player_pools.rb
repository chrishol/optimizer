class CreatePlayerPools < ActiveRecord::Migration[6.0]
  def change
    create_table :player_pools do |t|
      t.references :gameweek, null: false, foreign_key: true

      t.timestamps
    end
  end
end
