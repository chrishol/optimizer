class CreatePlayerPoolEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :player_pool_entries do |t|
      t.references :player_pool, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
