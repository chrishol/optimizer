class AddLockedToPlayerPoolEntry < ActiveRecord::Migration[6.0]
  def change
    add_column :player_pool_entries, :is_locked, :boolean, default: false
  end
end
