class AddIsExcludedToPlayerPoolEntry < ActiveRecord::Migration[6.0]
  def change
    add_column :player_pool_entries, :is_excluded, :boolean, default: false
  end
end
